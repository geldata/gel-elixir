defmodule Tests.Gel.Types.NamedTupleTest do
  use Tests.Support.GelCase

  setup :gel_client

  describe "Gel.NamedTuple as Enumerable" do
    test "preserves fields order", %{client: client} do
      nt = Gel.query_required_single!(client, select_named_tuple_query())

      expected_values_order = Enum.map(1..100, & &1)
      assert Enum.into(nt, []) == expected_values_order
    end
  end

  describe "Gel.NamedTuple.keys/1" do
    test "preserves fields order", %{client: client} do
      nt = Gel.query_required_single!(client, select_named_tuple_query())

      expected_keys_order = Enum.map(1..100, &"key_#{&1}")
      assert Gel.NamedTuple.keys(nt) == expected_keys_order
    end
  end

  describe "Gel.NamedTuple.to_tuple/1" do
    test "preserves fields order", %{client: client} do
      nt = Gel.query_required_single!(client, select_named_tuple_query())

      expected_tuple =
        1..100
        |> Enum.map(& &1)
        |> List.to_tuple()

      assert Gel.NamedTuple.to_tuple(nt) == expected_tuple
    end
  end

  describe "Gel.NamedTuple.to_map/1" do
    test "returns map converted from object", %{client: client} do
      nt = Gel.query_required_single!(client, select_named_tuple_query())
      expected_map = Enum.into(1..100, %{}, &{"key_#{&1}", &1})

      assert Gel.NamedTuple.to_map(nt) == expected_map
    end
  end

  defp select_named_tuple_query do
    # create here a complex literal for named tuple to ensure that erlang optimization for maps won't be used

    nt_arg = Enum.map_join(1..100, ",", &"key_#{&1} := #{&1}")
    nt_arg = "(#{nt_arg})"

    "select #{nt_arg}"
  end
end
