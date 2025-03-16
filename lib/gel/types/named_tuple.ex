defmodule Gel.NamedTuple do
  @moduledoc """
  An immutable value representing an Gel named tuple value.

  `Gel.NamedTuple` implements `Access` behavior to access fields
    by index or key and `Enumerable` protocol for iterating over tuple values.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> nt = Gel.query_required_single!(client, "select (a := 1, b := 'a', c := [3])")
  #Gel.NamedTuple<a: 1, b: "a", c: [3]>
  iex(3)> nt[:b]
  "a"
  iex(4)> nt["c"]
  [3]
  iex(4)> nt[0]
  1
  ```
  """

  @behaviour Access

  defstruct items: %{},
            order: %{}

  @typedoc """
  An immutable value representing an Gel named tuple value.
  """
  @opaque t() :: %__MODULE__{
            order: %{non_neg_integer() => String.t()},
            items: %{String.t() => term()}
          }

  @doc """
  Convert a named tuple to a regular erlang tuple.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> nt = Gel.query_required_single!(client, "select (a := 1, b := 'a', c := [3])")
  iex(3)> Gel.NamedTuple.to_tuple(nt)
  {1, "a", [3]}
  ```
  """
  @spec to_tuple(t()) :: tuple()
  def to_tuple(%__MODULE__{} = nt) do
    nt
    |> Enum.into([])
    |> List.to_tuple()
  end

  @doc since: "0.3.0"
  @doc """
  Convert a named tuple into a regular map.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> nt = Gel.query_required_single!(client, "select (a := 1, b := 'a', c := [3])")
  iex(3)> Gel.NamedTuple.to_map(nt)
  %{"a" => 1, 0 => 1, "b" => "a", 1 => "a", "c" => [3], 2 => [3]}
  ```
  """
  @spec to_map(t()) :: %{(String.t() | integer()) => term()}
  def to_map(%__MODULE__{items: items, order: fields_order}) do
    fields_order
    |> Enum.into(%{}, fn {index, name} ->
      {index, items[name]}
    end)
    |> Map.merge(items)
  end

  @doc """
  Get named tuple keys.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> nt = Gel.query_required_single!(client, "select (a := 1, b := 'a', c := [3])")
  iex(3)> Gel.NamedTuple.keys(nt)
  ["a", "b", "c"]
  ```
  """
  @spec keys(t()) :: list(String.t())
  def keys(%__MODULE__{order: fields_order}) do
    fields_order
    |> Enum.sort()
    |> Enum.map(fn {_index, name} ->
      name
    end)
  end

  @impl Access
  def fetch(%__MODULE__{items: items, order: fields_order}, index)
      when is_integer(index) do
    with {:ok, name} <- Map.fetch(fields_order, index) do
      Map.fetch(items, name)
    end
  rescue
    ArgumentError ->
      :error
  end

  @impl Access
  def fetch(%__MODULE__{} = tuple, key) when is_atom(key) do
    fetch(tuple, Atom.to_string(key))
  end

  @impl Access
  def fetch(%__MODULE__{items: items}, key) when is_binary(key) do
    Map.fetch(items, key)
  end

  @impl Access
  def get_and_update(%__MODULE__{}, _key, _function) do
    raise Gel.InterfaceError.new("named tuples can't be mutated")
  end

  @impl Access
  def pop(%__MODULE__{}, _key) do
    raise Gel.InterfaceError.new("named tuples can't be mutated")
  end
end

defimpl Enumerable, for: Gel.NamedTuple do
  @impl Enumerable
  def count(%Gel.NamedTuple{items: items}) do
    Enumerable.count(items)
  end

  @impl Enumerable
  def member?(%Gel.NamedTuple{items: items}, element) do
    items
    |> Map.values()
    |> Enumerable.member?(element)
  end

  @impl Enumerable
  def reduce(%Gel.NamedTuple{items: items, order: fields_order}, acc, fun) do
    fields_order
    |> Enum.sort()
    |> Enum.map(fn {_index, name} ->
      items[name]
    end)
    |> Enumerable.reduce(acc, fun)
  end

  @impl Enumerable
  def slice(%Gel.NamedTuple{items: items, order: fields_order}) do
    fields_order
    |> Enum.sort()
    |> Enum.map(fn {_index, name} ->
      items[name]
    end)
    |> Enumerable.slice()
  end
end

defimpl Inspect, for: Gel.NamedTuple do
  import Inspect.Algebra

  @impl Inspect
  def inspect(%Gel.NamedTuple{items: items, order: fields_order}, _opts) do
    {max_index, _name} =
      Enum.max(fields_order, fn ->
        {nil, nil}
      end)

    elements_docs =
      fields_order
      |> Enum.sort()
      |> Enum.map(fn {index, name} ->
        {index, concat([name, ": ", inspect(items[name])])}
      end)
      |> Enum.map(fn
        {^max_index, doc} ->
          doc

        {_index, doc} ->
          concat(doc, ", ")
      end)

    concat(["#Gel.NamedTuple<", concat(elements_docs), ">"])
  end
end
