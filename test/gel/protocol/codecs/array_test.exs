defmodule Tests.Gel.Protocol.Codecs.ArrayTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding array value", %{client: client} do
    value = [16, 13, 2]
    assert ^value = Gel.query_single!(client, "select [16, 13, 2]")
  end

  test "encoding array value", %{client: client} do
    value = [16, 13, 2]
    assert ^value = Gel.query_single!(client, "select <array<int64>>$0", [value])
  end
end
