defmodule Tests.DocsTest do
  use Tests.Support.GelCase

  setup :gel_client

  setup %{client: client} do
    client
    |> drop_tickets()
    |> drop_persons()
    |> add_person()

    :ok
  end

  doctest Gel
  doctest Gel.ConfigMemory
  doctest Gel.NamedTuple
  doctest Gel.Object
  doctest Gel.RelativeDuration
  doctest Gel.Set

  skip_before(version: 2)
  doctest Gel.DateDuration

  skip_before(version: 2)
  doctest Gel.Range

  defp drop_tickets(client) do
    Gel.query!(client, "delete v1::Ticket")

    client
  end

  defp drop_persons(client) do
    Gel.query!(client, "delete v1::Person")

    client
  end

  defp add_person(client) do
    Gel.query!(client, """
    insert v1::Person {
      first_name := 'Daniel',
      middle_name := 'Jacob',
      last_name := 'Radcliffe',
    };
    """)

    client
  end
end
