defmodule Tests.Gel.Protocol.Codecs.ObjectTest do
  use Tests.Support.GelCase

  setup :gel_client

  describe "encoding object as query arguments" do
    defmodule StructForArguments do
      defstruct [:arg1, :arg2]
    end

    test "forbids using Gel.Object as arguments", %{client: client} do
      anonymous_user =
        Gel.query_required_single!(client, """
        select {
          name := "username",
        }
        """)

      assert_raise Gel.Error, ~r/objects encoding is not supported/, fn ->
        Gel.query!(client, "select {<str>$name}", anonymous_user)
      end
    end

    test "forbids using custom structs as arguments", %{client: client} do
      assert_raise Gel.Error, ~r/structs encoding is not supported/, fn ->
        Gel.query!(client, "select {<str>$arg1, <str>$arg2}", %StructForArguments{
          arg1: "arg1",
          arg2: "arg2"
        })
      end
    end

    test "allows usage of plain maps as arguments", %{client: client} do
      assert set =
               Gel.query!(client, "select {<str>$arg1, <str>$arg2}", %{
                 arg1: "arg1",
                 arg2: "arg2"
               })

      assert Enum.to_list(set) == ["arg1", "arg2"]
    end

    test "allows usage of keywords as arguments", %{client: client} do
      assert set =
               Gel.query!(client, "select {<str>$arg1, <str>$arg2}",
                 arg1: "arg1",
                 arg2: "arg2"
               )

      assert Enum.to_list(set) == ["arg1", "arg2"]
    end

    test "allows usage of plain lists as positional arguments", %{client: client} do
      assert set = Gel.query!(client, "select {<str>$0, <str>$1}", ["arg1", "arg2"])
      assert Enum.to_list(set) == ["arg1", "arg2"]
    end

    test "allows nils for optional arguments", %{client: client} do
      assert is_nil(Gel.query_single!(client, "select <optional str>$arg", arg: nil))
    end
  end

  describe "error for wrong query arguments" do
    test "contains expected arguments information", %{client: client} do
      assert_raise Gel.Error, ~r/expected nothing/, fn ->
        Gel.query!(client, "select 'Hello world'", arg: "Hello world")
      end

      assert_raise Gel.Error, ~r/expected \["arg"\] keys/, fn ->
        Gel.query!(client, "select <str>$arg")
      end
    end

    test "contains passed arguments information", %{client: client} do
      assert_raise Gel.Error, ~r/passed \["arg"\] keys/, fn ->
        Gel.query!(client, "select 'Hello world'", arg: "Hello world")
      end

      assert_raise Gel.Error, ~r/passed nothing/, fn ->
        Gel.query!(client, "select <str>$arg")
      end
    end

    test "contains missed arguments information", %{client: client} do
      assert_raise Gel.Error, ~r/missed \["arg"\] keys/, fn ->
        Gel.query!(client, "select <str>$arg", another_arg: "Hello world")
      end
    end

    test "contains extra arguments information", %{client: client} do
      assert_raise Gel.Error, ~r/passed extra \["another_arg"\] keys/, fn ->
        Gel.query!(client, "select <str>$arg", another_arg: "Hello world")
      end
    end
  end

  test "decoding single object", %{client: client} do
    rollback(client, fn client ->
      Gel.query!(client, """
        insert v1::User {
          name := "username",
        }
      """)

      user = Gel.query_required_single!(client, "select v1::User { name } limit 1")
      assert user[:name] == "username"
    end)
  end

  test "decoding single anonymous object", %{client: client} do
    rollback(client, fn client ->
      anonymous_user =
        Gel.query_required_single!(client, """
        select {
          name := "username",
        }
        """)

      assert anonymous_user[:name] == "username"
    end)
  end

  test "decoding object with links", %{client: client} do
    rollback(client, fn client ->
      Gel.query!(client, """
      with
        director := (
          insert v1::Person {
            first_name := "Chris",
            middle_name := "Joseph",
            last_name := "Columbus",
          }
        )
      insert v1::Movie {
        title := "Harry Potter and the Philosopher's Stone",
        year := 2001,
        directors := director
      }
      """)

      movie =
        Gel.query_required_single!(client, """
        select v1::Movie {
          title,
          year,
          directors: {
            first_name,
            last_name,
          },
        } limit 1
        """)

      assert movie[:title] == "Harry Potter and the Philosopher's Stone"
      assert movie[:year] == 2001

      director =
        movie[:directors]
        |> Enum.take(1)
        |> List.first()

      assert director[:first_name] == "Chris"
      assert director[:last_name] == "Columbus"
    end)
  end

  test "decoding object with links that have properties", %{client: client} do
    rollback(client, fn client ->
      Gel.query!(client, """
      with
        director := (
          insert v1::Person {
            first_name := "Chris",
            middle_name := "Joseph",
            last_name := "Columbus",
          }
        ),
        actor1 := (
          first_name := "Daniel",
          middle_name := "Jacob",
          last_name := "Radcliffe",
        ),
        actor2 := (
          first_name := "Emma",
          middle_name := "Charlotte Duerre",
          last_name := "Watson",
        )
      insert v1::Movie {
        title := "Harry Potter and the Philosopher's Stone",
        year := 2001,
        description := $$
          Late one night, Albus Dumbledore and Minerva McGonagall, professors at Hogwarts School of Witchcraft and Wizardry, along with the school's groundskeeper Rubeus Hagrid, deliver a recently orphaned infant named Harry Potter to his only remaining relatives, the Dursleys....
        $$,
        directors := director,
        actors := (
          for a in {(1, actor1), (2, actor2)}
          union (
            insert v1::Person {
              first_name := a.1.first_name,
              middle_name := a.1.middle_name,
              last_name := a.1.last_name,
              @list_order := a.0
            }
          )
        )
      }
      """)

      movie =
        Gel.query_required_single!(client, """
        select v1::Movie {
          title,
          actors: {
            @list_order
          } order by @list_order,
        } limit 1
        """)

      assert movie[:title] == "Harry Potter and the Philosopher's Stone"

      for {actor, index} <- Enum.with_index(movie[:actors], 1) do
        assert actor["@list_order"] == index
      end
    end)
  end

  test "decoding object with a single property equals to empty set", %{client: client} do
    object =
      Gel.query_required_single!(client, """
      select {
        a := <str>{}
      }
      limit 1
      """)

    assert is_nil(object[:a])
  end

  test "decoding object with a multi property equals to empty set", %{client: client} do
    object =
      Gel.query_required_single!(client, """
      select {
        multi a := <str>{}
      }
      limit 1
      """)

    assert Enum.empty?(object[:a])
  end
end
