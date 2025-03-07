defmodule Gel.MultiRange do
  @moduledoc since: "0.7.0"
  @moduledoc """
  A value representing a collection of ranges.

  `Gel.MultiRange` implements `Enumerable` protocol for iterating over the collection.
    Each range in the collection is an instance of the `t:Gel.Range.t/0` struct.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> Gel.query_required_single!(client, "select multirange([range(1, 10)])")
  #Gel.MultiRange<[#Gel.Range<[1, 10)>]>
  ```
  """

  defstruct ranges: []

  @typedoc """
  A type that is acceptable by Gel ranges.
  """
  @type value() :: Gel.Range.value()

  @typedoc """
  A value of `t:Gel.MultiRange.value/0` type representing a collection of intervals of values.
  """
  @opaque t(value) :: %__MODULE__{
            ranges: list(Gel.Range.t(value))
          }

  @typedoc """
  A value of `t:Gel.MultiRange.value/0` type representing a collection of intervals of values.
  """
  @type t() :: t(value())

  @doc """
  Create a new multirange.
  """
  @spec new() :: t()
  def new do
    %__MODULE__{}
  end

  @doc """
  Create a new multirange from enumerable.
  """
  @spec new(Enumerable.t(Gel.Range.t(v))) :: t(v) when v: value()
  def new(enumerable) do
    %__MODULE__{ranges: Enum.to_list(enumerable)}
  end
end

defimpl Enumerable, for: Gel.MultiRange do
  @impl Enumerable
  def count(%Gel.MultiRange{ranges: ranges}) do
    {:ok, length(ranges)}
  end

  @impl Enumerable
  def member?(%Gel.MultiRange{ranges: []}, _element) do
    {:ok, false}
  end

  @impl Enumerable
  def member?(%Gel.MultiRange{}, _element) do
    {:error, __MODULE__}
  end

  @impl Enumerable
  def slice(%Gel.MultiRange{ranges: []}) do
    {:ok, 0, fn _start, _amount, _step -> [] end}
  end

  @impl Enumerable
  def slice(%Gel.MultiRange{}) do
    {:error, __MODULE__}
  end

  @impl Enumerable
  def reduce(%Gel.MultiRange{}, {:halt, acc}, _fun) do
    {:halted, acc}
  end

  @impl Enumerable
  def reduce(%Gel.MultiRange{} = range, {:suspend, acc}, fun) do
    {:suspended, acc, &reduce(range, &1, fun)}
  end

  @impl Enumerable
  def reduce(%Gel.MultiRange{ranges: []}, {:cont, acc}, _fun) do
    {:done, acc}
  end

  @impl Enumerable
  def reduce(%Gel.MultiRange{ranges: [range | ranges]}, {:cont, acc}, fun) do
    reduce(%Gel.MultiRange{ranges: ranges}, fun.(range, acc), fun)
  end
end

defimpl Inspect, for: Gel.MultiRange do
  import Inspect.Algebra

  @impl Inspect
  def inspect(%Gel.MultiRange{} = range, opts) do
    concat([
      "#Gel.MultiRange<",
      container_doc("[", range.ranges, "]", opts, &Inspect.inspect/2),
      ">"
    ])
  end
end
