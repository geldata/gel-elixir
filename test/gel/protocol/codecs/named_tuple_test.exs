defmodule Tests.Gel.Protocol.Codecs.NamedTupleTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding named tuple value", %{client: client} do
    value = new_named_tuple([{"a", 1}, {"b", "string"}, {"c", true}, {"d", 1.0}])

    assert ^value =
             Gel.query_single!(client, "select (a := 1, b := \"string\", c := true, d := 1.0)")
  end

  describe "encoding named tuple value" do
    skip_before(version: 3, scope: :describe)

    test "as named query argument", %{client: client} do
      arg = %{a: 1, b: "string", c: true, d: 1.0}
      value = new_named_tuple([{"a", 1}, {"b", "string"}, {"c", true}, {"d", 1.0}])

      assert ^value =
               Gel.query_single!(
                 client,
                 "select <tuple<a: int32, b: str, c: bool, d: float32>>$arg",
                 arg: arg
               )
    end

    test "as optional named query argument", %{client: client} do
      refute Gel.query_single!(
               client,
               "select <optional tuple<a: int32, b: str, c: bool, d: float32>>$arg",
               arg: nil
             )
    end

    test "as positional query argument", %{client: client} do
      arg = %{a: 1, b: "string", c: true, d: 1.0}
      value = new_named_tuple([{"a", 1}, {"b", "string"}, {"c", true}, {"d", 1.0}])

      assert ^value =
               Gel.query_single!(
                 client,
                 "select <tuple<a: int32, b: str, c: bool, d: float32>>$0",
                 [arg]
               )
    end

    test "as optional positional query argument", %{client: client} do
      refute Gel.query_single!(
               client,
               "select <optional tuple<a: int32, b: str, c: bool, d: float32>>$0",
               [nil]
             )
    end
  end

  defp new_named_tuple(items) do
    fields_ordering =
      items
      |> Enum.with_index()
      |> Enum.map(fn {{name, _value}, index} ->
        {index, name}
      end)
      |> Enum.into(%{})

    %Gel.NamedTuple{
      items: Enum.into(items, %{}),
      order: fields_ordering
    }
  end
end
