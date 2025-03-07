defmodule Tests.Gel.Protocol.Codecs.SetTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "decoding set value", %{client: client} do
    value = new_set([1, 2, 3])
    assert {:ok, ^value} = Gel.query(client, "select {1, 2, 3}")
  end

  defp new_set(elements) do
    %Gel.Set{items: elements}
  end
end
