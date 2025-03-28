defmodule Tests.Gel.Protocol.Codecs.LocalTimeTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding cal::local_time value", %{client: client} do
    value = ~T[12:10:00]

    assert ^value = Gel.query_single!(client, "select <cal::local_time>'12:10'")
  end

  test "encoding cal::local_time value", %{client: client} do
    value = ~T[12:10:00]

    assert ^value = Gel.query_single!(client, "select <cal::local_time>$0", [value])
  end
end
