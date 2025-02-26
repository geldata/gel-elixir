defmodule Gel.Application do
  @moduledoc false

  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      Gel.Borrower,
      {Registry, keys: :unique, name: Gel.ClientsRegistry}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Gel.Supervisor)
  end
end
