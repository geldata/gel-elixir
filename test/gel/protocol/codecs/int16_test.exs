defmodule Tests.Gel.Protocol.Codecs.Int16Test do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding std::int16 number", %{client: client} do
    value = 1
    assert ^value = Gel.query_single!(client, "select <int16>1")
  end

  test "encoding std::int16 argument", %{client: client} do
    value = 1
    assert ^value = Gel.query_single!(client, "select <int16>$0", [1])
  end

  test "error when passing non-number as std::int16 argument", %{client: client} do
    value = 1.0

    exc =
      assert_raise Gel.Error, fn ->
        Gel.query_single!(client, "select <int16>$0", [value])
      end

    assert exc ==
             Gel.InvalidArgumentError.new(
               "value can not be encoded as std::int16: #{inspect(value)}"
             )
  end

  test "error when passing too large number as std::int16 argument", %{client: client} do
    value = 0x8000

    exc =
      assert_raise Gel.Error, fn ->
        Gel.query_single!(client, "select <int16>$0", [value])
      end

    assert exc ==
             Gel.InvalidArgumentError.new(
               "value can not be encoded as std::int16: #{inspect(value)}"
             )
  end

  test "error when passing too small number as std::int16 argument", %{client: client} do
    value = -0x8001

    exc =
      assert_raise Gel.Error, fn ->
        Gel.query_single!(client, "select <int16>$0", [value])
      end

    assert exc ==
             Gel.InvalidArgumentError.new(
               "value can not be encoded as std::int16: #{inspect(value)}"
             )
  end
end
