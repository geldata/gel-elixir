defmodule Gel.Set do
  @moduledoc """
  A representation of an immutable set of values returned by a query.
    Nested sets in the result are also returned as `Gel.Set` objects.

  `Gel.Set` implements `Enumerable` protocol for iterating over set values.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> set =
  ...(2)>  Gel.query!(client, "\"\"
  ...(2)>   select schema::ObjectType{
  ...(2)>     name
  ...(2)>   }
  ...(2)>   filter .name IN {'std::BaseObject', 'std::Object', 'std::FreeObject'}
  ...(2)>   order by .name
  ...(2)>  \"\"")
  iex(3)> set
  #Gel.Set<{#Gel.Object<name := "std::BaseObject">, #Gel.Object<name := "std::FreeObject">, #Gel.Object<name := "std::Object">}>
  ```
  """

  defstruct items: []

  @typedoc """
  A representation of an immutable set of values returned by a query.
  """
  @opaque t() :: %__MODULE__{
            items: list()
          }

  @doc """
  Check if set is empty.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> set = Gel.query!(client, "select v1::Ticket")
  iex(3)> Gel.Set.empty?(set)
  true
  ```
  """
  @spec empty?(t()) :: boolean()

  def empty?(%__MODULE__{items: []}) do
    true
  end

  def empty?(%__MODULE__{}) do
    false
  end
end

defimpl Enumerable, for: Gel.Set do
  @impl Enumerable
  def count(%Gel.Set{items: items}) do
    {:ok, length(items)}
  end

  @impl Enumerable
  def member?(%Gel.Set{items: []}, _element) do
    {:ok, false}
  end

  @impl Enumerable
  def member?(%Gel.Set{}, _element) do
    {:error, __MODULE__}
  end

  @impl Enumerable
  def slice(%Gel.Set{items: []}) do
    {:ok, 0, fn _start, _amount, _step -> [] end}
  end

  @impl Enumerable
  def slice(%Gel.Set{}) do
    {:error, __MODULE__}
  end

  @impl Enumerable
  def reduce(%Gel.Set{}, {:halt, acc}, _fun) do
    {:halted, acc}
  end

  @impl Enumerable
  def reduce(%Gel.Set{} = set, {:suspend, acc}, fun) do
    {:suspended, acc, &reduce(set, &1, fun)}
  end

  @impl Enumerable
  def reduce(%Gel.Set{items: []}, {:cont, acc}, _fun) do
    {:done, acc}
  end

  @impl Enumerable
  def reduce(%Gel.Set{items: [item | items]}, {:cont, acc}, fun) do
    reduce(%Gel.Set{items: items}, fun.(item, acc), fun)
  end
end

defimpl Inspect, for: Gel.Set do
  import Inspect.Algebra

  @impl Inspect
  def inspect(%Gel.Set{} = set, opts) do
    elements = Enum.to_list(set)

    element_fn = fn element, opts ->
      Inspect.inspect(element, opts)
    end

    concat(["#Gel.Set<", container_doc("{", elements, "}", opts, element_fn), ">"])
  end
end
