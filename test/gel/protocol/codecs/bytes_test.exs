defmodule Tests.Gel.Protocol.Codecs.BytesTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding std::bytes value", %{client: client} do
    value = <<16, 13, 2, 42>>
    assert ^value = Gel.query_single!(client, "select <bytes>b\"\x10\x0d\x02\x2a\"")
  end

  test "encoding std::bytes value", %{client: client} do
    value = <<16, 13, 2, 42>>
    assert ^value = Gel.query_single!(client, "select <bytes>$0", [value])
  end

  test "error when passing non bytes as std::bytes argument", %{client: client} do
    value = 42

    exc =
      assert_raise Gel.Error, fn ->
        Gel.query_single!(client, "select <bytes>$0", [value])
      end

    assert exc ==
             Gel.InvalidArgumentError.new(
               "value can not be encoded as std::bytes: #{inspect(value)}"
             )
  end
end
