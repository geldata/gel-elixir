# Elixir client for Gel

Client documentation is available on [hex.pm](https://hexdocs.pm/gel).

How to use:

```elixir
iex(1)> {:ok, client} = Gel.start_link() # NOTE: you should initialize Gel project first
iex(2)> arg = [16, 13, 2, 42]
iex(3)> ^arg = Gel.query_required_single!(client, "select <array<int64>>$arg", arg: arg)
[16, 13, 2, 42]
```
