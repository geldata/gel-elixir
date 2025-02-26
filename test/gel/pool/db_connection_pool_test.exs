defmodule Tests.Gel.Pool.DBConnectionPoolTest do
  use Tests.Support.GelCase

  @max_receive_time :timer.seconds(5)

  describe "DBConnection.ConnectionPool" do
    setup do
      {:ok, client} =
        start_supervised(
          {Gel,
           pool: DBConnection.ConnectionPool,
           idle_interval: 50,
           pool_size: 10,
           show_sensitive_data_on_connection_error: true}
        )

      %{client: client}
    end

    test "runs concurrent queries through pool", %{client: client} do
      run_concurrent_queries(client, 3)
    end
  end

  defp run_concurrent_queries(client, count, max_time \\ 200, sleep_step \\ 50) do
    test_pid = self()

    for i <- 1..count do
      spawn(fn ->
        Gel.transaction(client, fn client ->
          send(test_pid, {:started, i})
          Process.sleep(max_time - sleep_step * (i - 1))
          Gel.query_required_single!(client, "select 1")
        end)

        send(test_pid, {:done, i})
      end)
    end

    for i <- 1..count do
      assert_receive {:started, ^i}, @max_receive_time
      assert_receive {:done, ^i}, @max_receive_time
    end
  end
end
