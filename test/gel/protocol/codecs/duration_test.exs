defmodule Tests.Gel.Protocol.Codecs.DurationTest do
  use Tests.Support.GelCase

  @use_timex Application.compile_env(:gel, :timex_duration, true)

  setup :gel_client

  if @use_timex do
    test "decoding std::duration value", %{client: client} do
      value = Timex.Duration.from_microseconds(175_507_600_000)

      assert ^value =
               Gel.query_single!(client, "select <duration>'48 hours 45 minutes 7.6 seconds'")
    end

    test "encoding std::duration value", %{client: client} do
      value = Timex.Duration.from_microseconds(175_507_600_000)

      assert {:ok, true} =
               Gel.query_single(
                 client,
                 "select <duration>'48 hours 45 minutes 7.6 seconds' = <duration>$0",
                 [value]
               )
    end
  else
    test "decoding std::duration value", %{client: client} do
      value = 175_507_600_000

      assert ^value =
               Gel.query_single!(client, "select <duration>'48 hours 45 minutes 7.6 seconds'")
    end

    test "encoding std::duration value", %{client: client} do
      value = 175_507_600_000

      assert {:ok, true} =
               Gel.query_single(
                 client,
                 "select <duration>'48 hours 45 minutes 7.6 seconds' = <duration>$0",
                 [value]
               )
    end
  end
end
