defmodule Tests.Gel.Connection.QueriesTest do
  use Tests.Support.GelCase

  setup :gel_client

  test "connection uses already prepared query from queries cache", %{client: client} do
    Gel.query(client, "select 1")
    {:ok, {%Gel.Query{cached: true}, _r}} = Gel.query(client, "select 1", [], raw: true)
  end

  test "connection handles optimisic execute flow for prepared query with empty results", %{
    client: client
  } do
    Gel.query(client, "select <str>{}")

    {:ok, {%Gel.Query{cached: true}, _r}} =
      Gel.query(client, "select <str>{}", [], raw: true)
  end

  test "result requirement is saved in queries cache", %{client: client} do
    assert is_nil(Gel.query_single!(client, "select v1::User limit 1"))

    assert_raise Gel.Error, ~r/expected result/, fn ->
      Gel.query_required_single!(client, "select v1::User limit 1")
    end

    assert is_nil(Gel.query_single!(client, "select v1::User limit 1"))
  end
end
