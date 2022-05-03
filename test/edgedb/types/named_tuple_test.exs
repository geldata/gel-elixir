defmodule Tests.EdgeDB.Types.NamedTupleTest do
  use Tests.Support.EdgeDBCase

  setup :edgedb_connection

  describe "EdgeDB.NamedTuple as Enumerable" do
    test "preserves fields order", %{conn: conn} do
      nt = EdgeDB.query_required_single!(conn, select_named_tuple_query())

      expected_values_order = Enum.map(1..100, & &1)
      assert Enum.into(nt, []) == expected_values_order
    end
  end

  describe "EdgeDB.NamedTuple.keys/1" do
    test "preserves fields order", %{conn: conn} do
      nt = EdgeDB.query_required_single!(conn, select_named_tuple_query())

      expected_keys_order = Enum.map(1..100, &"key_#{&1}")
      assert EdgeDB.NamedTuple.keys(nt) == expected_keys_order
    end
  end

  describe "EdgeDB.NamedTuple.to_tuple/1" do
    test "preserves fields order", %{conn: conn} do
      nt = EdgeDB.query_required_single!(conn, select_named_tuple_query())

      expected_tuple =
        1..100
        |> Enum.map(& &1)
        |> List.to_tuple()

      assert EdgeDB.NamedTuple.to_tuple(nt) == expected_tuple
    end
  end

  defp select_named_tuple_query do
    # create here a complex literal for named tuple to ensure that erlang optimization for maps won't be used

    nt_arg = Enum.map_join(1..100, ",", &"key_#{&1} := #{&1}")
    nt_arg = "(#{nt_arg})"

    "SELECT #{nt_arg}"
  end
end
