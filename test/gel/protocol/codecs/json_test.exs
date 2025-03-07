defmodule Tests.Gel.Protocol.Codecs.JSONTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding std::json value", %{client: client} do
    value = %{
      "field" => "value"
    }

    assert ^value = Gel.query_single!(client, "select <json>to_json('{\"field\": \"value\"}')")
  end

  test "encoding std::json value", %{client: client} do
    value = %{
      "field" => "value"
    }

    assert ^value = Gel.query_single!(client, "select <json>$0", [value])
  end
end
