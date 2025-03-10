defmodule Tests.Gel.Protocol.Codecs.DateDurationTest do
  use Tests.Support.GelCase

  alias Gel.DateDuration

  skip_before(version: 2, scope: :module)

  setup :gel_client

  test "decoding cal::date_duration value", %{client: client} do
    assert %DateDuration{months: 12, days: 2} =
             Gel.query_single!(client, "select <cal::date_duration>'1 year 2 days'")
  end

  test "encoding cal::relative_duration value", %{client: client} do
    value = %DateDuration{months: 12, days: 2}
    assert ^value = Gel.query_single!(client, "select <cal::date_duration>$0", [value])
  end
end
