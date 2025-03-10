defmodule Tests.Gel.Protocol.Codecs.DateTimeTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding std::datetime value", %{client: client} do
    value = ~U[2019-05-06 12:00:00Z]

    assert ^value = Gel.query_single!(client, "select <datetime>'2019-05-06T12:00+00:00'")
  end

  test "encoding std::datetime value", %{client: client} do
    value = ~U[2019-05-06 12:00:00Z]

    assert ^value = Gel.query_single!(client, "select <datetime>$0", [value])
  end
end
