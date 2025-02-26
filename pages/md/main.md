# Gel client for Elixir

`gel-elixir` is the [Gel](https://geldata.com) client for Elixir. The documentation for client
  is available on [hex.pm](https://hexdocs.pm/gel).

## Installation

`gel-elixir` is available on [hex.pm](https://hex.pm/packages/gel) and can be installed via `mix`.
  Just add `:gel` to your dependencies in the `mix.exs` file:

```elixir
{:gel, "~> 0.9"}
```

## JSON support

`Gel` comes with JSON support out of the box via the `Jason` library.
  To use it, add `:jason` to your dependencies in the `mix.exs` file:

```elixir
{:jason, "~> 1.0"}
```

The JSON library can be configured using the `:json` option in the `:gel` application configuration:

```elixir
config :gel,
    json: CustomJSONLibrary
```

The JSON library is injected in the compiled `Gel` code, so be sure to recompile `Gel` if you change it:

```bash
$ mix deps.clean gel --build
```

## Timex support

`Gel` can work with `Timex` out of the box. If you define `Timex` as an application dependency,
  `Gel` will use `Timex.Duration` to encode and decode the `std::duration` type from database.
  If you don't like this behavior, you can set `Gel` to ignore `Timex` using
  the `:timex_duration` option by setting this to false in the `:gel` application configuration:

```elixir
config :gel,
    timex_duration: false
```

`Gel` will inject the use of `Timex` into the `std::duration` codec at compile time,
  so be sure to recompile `Gel` if you change this behavior:

```bash
$ mix deps.clean gel --build
```

## License

This project is licensed under the terms of the Apache 2.0 license.
  See [LICENSE](https://github.com/geldata/gel-elixir/blob/master/LICENSE) for details.
