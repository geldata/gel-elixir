# Usage

The basic user API for `gel-elixir` is provided by the `Gel` module and in most cases you will use only it.
  The exception is when you want to define custom codecs. Checkout the guide on
  [hex.pm](https://hexdocs.pm/gel/custom-codecs.html) for more information.

`Gel` provides several functions for querying data from the database, which are named in `Gel.query*/4` format.
  Transactions are supported with `Gel.transaction/3` function.

## Establishing a connection

`gel-elixir`, like other Gel clients, allows a very flexible way to define how to connect to an instance.
  For more information, see `t:Gel.connect_option/0`.

The examples on this page will involve connecting to an instance using
  [gel projects](https://docs.geldata.com/get-started/projects#projects).
  Run `gel project init` to initialize the project:

```bash
$ gel project init
```

### Database schema

Ensure that your database has the following schema:

```sdl
module default {
    type User {
        required name: str {
            constraint exclusive;
        };
    }

    type Post {
        required body: str;

        required author: User;
        multi comments: Post;
    }
};
```

Let's fill the database with some data, which will be used in further examples:

```iex
iex(1)> {:ok, client} = Gel.start_link()
iex(2)> Gel.query!(client, """
...(2)> WITH
...(2)>     p1 := (
...(2)>         insert Post {
...(2)>             body := 'Yes!',
...(2)>             author := (
...(2)>                 insert User {
...(2)>                     name := 'commentator1'
...(2)>                 }
...(2)>             )
...(2)>         }
...(2)>     ),
...(2)>     p2 := (
...(2)>         insert Post {
...(2)>             body := 'Absolutely amazing',
...(2)>             author := (
...(2)>                 insert User {
...(2)>                     name := 'commentator2'
...(2)>                 }
...(2)>             )
...(2)>         }
...(2)>     ),
...(2)>     p3 := (
...(2)>         insert Post {
...(2)>             body := 'FYI here is a link to the Elixir client: https://hex.pm/packages/gel',
...(2)>             author := (
...(2)>                 insert User {
...(2)>                     name := 'commentator3'
...(2)>                 }
...(2)>             )
...(2)>         }
...(2)>     )
...(2)> insert Post {
...(2)>     body := 'Gel is awesome! Try the Elixir client for it',
...(2)>     author := (
...(2)>         insert User {
...(2)>             name := 'author1'
...(2)>         }
...(2)>     ),
...(2)>     comments := {p1, p2, p3}
...(2)> }
...(2)> """)
```

## Querying data from Gel

Depending on the expected results of the query, you can use different functions to retrieve data from the database.
  This is called the cardinality of the result and is better explained in
  [the relevant documentation](https://docs.geldata.com/database/reference/edgeql/cardinality).

### Querying a set of elements

If you want to receive an `Gel.Set` from your query, just use the `Gel.query/4` or `Gel.query!/4` functions.
  The difference between the two functions is that `Gel.query/4` will return an `:ok` tuple with result
  if successful or a `:error`  tuple with `Gel.Error` if an error occurred during the query execution.
  `Gel.query!/4` will return a plain result if successful or raise `Gel.Error` if error.

Let's query all existing posts with their bodies:

```iex
iex(1)> {:ok, client} = Gel.start_link()
iex(2)> {:ok, posts} = Gel.query(client, "select Post { body }")
{:ok,
 #Gel.Set<{#Gel.Object<body := "Gel is awesome! Try the Elixir client for it">,
  #Gel.Object<body := "Yes!">, #Gel.Object<body := "Absolutely amazing">,
  #Gel.Object<body := "FYI here is a link to the Elixir client: https://hex.pm/packages/gel">}>}
```

We can iterate over `Gel.Set` and inspect each object separately:

```iex
iex(3)> Enum.each(posts, fn post ->
...(3)>   IO.inspect(post[:body], label: "post (#{inspect(post.id)})")
...(3)> end)
post ("3c5c8cf2-860f-11ec-a22a-2b0ab4e21d4b"): "Gel is awesome! Try the Elixir client for it"
post ("3c5c904e-860f-11ec-a22a-f7cdb9bcb510"): "Yes!"
post ("3c5c9256-860f-11ec-a22a-0343fa0961f3"): "Absolutely amazing"
post ("3c5c9378-860f-11ec-a22a-0713dfca8baa"): "FYI here is a link to the Elixir client: https://hex.pm/packages/gel"
:ok
```

### Querying a single element

If you know that the query will return only one element or none, you can use `Gel.query_single/4` and
  `Gel.query_single!/4` functions. This function will automatically unpack the underlying `Gel.Set`
  and return the requested item (or `nil` if the set is empty).

Let's query a post with a link to the Elixir client for Gel:

```iex
iex(1)> {:ok, client} = Gel.start_link()
iex(2)> post = Gel.query_single!(client, "select Post filter contains(.body, 'https://hex.pm/packages/gel') limit 1")
iex(3)> post[:id]
"3c5c9378-860f-11ec-a22a-0713dfca8baa"
```

If we try to select a `Post` that does not exist, `nil` will be returned:

```iex
iex(4)> Gel.query_single!(client, "select Post filter .body = 'lol' limit 1")
nil
```

### Querying a required single element

In case we want to ensure that the requested element must exist, we can use the functions `Gel.query_required_single/4` and
  `Gel.query_required_single!/4`. Instead of returning `nil` they will return `Gel.Error` in case of a missing element:

```iex
iex(5)> Gel.query_required_single!(client, "select Post filter .body = 'lol' limit 1")
** (Gel.Error) NoDataError: expected result, but query did not return any data
```

## Transactions

> #### NOTE {: .warning}
>
> Note that `Gel.transaction/3` calls can not be nested.

The API for transactions is provided by the `Gel.transaction/3` function:

```iex
iex(1)> {:ok, client} = Gel.start_link()
iex(2)> {:ok, user} =
...(2)>  Gel.transaction(client, fn conn ->
...(2)>    Gel.query_required_single!(conn, "insert User { name := <str>$username }", username: "user1")
...(2)>  end)
```

Transactions can be rollbacked using the `Gel.rollback/2` function or automatically
  if an error has occurred inside a transaction block:

```iex
iex(3)> {:error, :rollback} =
...(3)>  Gel.transaction(client, fn conn ->
...(3)>    Gel.query_required_single!(conn, "insert User { name := <str>$username }", username: "wrong_username")
...(3)>    Gel.rollback(conn)
...(3)>  end)
iex(4)> Gel.query_single!(client, "select User { name } filter .name = <str>$username", username: "wrong_username")
nil
```

Transactions are retriable. This means that if certain types of errors occur when querying data from the database,
  the transaction block can be automatically retried.

The following types of errors can be retried retried:

  * `TransactionConflictError` and its inheritors.
  * Network errors (e.g. a socket was closed).

As an example, let's create a transaction conflict to show how this works. In the first example, we will disable retries:

```iex
iex(5)> callback = fn conn, body ->
...(5)>  Process.sleep(500)
...(5)>  Gel.query!(conn, "update Post filter .author.id = <uuid>$user_id set { body := <str>$new_body }", user_id: user.id, new_body: body)
...(5)>  Process.sleep(500)
...(5)> end
iex(6)> spawn(fn ->
...(6)>  {:ok, client} = Gel.start_link()
...(6)>  Gel.transaction(client, &callback.(&1, "new_body_1"))
...(6)> end)
iex(7)> Gel.transaction(client, &callback.(&1, "new_body_2"), retry: [transaction_conflict: [attempts: 0]])
** (Gel.Error) TransactionSerializationError: could not serialize access due to concurrent update
```

Now let's execute the same thing but with enabled retries:

```iex
iex(8)> spawn(fn ->
...(8)>  {:ok, client} = Gel.start_link()
...(8)>  Gel.transaction(client, &callback.(&1, "new_body_1"))
...(8)> end)
iex(9)> Gel.transaction(client, &callback.(&1, "new_body_2"))
{:ok, :ok}
```

All failed transactions will be retried until they succeed or until the number of retries exceeds the limit (the default is 3).

## Example

You can also check out an example application using this client to see how to work with it:

https://github.com/nsidnev/edgebeats
