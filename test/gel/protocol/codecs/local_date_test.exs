defmodule Tests.Gel.Protocol.Codecs.LocalDateTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding cal::local_date value", %{client: client} do
    value = ~D[2019-05-06]

    assert ^value = Gel.query_single!(client, "select <cal::local_date>'2019-05-06'")
  end

  test "encoding cal::local_date value", %{client: client} do
    value = ~D[2019-05-06]

    assert ^value = Gel.query_single!(client, "select <cal::local_date>$0", [value])
  end
end
