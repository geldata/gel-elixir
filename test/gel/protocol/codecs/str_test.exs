defmodule Tests.Gel.Protocol.Codecs.StrTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding std::str value", %{client: client} do
    value = "Harry Potter and the Sorcerer's Stone"

    assert ^value =
             Gel.query_single!(client, "select <str>\"Harry Potter and the Sorcerer's Stone\"")
  end

  test "encoding std::str value", %{client: client} do
    value = "Harry Potter and the Sorcerer's Stone"
    assert ^value = Gel.query_single!(client, "select <str>$0", [value])
  end

  test "error when passing non str as std::str argument", %{client: client} do
    value = 42

    exc =
      assert_raise Gel.Error, fn ->
        Gel.query_single!(client, "select <str>$0", [value])
      end

    assert exc ==
             Gel.InvalidArgumentError.new(
               "value can not be encoded as std::str: #{inspect(value)}"
             )
  end
end
