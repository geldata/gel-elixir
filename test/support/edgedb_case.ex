defmodule Tests.Support.GelCase do
  use ExUnit.CaseTemplate

  import Mox

  alias Tests.Support.Mocks

  @dialyzer {:nowarn_function, rollback: 2}

  using do
    quote do
      import Mox

      import unquote(__MODULE__)

      setup [
        :set_mox_from_context,
        :setup_stubs_fallbacks,
        :verify_on_exit!
      ]
    end
  end

  defmacro skip_before(opts \\ []) do
    {gel_version, ""} =
      "GEL_VERSION"
      |> System.get_env("9999")
      |> Integer.parse()

    requested_version = opts[:version]

    tag_type =
      case opts[:scope] do
        :module ->
          :moduletag

        :describe ->
          :describetag

        _other ->
          :tag
      end

    if gel_version < requested_version do
      {:@, [], [{tag_type, [], [:skip]}]}
    else
      {:__block__, [], []}
    end
  end

  @spec gel_client(term()) :: map()
  def gel_client(_context) do
    {:ok, client} =
      start_supervised(
        {Gel,
         tls_security: :insecure,
         max_concurrency: 1,
         show_sensitive_data_on_connection_error: true}
      )

    %{client: client}
  end

  @spec reconnectable_gel_client(term()) :: map()
  def reconnectable_gel_client(_context) do
    spec =
      Gel.child_spec(
        tls_security: :insecure,
        max_concurrency: 1,
        show_sensitive_data_on_connection_error: true,
        connection_listeners: [self()]
      )

    spec = %{spec | id: "reconnectable_gel_client"}

    {:ok, client} = start_supervised(spec)
    {:ok, _result} = Gel.query(client, "select 1")

    assert_receive {:connected, conn_pid}, 1000

    socket =
      case :sys.get_state(conn_pid) do
        %{mod_state: %{state: %Gel.Connection.State{socket: socket}}} ->
          socket

        {:no_state, %{state: %Gel.Connection.State{socket: socket}}} ->
          socket
      end

    %{client: client, conn_pid: conn_pid, socket: socket}
  end

  @spec rollback(Gel.client(), (Gel.client() -> any())) :: :ok
  def rollback(client, callback) do
    assert {:error, :expected} =
             Gel.transaction(client, fn client ->
               callback.(client)
               Gel.rollback(client, reason: :expected)
             end)

    :ok
  end

  @spec setup_stubs_fallbacks(term()) :: :ok
  def setup_stubs_fallbacks(_context) do
    stub_with(Mocks.FileMock, Mocks.Stubs.FileStub)
    stub_with(Mocks.SystemMock, Mocks.Stubs.SystemStub)
    stub_with(Mocks.PathMock, Mocks.Stubs.PathStub)

    :ok
  end
end
