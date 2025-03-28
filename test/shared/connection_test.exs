testcases_file = "test/support/shared-client-testcases/connection_testcases.json"

# required to ensure the existence of atoms during test setup
_tls_security_values = ~w(insecure no_host_verification strict default)a

if File.exists?(testcases_file) do
  defmodule Tests.Shared.ConnectionTest do
    use Tests.Support.SharedCase, async: false

    alias Gel.Connection.Config

    require Logger

    @cases read_testcases(testcases_file)
    @moduletag :connection

    @case_to_client_errors %{
      "credentials_file_not_found" => {RuntimeError, message: ~r/could not read/},
      "project_not_initialised" =>
        {Gel.Error,
         type: Gel.ClientConnectionError,
         name: "ClientConnectionError",
         message: ~r/found "(gel|edgedb).toml" but the project is not initialized/},
      "no_options_or_toml" =>
        {Gel.Error,
         type: Gel.ClientConnectionError,
         name: "ClientConnectionError",
         message: ~r/no "gel.toml" or "edgedb.toml" found and no connection options specified/},
      "invalid_credentials_file" => {RuntimeError, message: ~r/invalid credentials/},
      "invalid_dsn_or_instance_name" => {RuntimeError, message: ~r/invalid DSN or instance name/},
      "invalid_instance_name" => {RuntimeError, message: ~r/invalid instance name/},
      "invalid_dsn" => {RuntimeError, message: ~r/invalid DSN or instance name/},
      "unix_socket_unsupported" => {RuntimeError, message: ~r/unix socket paths not supported/},
      "invalid_host" => {RuntimeError, message: ~r/invalid host/},
      "invalid_port" => {RuntimeError, message: ~r/invalid port/},
      "invalid_user" => {RuntimeError, message: ~r/invalid user/},
      "invalid_database" => {RuntimeError, message: ~r/invalid database/},
      "multiple_compound_env" => {
        Gel.Error,
        type: Gel.ClientConnectionError,
        name: "ClientConnectionError",
        message: ~r/can not have more than one of the following connection environment variables/
      },
      "multiple_compound_opts" => {
        Gel.Error,
        type: Gel.ClientConnectionError,
        name: "ClientConnectionError",
        message: ~r/can not have more than one of the following connection options/
      },
      "exclusive_options" => {
        Gel.Error,
        type: Gel.ClientConnectionError,
        name: "ClientConnectionError",
        message: ~r/are mutually exclusive/
      },
      "env_not_found" => {RuntimeError, message: ~r/environment variable ".*" doesn't exist/},
      "file_not_found" => {File.Error, message: ~r/could not read/},
      "invalid_tls_security" => {
        RuntimeError,
        message:
          ~r"(one of `insecure`, `no_host_verification`, `strict` or `default`)|(tls_security must be set to strict)"
      },
      "invalid_secret_key" =>
        {Gel.Error,
         type: Gel.ClientConnectionError,
         name: "ClientConnectionError",
         message: ~r/invalid secret key/},
      "secret_key_not_found" =>
        {Gel.Error,
         type: Gel.ClientConnectionError,
         name: "ClientConnectionError",
         message: ~r/can not determine secret key for cloud instance/}
    }
    @known_case_errors Map.keys(@case_to_client_errors)

    for {testcase, index} <- Enum.with_index(@cases, 1) do
      describe "shared testcase for connection options parsing: #{testcase["name"]} (#{index})" do
        @tag String.to_atom("shared_connection_testcase_#{testcase["name"]}")

        @tag testcase: testcase
        @tag debug: @debug_shared
        @tag String.to_atom("shared_connection_testcase_#{index}")

        with %{"fs" => fs_mapping} when map_size(fs_mapping) != 0 <- testcase do
          platform = testcase["platform"]

          cond do
            platform == "windows" or :os.type() == {:nt, :win32} ->
              @tag :skip

            platform == "macos" and :os.type() != {:unix, :darwin} ->
              @tag :skip

            is_nil(platform) and :os.type() == {:unix, :darwin} ->
              @tag :skip

            true ->
              :ok
          end
        end

        setup [
          :setup_debug,
          :setup_env,
          :setup_fs,
          :setup_opts,
          :setup_error,
          :setup_result
        ]

        test "produces expected result", %{opts: opts, execution_callback: callback} do
          callback.(fn ->
            Config.connect_opts(opts)
          end)
        end
      end
    end

    defp setup_opts(%{testcase: %{"opts" => opts}}) do
      configured_opts =
        Enum.reject(
          [
            dsn: opts["instance"] || opts["dsn"],
            credentials: opts["credentials"],
            credentials_file: opts["credentialsFile"],
            host: opts["host"],
            port: opts["port"],
            database: opts["database"],
            branch: opts["branch"],
            user: opts["user"],
            password: opts["password"],
            secret_key: opts["secretKey"],
            tls_ca: opts["tlsCA"],
            tls_ca_file: opts["tlsCAFile"],
            tls_security: opts["tlsSecurity"],
            tls_server_name: opts["tlsServerName"],
            timeout: opts["timeout"],
            server_settings: opts["serverSettings"]
          ],
          fn {_key, value} ->
            is_nil(value)
          end
        )

      Logger.debug(
        "configure explicit options: #{inspect(opts, pretty: true)}, " <>
          "configured options: #{inspect(configured_opts, pretty: true)}"
      )

      %{opts: configured_opts}
    end

    defp setup_opts(_context) do
      %{opts: []}
    end

    defp setup_error(%{testcase: %{"error" => _error, "result" => _result} = testcase}) do
      raise RuntimeError,
        message:
          ~s(invalid test case: either "result" or "error" key to be specified, ) <>
            "testcase: #{inspect(testcase, pretty: true)}"
    end

    defp setup_error(%{testcase: %{"error" => %{"type" => type}} = testcase})
         when type not in @known_case_errors do
      raise RuntimeError,
        message: "unknown error type: #{type}, testcase: #{inspect(testcase, pretty: true)}"
    end

    defp setup_error(%{testcase: %{"error" => %{"type" => error_type}}}) do
      {error, opts} = @case_to_client_errors[error_type]

      Logger.debug(
        "configure expected error (#{inspect(error_type)}): #{inspect(error)}, opts: #{inspect(opts, pretty: true)}"
      )

      expected_to_fail_callback = fn callback ->
        {message, opts} = Keyword.pop!(opts, :message)

        raised_error =
          assert_raise error, message, fn ->
            callback.()
          end

        Logger.debug("raised error: #{inspect(raised_error, pretty: true)}")

        for {attribute, value} <- opts do
          assert Map.get(raised_error, attribute) == value
        end
      end

      %{execution_callback: expected_to_fail_callback}
    end

    defp setup_error(%{testcase: %{"result" => _result}}) do
      :ok
    end

    defp setup_error(%{testcase: testcase}) do
      raise RuntimeError,
        message:
          ~s(invalid test case: either "result" or "error" key has to be specified, ) <>
            "got both, testcase: #{inspect(testcase, pretty: true)}"
    end

    defp setup_result(%{testcase: %{"result" => result} = testcase}) do
      Logger.debug("configure expected result")

      expected_result =
        Enum.reject(
          [
            address: List.to_tuple(result["address"]),
            database: result["database"],
            branch: result["branch"],
            user: result["user"],
            password: result["password"],
            secret_key: result["secretKey"],
            tls_ca: result["tlsCAData"],
            tls_server_name: result["tlsServerName"],
            tls_security: String.to_existing_atom(result["tlsSecurity"]),
            server_settings: result["serverSettings"]
          ],
          fn {_key, value} ->
            is_nil(value)
          end
        )

      Logger.debug(
        "passed result: #{inspect(result, pretty: true)}, expected_result: #{inspect(expected_result, pretty: true)}"
      )

      expected_to_success_callback = fn callback ->
        parsed_opts = callback.()

        parsed_opts = Keyword.take(parsed_opts, Keyword.keys(expected_result))

        assert Keyword.equal?(parsed_opts, expected_result),
               "wrong parsed connect opts, expected: #{inspect(expected_result, pretty: true)}, " <>
                 "got: #{inspect(parsed_opts, pretty: true)}, failed testcase: #{inspect(testcase, pretty: true)}"
      end

      %{execution_callback: expected_to_success_callback}
    end

    defp setup_result(_context) do
      :ok
    end
  end
else
  require Logger

  Logger.warning(
    "No Gel shared testcases file for connection options was found, these tests will be skipped, " <>
      "to run shared tests clone project with submodules: " <>
      ~s("git clone --recursive <repository>") <> " or initialize submodule manually"
  )
end
