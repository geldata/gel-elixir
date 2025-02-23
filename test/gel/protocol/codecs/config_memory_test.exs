defmodule Tests.Gel.Protocol.Codecs.ConfigMemoryTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding cfg::memory value", %{client: client} do
    value = 42 * 1024 * 1024

    assert %Gel.ConfigMemory{bytes: ^value} =
             Gel.query_single!(client, "select <cfg::memory>'42MiB'")
  end

  test "encoding integer as cfg::memory value", %{client: client} do
    value = 42

    assert %Gel.ConfigMemory{bytes: ^value} =
             Gel.query_single!(client, "select <cfg::memory>$0", [value])
  end

  test "encoding Gel.ConfigMemory as cfg::memory value", %{client: client} do
    value = %Gel.ConfigMemory{bytes: 42 * 1024}

    assert true ==
             Gel.query_single!(client, "select <cfg::memory>$0 = <cfg::memory>'42KiB'", [value])
  end

  test "error when passing too large number as cfg::memory argument", %{client: client} do
    value = 0x8000000000000000

    exc =
      assert_raise Gel.Error, fn ->
        Gel.query_single!(client, "select <cfg::memory>$0", [value])
      end

    assert exc ==
             Gel.InvalidArgumentError.new(
               "value can not be encoded as cfg::memory: #{inspect(value)}"
             )
  end

  test "error when passing invalid entity as cfg::memory argument", %{client: client} do
    value = "42KiB"

    exc =
      assert_raise Gel.Error, fn ->
        Gel.query_single!(client, "select <cfg::memory>$0", [value])
      end

    assert exc ==
             Gel.InvalidArgumentError.new(
               "value can not be encoded as cfg::memory: #{inspect(value)}"
             )
  end
end
