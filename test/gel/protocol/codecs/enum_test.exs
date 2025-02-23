defmodule Tests.Gel.Protocol.Codecs.EnumTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding enum value", %{client: client} do
    value = "Green"
    assert ^value = Gel.query_single!(client, "select <v1::Color>'Green'")
  end

  test "encoding string to enum value", %{client: client} do
    value = "Green"
    assert ^value = Gel.query_single!(client, "select <v1::Color>$0", [value])
  end

  test "error when encoding not member element to enum value", %{client: client} do
    value = "White"

    exc =
      assert_raise Gel.Error, fn ->
        Gel.query_single!(client, "select <v1::Color>$0", [value])
      end

    assert exc ==
             Gel.InvalidArgumentError.new(
               "value can not be encoded as enum: not enum member: #{inspect(value)}"
             )
  end
end
