defmodule Tests.Gel.Protocol.Codecs.UUIDTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding std::uuid value", %{client: client} do
    value = "380ed95c-6e36-40f9-b313-54d000fbb144"
    assert ^value = Gel.query_single!(client, "select <uuid>'#{value}'")
  end

  test "encoding std::uuid value", %{client: client} do
    value = "380ed95c-6e36-40f9-b313-54d000fbb144"
    assert ^value = Gel.query_single!(client, "select <uuid>$0", [value])
  end

  test "error when passing non UUID as std::uuid argument", %{client: client} do
    exc =
      assert_raise Gel.Error, fn ->
        Gel.query_single!(client, "select <uuid>$0", ["something"])
      end

    assert exc ==
             Gel.InvalidArgumentError.new(
               "value can not be encoded as std::uuid: Invalid argument; Not a valid UUID: #{"something"}"
             )
  end
end
