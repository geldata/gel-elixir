defmodule Gel.Connection.Config.Credentials do
  @moduledoc false

  alias Gel.Connection.Config.{
    Platform,
    Validation
  }

  @json_library Application.compile_env(
                  :gel,
                  :json,
                  Application.compile_env(:edgedb, :json, Jason)
                )

  @path_module Application.compile_env(:gel, :__path_module__, Path)
  @file_module Application.compile_env(:gel, :__file_module__, File)

  @spec get_credentials_path(String.t()) :: String.t()
  def get_credentials_path(instance_name) do
    ["credentials", "#{instance_name}.json"]
    |> Platform.search_config_dir()
    |> @path_module.expand()
  end

  @spec read_creadentials(String.t()) :: Keyword.t()
  def read_creadentials(credentials_path) do
    credentials_data =
      try do
        @file_module.read!(credentials_path)
      rescue
        e in File.Error ->
          reraise RuntimeError,
                  [message: "invalid credentials: #{Exception.message(e)}"],
                  __STACKTRACE__
      end

    parse_credentials(credentials_data)
  end

  @spec parse_credentials(String.t()) :: Keyword.t()
  def parse_credentials(credentials) do
    credentials
    |> @json_library.decode!()
    |> Enum.reduce([], fn
      {"host", value}, opts ->
        Keyword.put(opts, :host, Validation.validate_host(value))

      {"port", value}, opts ->
        Keyword.put(opts, :port, Validation.validate_port(value, :strict))

      {"database", value}, opts ->
        Keyword.put(opts, :database, Validation.validate_database(value))

      {"branch", value}, opts ->
        Keyword.put(opts, :branch, Validation.validate_branch(value))

      {"user", value}, opts ->
        Keyword.put(opts, :user, Validation.validate_user(value))

      {"password", value}, opts ->
        Keyword.put(opts, :password, value)

      {"tls_cert_data", value}, opts ->
        case opts[:tls_ca] do
          nil ->
            Keyword.put(opts, :tls_ca, value)

          tls_ca when tls_ca != value ->
            raise RuntimeError,
              message: "tls_ca and tls_cert_data are both set and disagree"

          _tls_ca ->
            opts
        end

      {"tls_ca", value}, opts ->
        case opts[:tls_ca] do
          nil ->
            Keyword.put(opts, :tls_ca, value)

          tls_ca when tls_ca != value ->
            raise RuntimeError,
              message: "tls_ca and tls_cert_data are both set and disagree"

          _tls_ca ->
            opts
        end

      {"tls_verify_hostname", value}, opts ->
        verify = Validation.validate_tls_verify_hostname(value)

        security =
          if verify do
            :strict
          else
            :no_host_verification
          end

        opts
        |> Keyword.put(:tls_verify_hostname, verify)
        |> Keyword.put_new(:tls_security, security)

      {"tls_security", value}, opts ->
        security = Validation.validate_tls_security(value)
        Keyword.put(opts, :tls_security, security)

      _param, opts ->
        opts
    end)
    |> validate_credentials()
  rescue
    e ->
      reraise RuntimeError,
              [message: "invalid credentials: #{Exception.message(e)}"],
              __STACKTRACE__
  end

  @spec stash_dir(Path.t()) :: String.t()
  def stash_dir(path) do
    path = @path_module.expand(path)

    hash =
      :sha
      |> :crypto.hash(path)
      |> Base.encode16(case: :lower)

    base_name = @path_module.basename(path)
    dir_name = base_name <> "-" <> hash

    ["projects", dir_name]
    |> Platform.search_config_dir()
    |> @path_module.expand()
  end

  defp validate_credentials(credentials) do
    if is_nil(credentials[:user]) do
      raise RuntimeError,
        message: ~s("user" key is required)
    end

    if not is_nil(credentials[:branch]) and not is_nil(credentials[:database]) and
         credentials[:branch] != credentials[:database] do
      raise RuntimeError,
        message: ~s("database" and "branch" keys can not be different)
    end

    Validation.validate_tls_verify_hostname_with_tls_security(
      credentials[:tls_verify_hostname],
      credentials[:tls_security]
    )

    credentials
  end
end
