defmodule Tests.Gel.APITest do
  use Tests.Support.GelCase

  setup :gel_client

  describe "Gel.query/4" do
    test "returns Gel.Set on succesful query", %{client: client} do
      assert {:ok, %Gel.Set{}} = Gel.query(client, "select 1")
    end

    test "returns error on failed query", %{client: client} do
      assert {:error, %Gel.Error{}} =
               Gel.query(client, "select {1, 2, 3}", [], cardinality: :one)
    end
  end

  describe "Gel.query/4 for readonly queries" do
    setup :reconnectable_gel_client

    test "retries failed query", %{client: client, socket: socket} do
      Gel.query!(client, "select v1::Internal")

      :ssl.close(socket)

      test_pid = self()

      assert %Gel.Set{} =
               Gel.query!(client, "select v1::Internal", [],
                 retry: [
                   network_error: [
                     attempts: 1,
                     backoff: fn attempt ->
                       send(test_pid, {:attempt, attempt})
                       0
                     end
                   ]
                 ]
               )

      assert_receive {:attempt, 1}
    end
  end

  describe "Gel.query_json/4" do
    test "returns decoded JSON on succesful query", %{client: client} do
      assert {:ok, "[{\"number\" : 1}]"} = Gel.query_json(client, "select { number := 1 }")
    end
  end

  describe "Gel.query!/4" do
    test "returns Gel.Set on succesful query", %{client: client} do
      assert %Gel.Set{} = Gel.query!(client, "select 1")
    end

    test "raises error on failed query", %{client: client} do
      assert_raise Gel.Error, fn ->
        Gel.query!(client, "select {1, 2, 3}", [], cardinality: :one)
      end
    end
  end

  describe "Gel.query_json!/4" do
    test "returns decoded JSON on succesful query", %{client: client} do
      assert "[{\"number\" : 1}]" = Gel.query_json!(client, "select { number := 1 }")
    end
  end

  describe "Gel.query_single/4" do
    test "returns result on succesful query", %{client: client} do
      assert {:ok, 1} = Gel.query_single(client, "select 1")
    end

    test "raises error on failed query", %{client: client} do
      {:error, %Gel.Error{}} =
        Gel.query_single(client, "select {1, 2, 3}", [], cardinality: :one)
    end
  end

  describe "Gel.query_single!/4" do
    test "returns result on succesful query", %{client: client} do
      assert 1 = Gel.query_single!(client, "select 1")
    end

    test "raises error on failed query", %{client: client} do
      assert_raise Gel.Error, fn ->
        Gel.transaction(client, fn client ->
          Gel.query_single!(client, "select {1, 2, 3}", [], cardinality: :one)
        end)
      end
    end
  end

  describe "Gel.query_required_single/4" do
    test "returns result on succesful query", %{client: client} do
      assert {:ok, 1} = Gel.query_required_single(client, "select 1")
    end

    test "raises error on failed query", %{client: client} do
      {:error, %Gel.Error{}} = Gel.query_required_single(client, "select <int64>{}", [])
    end
  end

  describe "Gel.query_required_single!/4" do
    test "returns result on succesful query", %{client: client} do
      assert 1 = Gel.query_required_single!(client, "select 1")
    end

    test "raises error on failed query", %{client: client} do
      assert_raise Gel.Error, fn ->
        Gel.query_required_single!(client, "select <int64>{}")
      end
    end
  end

  describe "Gel.query_single_json/4" do
    test "returns decoded JSON on succesful query", %{client: client} do
      assert {:ok, "{\"number\" : 1}"} =
               Gel.query_single_json(client, "select { number := 1 }")
    end

    test "returns JSON null for empty set", %{client: client} do
      assert {:ok, "null"} = Gel.query_single_json(client, "select <int64>{}")
    end
  end

  describe "Gel.query_single_json!/4" do
    test "returns decoded JSON on succesful query", %{client: client} do
      assert "{\"number\" : 1}" = Gel.query_single_json!(client, "select { number := 1 }")
    end
  end

  describe "Gel.query_required_single_json/4" do
    test "returns decoded JSON on succesful query", %{client: client} do
      assert {:ok, "1"} = Gel.query_required_single_json(client, "select 1")
    end
  end

  describe "Gel.query_required_single_json!/4" do
    test "returns decoded JSON on succesful query", %{client: client} do
      assert "1" = Gel.query_required_single_json!(client, "select 1")
    end
  end

  describe "Gel.execute/4" do
    test "executes query", %{client: client} do
      {:error, :rollback} =
        Gel.transaction(client, fn conn ->
          :ok =
            Gel.execute(conn, """
              insert v1::User { name := 'username1' };
              insert v1::User { name := 'username2' };
            """)

          Gel.rollback(conn, reason: :rollback)
        end)
    end
  end

  describe "Gel.execute!/4" do
    test "executes query", %{client: client} do
      {:error, :rollback} =
        Gel.transaction(client, fn conn ->
          Gel.execute!(conn, """
            insert v1::User { name := 'username1' };
            insert v1::User { name := 'username2' };
          """)

          Gel.rollback(conn, reason: :rollback)
        end)
    end
  end

  describe "Gel.transaction/3" do
    test "commits result if no error occured", %{client: client} do
      assert {:ok, %Gel.Object{id: user_id}} =
               Gel.transaction(client, fn conn ->
                 Gel.query_single!(conn, """
                   insert v1::User { name := 'username' }
                 """)
               end)

      %Gel.Object{id: ^user_id} =
        Gel.query_required_single!(client, "select v1::User filter .id = <uuid>$0", [user_id])

      Gel.execute!(client, "delete v1::User")
    end

    test "automaticly rollbacks if error occured", %{client: client} do
      assert_raise RuntimeError, fn ->
        Gel.transaction(client, fn conn ->
          Gel.query!(conn, "insert v1::User { name := 'username' }")
          raise RuntimeError
        end)
      end

      assert Gel.Set.empty?(Gel.query!(client, "select v1::User"))
    end

    test "automaticly rollbacks if error in Gel occured", %{client: client} do
      assert_raise Gel.Error, ~r/violates exclusivity constraint/, fn ->
        Gel.transaction(client, fn conn ->
          Gel.query!(conn, "insert v1::Internal { value := 1 }")
          Gel.query!(conn, "insert v1::Internal { value := 1 }")
        end)
      end

      assert Gel.Set.empty?(Gel.query!(client, "select v1::Internal"))
    end

    test "raises borrow error in case of nested transactions", %{client: client} do
      assert_raise Gel.Error, ~r/borrowed for transaction/, fn ->
        Gel.transaction(client, fn tx_conn1 ->
          Gel.transaction(tx_conn1, fn tx_conn2 ->
            Gel.query!(tx_conn2, "select 1")
          end)
        end)
      end
    end

    test "won't retry on non Gel errors", %{client: client} do
      rule = [
        attempts: 1,
        backoff: fn _attempt ->
          raise RuntimeError, "shouldn't get here"
        end
      ]

      assert_raise RuntimeError, ~r/expected/, fn ->
        Gel.transaction(client, fn _tx_conn -> raise RuntimeError, message: "expected" end,
          retry: [network_error: rule, transaction_conflict: rule]
        )
      end
    end
  end

  describe "Gel.rollback/2" do
    test "rollbacks transaction", %{client: client} do
      {:error, :rollback} =
        Gel.transaction(client, fn client ->
          Gel.query!(client, "insert v1::User { name := 'username' }")
          Gel.rollback(client, reason: :rollback)
        end)
    end
  end

  describe "Gel.as_readonly/2" do
    setup %{client: client} do
      %{client: Gel.as_readonly(client)}
    end

    test "configures connection that will fail for non-readonly requests", %{client: client} do
      exc =
        assert_raise Gel.Error, fn ->
          Gel.query!(client, "insert v1::Internal")
        end

      assert exc.type == Gel.DisabledCapabilityError
    end

    test "configures connection that will fail for non-readonly requests in transaction", %{
      client: client
    } do
      exc =
        assert_raise Gel.Error, fn ->
          Gel.transaction(client, fn client ->
            Gel.query!(client, "insert v1::Internal")
          end)
        end

      assert exc.type == Gel.DisabledCapabilityError
    end

    test "configures connection that executes readonly requests", %{client: client} do
      assert 1 == Gel.query_single!(client, "select 1")
    end

    test "configures connection that executes readonly requests in transaction", %{
      client: client
    } do
      assert {:ok, 1} ==
               Gel.transaction(client, fn client ->
                 Gel.query_single!(client, "select 1")
               end)
    end
  end

  describe "Gel.with_transaction_options/2" do
    test "accepts options for changing transaction", %{client: client} do
      exc =
        assert_raise Gel.Error, ~r/read-only transaction/, fn ->
          client
          |> Gel.with_transaction_options(readonly: true)
          |> Gel.transaction(fn client ->
            Gel.query!(client, "insert v1::Internal { value := 1 }")
          end)
        end

      assert exc.type == Gel.TransactionError
    end
  end

  describe "Gel.with_retry_options/2" do
    test "accepts options for changing retries in transactions for transactions conflicts", %{
      client: client
    } do
      pid = self()

      exc =
        assert_raise Gel.Error, ~r/test error/, fn ->
          client
          |> Gel.with_retry_options(
            transaction_conflict: [
              attempts: 10,
              backoff: fn attempt ->
                send(pid, {:attempt, attempt})
                10
              end
            ]
          )
          |> Gel.transaction(fn client ->
            Gel.query!(client, "insert v1::Internal{ value := 1 }")
            raise Gel.TransactionConflictError.new("test error")
          end)
        end

      assert Gel.Set.empty?(Gel.query!(client, "select v1::Internal"))

      assert exc.type == Gel.TransactionConflictError

      for attempt <- 1..5 do
        assert_receive {:attempt, ^attempt}
      end
    end

    test "accepts options for changing retries in transactions for network errors", %{
      client: client
    } do
      test_pid = self()

      exc =
        assert_raise Gel.Error, ~r/test error/, fn ->
          client
          |> Gel.with_retry_options(
            network_error: [
              backoff: fn attempt ->
                send(test_pid, {:attempt, attempt})
                10
              end
            ]
          )
          |> Gel.transaction(fn client ->
            Gel.query!(client, "insert v1::Internal{ value := 1 }")
            raise Gel.ClientConnectionFailedTemporarilyError.new("test error")
          end)
        end

      assert Gel.Set.empty?(Gel.query!(client, "select v1::Internal"))

      assert exc.type == Gel.ClientConnectionFailedTemporarilyError

      for attempt <- 1..3 do
        assert_receive {:attempt, ^attempt}
      end
    end
  end

  describe "Gel.with_default_module/2" do
    skip_before(version: 2, scope: :describe)

    setup %{client: client} do
      %{client: Gel.with_default_module(client, "schema")}
    end

    test "passes module to Gel", %{client: client} do
      assert %Gel.Object{} =
               Gel.query_required_single!(client, """
                  select ObjectType
                  filter .name = 'std::BaseObject'
                  limit 1
               """)
    end

    test "without argument removes module from passing to Gel", %{client: client} do
      assert_raise Gel.Error, ~r/'default::ObjectType' does not exist/, fn ->
        client
        |> Gel.with_default_module()
        |> Gel.query_required_single!("""
          select ObjectType
          filter .name = 'std::BaseObject'
          limit 1
        """)
      end
    end
  end

  describe "Gel.with_module_aliases/2" do
    skip_before(version: 2, scope: :describe)

    setup %{client: client} do
      %{
        client:
          Gel.with_module_aliases(client, %{"schema_alias" => "schema", "cfg_alias" => "cfg"})
      }
    end

    test "passes aliases to Gel", %{client: client} do
      assert %Gel.Object{} =
               Gel.query_required_single!(client, """
                  select schema_alias::ObjectType
                  filter .name = 'std::BaseObject'
                  limit 1
               """)

      assert %Gel.ConfigMemory{} =
               Gel.query_required_single!(client, "select <cfg_alias::memory>'1B'")
    end
  end

  describe "Gel.without_module_aliases/2" do
    skip_before(version: 2, scope: :describe)

    setup %{client: client} do
      %{client: Gel.with_module_aliases(client, %{"cfg_alias" => "cfg"})}
    end

    test "removes aliases from passed to Gel", %{client: client} do
      assert_raise Gel.Error, ~r/type 'cfg_alias::memory' does not exist/, fn ->
        client
        |> Gel.without_module_aliases(["cfg_alias"])
        |> Gel.query_required_single!("select <cfg_alias::memory>'1B'")
      end
    end
  end

  describe "Gel.with_config/2" do
    skip_before(version: 2, scope: :describe)

    setup %{client: client} do
      # 48:45:07:6
      duration = Timex.Duration.from_microseconds(175_507_600_000)

      %{
        client: Gel.with_config(client, query_execution_timeout: duration),
        duration: duration
      }
    end

    test "passes config to Gel", %{client: client, duration: duration} do
      config_object =
        Gel.query_required_single!(client, """
          select cfg::Config {
            query_execution_timeout
          }
          limit 1
        """)

      assert config_object[:query_execution_timeout] == duration
    end
  end

  describe "Gel.without_config/2" do
    skip_before(version: 2, scope: :describe)

    setup %{client: client} do
      # 48:45:07:6
      duration = Timex.Duration.from_microseconds(175_507_600_000)

      %{client: Gel.with_config(client, query_execution_timeout: duration)}
    end

    test "removes config keys from passed to Gel", %{client: client} do
      config_object =
        client
        |> Gel.without_config([:query_execution_timeout])
        |> Gel.query_required_single!("select cfg::Config { query_execution_timeout } limit 1")

      assert config_object[:query_execution_timeout] == Timex.Duration.from_microseconds(0)
    end
  end

  describe "Gel.with_globals/2" do
    skip_before(version: 2, scope: :describe)

    setup %{client: client} do
      current_user = "some_username"

      %{
        client: Gel.with_globals(client, %{"v2::current_user" => current_user}),
        current_user: current_user
      }
    end

    test "passes globals to Gel", %{client: client, current_user: current_user} do
      assert current_user ==
               Gel.query_required_single!(client, "select global v2::current_user")
    end
  end

  describe "Gel.without_globals/2" do
    skip_before(version: 2, scope: :describe)

    setup %{client: client} do
      current_user = "some_username"
      %{client: Gel.with_globals(client, %{"v2::current_user" => current_user})}
    end

    test "removes globals from passed to Gel", %{client: client} do
      client = Gel.without_globals(client, ["v2::current_user"])
      refute Gel.query_single!(client, "select global v2::current_user")
    end
  end

  describe "Gel.with_state/2" do
    skip_before(version: 2, scope: :describe)

    setup %{client: client} do
      current_user = "current_user"

      # 48:45:07:6
      duration = Timex.Duration.from_microseconds(175_507_600_000)

      state =
        %Gel.Client.State{}
        |> Gel.Client.State.with_default_module("schema")
        |> Gel.Client.State.with_module_aliases(%{
          "math_alias" => "math",
          "cfg_alias" => "cfg"
        })
        |> Gel.Client.State.with_globals(%{"v2::current_user" => current_user})
        |> Gel.Client.State.with_config(query_execution_timeout: duration)

      %{
        client: Gel.with_client_state(client, state),
        current_user: current_user,
        duration: duration
      }
    end

    test "passes state to Gel", %{
      client: client,
      current_user: current_user,
      duration: duration
    } do
      object =
        Gel.query_required_single!(client, """
          with
            config := (select cfg_alias::Config limit 1),
            abs_value := math_alias::abs(-1),
            user_object_type := (select ObjectType filter .name = 'v1::User' limit 1)
          select {
            current_user := global v2::current_user,
            config_query_execution_timeout := config.query_execution_timeout,
            math_abs_value := abs_value,
            user_type := user_object_type { name }
          }
        """)

      assert object[:current_user] == current_user
      assert object[:config_query_execution_timeout] == duration
      assert object[:math_abs_value] == 1
      assert object[:user_type][:name] == "v1::User"
    end
  end

  test "Gel API raises an error for wrong module name as a client" do
    e =
      assert_raise Gel.Error, fn ->
        Gel.query!(GelWrongName, "select 'Hello world'")
      end

    assert %Gel.Error{type: Gel.InterfaceError} = e
  end
end
