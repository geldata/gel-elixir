defmodule Tests.Connection.ConfigTest do
  use Tests.Support.GelCase, async: false

  alias Gel.Connection.Config

  describe "Gel.Connection.Config.connect_opts/1" do
    test "returns additional options along with connection options" do
      options =
        Config.connect_opts(
          dsn: "gel://admin:password@localhost:5656/main",
          show_sensitive_data_on_connection_error: true
        )

      assert Keyword.has_key?(options, :show_sensitive_data_on_connection_error)
    end
  end
end
