defmodule Tests.EdgeDB.Protocol.Codecs.LocalTimeTest do
  use EdgeDB.Case

  setup :edgedb_connection

  test "decoding cal::local_time value", %{conn: conn} do
    value = ~T[12:10:00]

    assert {:ok, ^value} = EdgeDB.query_one(conn, "SELECT <cal::local_time>'12:10'")
  end

  test "encoding cal::local_time value", %{conn: conn} do
    value = ~T[12:10:00]

    assert {:ok, ^value} = EdgeDB.query_one(conn, "SELECT <cal::local_time>$0", [value])
  end
end
