defmodule Tests.Gel.Pools.SandboxTest do
  use Tests.Support.GelCase

  @involved_types ~w(
    v1::Ticket
  )

  setup :gel_client

  setup %{client: client} do
    for type <- @involved_types do
      query = "delete #{type}"
      Gel.query!(client, query)
    end

    spec =
      Gel.child_spec(
        connection: Gel.Sandbox,
        tls_security: :insecure,
        show_sensitive_data_on_connection_error: true
      )

    spec = %{spec | id: "sandbox_gel_client"}
    {:ok, sandbox_client} = start_supervised(spec)
    Gel.Sandbox.initialize(sandbox_client)

    on_exit(fn ->
      Tests.Support.GelCase.setup_stubs_fallbacks(nil)

      {:ok, client} = Gel.start_link(max_concurrency: 1, tls_security: :insecure)
      Process.unlink(client)

      for type <- @involved_types do
        query = "select count(#{type})"
        assert Gel.query_required_single!(client, query) == 0
      end

      Process.exit(client, :kill)
    end)

    %{client: sandbox_client}
  end

  describe "Gel.Sandbox" do
    test "doesn't apply transactions from wrapped connections", %{client: client} do
      Gel.query!(client, "insert v1::Internal { value := 1 }")

      assert Gel.query_required_single!(
               client,
               "select v1::Internal { value } limit 1"
             )[:value] == 1
    end

    test "works with Gel.transaction/3", %{client: client} do
      {:ok, _result} =
        Gel.transaction(client, fn client ->
          Gel.query!(client, "insert v1::Internal { value := 1 }")
        end)

      assert Gel.query_required_single!(
               client,
               "select v1::Internal { value } limit 1"
             )[:value] == 1
    end
  end

  describe "Gel.Sandbox.clean/1" do
    test "explicitly rollbacks transaction", %{client: client} do
      {:ok, _result} =
        Gel.transaction(client, fn client ->
          Gel.query!(client, "insert v1::Internal { value := 1 }")
        end)

      assert Gel.query_required_single!(
               client,
               "select v1::Internal { value } limit 1"
             )[:value] == 1

      Gel.Sandbox.clean(client)

      refute Gel.query_single!(client, "select v1::Internal { value } limit 1")
    end
  end
end
