defmodule Tests.Gel.Protocol.Codecs.BoolTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding std::bool value", %{client: client} do
    value = true

    assert {:ok, ^value} = Gel.query_single(client, "select <bool>true")
  end

  test "encoding std::bool value", %{client: client} do
    value = false
    assert {:ok, ^value} = Gel.query_single(client, "select <bool>$0", [value])
  end

  test "error when passing non bool as std::bool argument", %{client: client} do
    value = 42

    exc =
      assert_raise Gel.Error, fn ->
        Gel.query_single!(client, "select <bool>$0", [value])
      end

    assert exc ==
             Gel.InvalidArgumentError.new(
               "value can not be encoded as std::bool: #{inspect(value)}"
             )
  end
end
