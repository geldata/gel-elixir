defmodule Gel.Client.State do
  @moduledoc """
  State for the client is an execution context that affects the execution of EdgeQL commands in different ways:

    1. default module.
    2. module aliases.
    3. session config.
    4. global values.

  The most convenient way to work with the state is to use the `Gel` API to change a required part of
    the state.

  See `Gel.with_client_state/2`, `Gel.with_default_module/2`,
    `Gel.with_module_aliases/2`/`Gel.without_module_aliases/2`,
    `Gel.with_config/2`/`Gel.without_config/2` and
    `Gel.with_globals/2`/`Gel.without_globals/2` for more information.
  """

  @default_module "default"

  defstruct module: @default_module,
            aliases: %{},
            config: %{},
            globals: %{}

  @typedoc since: "0.7.0"
  @typedoc """
  Keys that Gel accepts for changing client behaviour configuration.

  The meaning and acceptable values can be found in the
    [docs](https://docs.geldata.com/database/stdlib/cfg#client-connections).
  """
  @type config_key() ::
          :allow_user_specified_id
          | :session_idle_timeout
          | :session_idle_transaction_timeout
          | :query_execution_timeout

  @typedoc since: "0.7.0"
  @typedoc """
  Config to be passed to `Gel.with_config/2`.
  """
  @type config() ::
          %{config_key() => term()}
          | list({config_key(), term()})

  @typedoc """
  State for the client is an execution context that affects the execution of EdgeQL commands.
  """
  @opaque t() :: %__MODULE__{
            module: String.t() | nil,
            aliases: %{String.t() => String.t()},
            config: %{config_key() => term()},
            globals: %{String.t() => term()}
          }

  @doc """
  Returns an `Gel.Client.State` with adjusted default module.

  This is equivalent to using the `set module` command,
    or using the `reset module` command when giving `nil`.
  """
  @spec with_default_module(t(), String.t() | nil) :: t()
  def with_default_module(%__MODULE__{} = state, module \\ nil) do
    %__MODULE__{state | module: module}
  end

  @doc """
  Returns an `Gel.Client.State` with adjusted module aliases.

  This is equivalent to using the `set alias` command.
  """
  @spec with_module_aliases(t(), %{String.t() => String.t()}) :: t()
  def with_module_aliases(%__MODULE__{} = state, aliases \\ %{}) do
    %__MODULE__{state | aliases: Map.merge(state.aliases, aliases)}
  end

  @doc """
  Returns an `Gel.Client.State` without specified module aliases.

  This is equivalent to using the `reset alias` command.
  """
  @spec without_module_aliases(t(), list(String.t())) :: t()
  def without_module_aliases(%__MODULE__{} = state, aliases \\ []) do
    %__MODULE__{state | aliases: Map.drop(state.aliases, aliases)}
  end

  @doc """
  Returns an `Gel.Client.State` with adjusted session config.

  This is equivalent to using the `configure session set` command.
  """
  @spec with_config(t(), config()) :: t()
  def with_config(%__MODULE__{} = state, config \\ %{}) do
    config = Enum.into(config, %{})
    %__MODULE__{state | config: Map.merge(state.config, config)}
  end

  @doc """
  Returns an `Gel.Client.State` without specified session config.

  This is equivalent to using the `configure session reset` command.
  """
  @spec without_config(t(), list(config_key())) :: t()
  def without_config(%__MODULE__{} = state, config_keys \\ []) do
    %__MODULE__{state | config: Map.drop(state.config, config_keys)}
  end

  @doc """
  Returns an `Gel.Client.State` with adjusted global values.

  This is equivalent to using the `set global` command.
  """
  @spec with_globals(t(), %{String.t() => String.t()}) :: t()
  def with_globals(%__MODULE__{} = state, globals \\ %{}) do
    module = state.module || @default_module

    globals =
      state.globals
      |> Map.merge(globals)
      |> Enum.into(%{}, fn {global, value} ->
        {resolve_name(state.aliases, module, global), value}
      end)

    %__MODULE__{state | globals: globals}
  end

  @doc """
  Returns an `Gel.Client.State` without specified globals.

  This is equivalent to using the `reset global` command.
  """
  @spec without_globals(t(), list(String.t())) :: t()
  def without_globals(%__MODULE__{} = state, global_names \\ []) do
    module = state.module || @default_module

    new_globals =
      case global_names do
        [] ->
          state.globals

        global_names ->
          Enum.reduce(
            global_names,
            state.globals,
            &Map.delete(&2, resolve_name(state.aliases, module, &1))
          )
      end

    %__MODULE__{state | globals: new_globals}
  end

  @doc false
  @spec to_encodable(t()) :: map()
  def to_encodable(%__MODULE__{} = state) do
    state
    |> Map.from_struct()
    |> stringify_map_keys()
    |> Enum.reduce(%{}, fn
      {"module", nil}, acc ->
        acc

      {"aliases", aliases}, acc when map_size(aliases) == 0 ->
        acc

      {"aliases", aliases}, acc ->
        Map.put(acc, "aliases", Map.to_list(aliases))

      {"config", config}, acc when map_size(config) == 0 ->
        acc

      {"globals", config}, acc when map_size(config) == 0 ->
        acc

      {key, value}, acc ->
        Map.put(acc, key, value)
    end)
  end

  defp resolve_name(aliases, module_name, global_name) do
    case String.split(global_name, "::") do
      [global_name] ->
        "#{module_name}::#{global_name}"

      [module_name, global_name] ->
        module_name = aliases[module_name] || module_name
        "#{module_name}::#{global_name}"

      _other ->
        raise Gel.InvalidArgumentError.new("invalid global name: #{inspect(global_name)}")
    end
  end

  defp stringify_map_keys(%{} = map) when not is_struct(map) do
    Enum.into(map, %{}, fn
      {key, value} when is_binary(key) ->
        {key, stringify_map_keys(value)}

      {key, value} when is_atom(key) ->
        {to_string(key), stringify_map_keys(value)}
    end)
  end

  defp stringify_map_keys(list) when is_list(list) do
    Enum.map(list, &stringify_map_keys/1)
  end

  defp stringify_map_keys(term) do
    term
  end
end
