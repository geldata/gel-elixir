# Code generation

`gel-elixir` provides a custom `Mix` task for generating Elixir modules from EdgeQL query files.

> #### NOTE {: .info}
>
> Code generation creates a lot of boilerplate code, especially for complex objects,
> so it's not recommended to add such modules to your version control system
> and generate modules as needed instead

> #### WARNING {: .warning}
>
> Although code generation appeared in other languages relatively long time ago,
> it has only been implemented in the Elixir client since version `0.10.0`.
> As this feature is still young enough, it may have some flaws and bugs.
> If you encounter such an issue or have a need for functionality that
> is not supported by code generation at the moment, please consider creating
> an issue in the repository so that we can discuss improvements and enhancements
> to the functionality.

First, add the following lines for `:gel` to the config:

```elixir
config :gel, :generation,
  queries_path: "priv/gel/edgeql/",
  output_path: "lib/my_app/gel/queries",
  module_prefix: MyApp.Gel
```

Or in case you have multiple locations for your queries like this:

```elixir
config :gel,
  generation: [
    [
      queries_path: "priv/gel/edgeql/path1",
      output_path: "lib/my_app/gel/queries/path1",
      module_prefix: MyApp.Gel.Module1
    ],
    [
      queries_path: "priv/gel/edgeql/path2",
      output_path: "lib/my_app/gel/queries/path2",
      module_prefix: MyApp.Gel.Module2
    ],
  ]
```

> #### NOTE {: .info}
>
> `module_prefix` is an optional parameter that allows you to control the prefix for the module being generated

Then, let's place a new EdgeQL query into `priv/gel/edgeql/select_string.edgeql`:

```edgeql
select <optional str>$arg
```

Now we can run `mix gel.generate` and it should produce new `lib/my_app/gel/queries/select_string.edgeql.ex`. The result should look similar to this:

```elixir
defmodule MyApp.Gel.SelectString do
  @query """
  select <optional str>$arg
  """

  @type keyword_args() :: [{:arg, String.t() | nil}]
  @type map_args() :: %{arg: String.t() | nil}
  @type args() :: map_args() | keyword_args()

  @spec query(client :: Gel.client(), args :: args(), opts :: list(Gel.query_option())) ::
          {:ok, String.t() | nil} | {:error, reason} when reason: any()
  def query(client, args, opts \\ []) do
    do_query(client, args, opts)
  end

  @spec query!(client :: Gel.client(), args :: args(), opts :: list(Gel.query_option())) ::
          String.t() | nil
  def query!(client, args, opts \\ []) do
    case do_query(client, args, opts) do
      {:ok, result} ->
        result

      {:error, exc} ->
        raise exc
    end
  end

  defp do_query(client, args, opts) do
    Gel.query_single(client, @query, args, opts)
  end
end
```

To use it just call the `MyApp.Gel.SelectString.query/3` function:

```elixir
iex(1)> {:ok, client} = Gel.start_link()
iex(2)> {:ok, "hello world"} = MyApp.Gel.SelectString.query(client, arg: "hello world")
```

This gives a general idea of how the code generation works, although it is
a bit useless in this case because of its simplicity. More detailed examples of output,
including different nested links, properties and convertion of Gel types to Elixir,
can be found in the repository in tests for code generation feature.
