defmodule Tests.Gel.Protocol.Codecs.Custom.ShortStrTest do
  use Tests.Support.GelCase

  alias Tests.Support.Codecs

  setup do
    {:ok, client} =
      start_supervised(
        {Gel,
         tls_security: :insecure,
         max_concurrency: 1,
         codecs: [Codecs.ShortStr],
         show_sensitive_data_on_connection_error: true}
      )

    %{client: client}
  end

  test "decoding v1::short_str value", %{client: client} do
    value = "short"

    assert ^value = Gel.query_single!(client, "select <v1::short_str>\"short\"")
  end

  test "encoding v1::short_str value", %{client: client} do
    value = "short"
    assert ^value = Gel.query_single!(client, "select <v1::short_str>$0", [value])
  end

  test "error when passing value that can't be encoded by custom codec as v1::short_str argument",
       %{client: client} do
    value = "too long string"

    exc =
      assert_raise Gel.Error, fn ->
        Gel.query_single!(client, "select <v1::short_str>$0", [value])
      end

    assert exc == Gel.InvalidArgumentError.new("string is too long")
  end
end
