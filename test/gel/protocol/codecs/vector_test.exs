defmodule Tests.Gel.Protocol.Codecs.VectorTest do
  use Tests.Support.GelCase

  skip_before(version: 3, scope: :module)

  setup :gel_client

  test "decoding vector value", %{client: client} do
    value = [1.5, 2.0, 4.5]

    assert ^value = Gel.query_single!(client, "select <ext::pgvector::vector>[1.5, 2.0, 4.5]")
  end

  test "encoding vector value", %{client: client} do
    value = [1.5, 2.0, 4.5]
    assert ^value = Gel.query_single!(client, "select <ext::pgvector::vector>$0", [value])
  end

  test "decoding custom scalar vector value", %{client: client} do
    value =
      [1.5]
      |> List.duplicate(1602)
      |> List.flatten()

    assert ^value = Gel.query_single!(client, "select <v3::ExVector>array_fill(1.5, 1602)")
  end

  test "encoding custom scalar vector value", %{client: client} do
    value =
      [1.5]
      |> List.duplicate(1602)
      |> List.flatten()

    assert ^value = Gel.query_single!(client, "select <v3::ExVector>$0", [value])
  end

  test "encoding empty vector value results in an error", %{client: client} do
    assert {:error, %Gel.Error{}} =
             Gel.query_single(client, "select <ext::pgvector::vector>$0", [])
  end
end
