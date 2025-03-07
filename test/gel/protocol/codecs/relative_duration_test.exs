defmodule Tests.Gel.Protocol.Codecs.RelativeDurationTest do
  use Tests.Support.GelCase

  alias Gel.RelativeDuration

  setup :gel_client

  test "decoding cal::relative_duration value", %{client: client} do
    assert %RelativeDuration{months: 12} =
             Gel.query_single!(client, "select <cal::relative_duration>'1 year'")
  end

  test "encoding cal::relative_duration value", %{client: client} do
    value = %RelativeDuration{
      days: 25,
      months: 84,
      microseconds: 42
    }

    assert ^value = Gel.query_single!(client, "select <cal::relative_duration>$0", [value])
  end
end
