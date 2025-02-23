defmodule Gel.Range do
  @moduledoc since: "0.4.0"
  @moduledoc """
  A value representing some interval of values.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> Gel.query_required_single!(client, "select range(1, 10)")
  #Gel.Range<[1, 10)>
  ```
  """

  defstruct lower: nil,
            upper: nil,
            inc_lower: true,
            inc_upper: false,
            is_empty: false

  @typedoc since: "0.6.1"
  @typedoc """
  A type that is acceptable by Gel ranges.
  """
  @type value() ::
          integer()
          | float()
          | Decimal.t()
          | DateTime.t()
          | NaiveDateTime.t()
          | Date.t()

  @typedoc """
  A value of `t:Gel.Range.value/0` type representing some interval of values.

  Fields:

    * `:lower` - data for the lower range boundary.
    * `:upper` - data for the upper range boundary.
    * `:inc_lower` - flag whether the range should strictly include the lower boundary.
    * `:inc_upper` - flag whether the range should strictly include the upper boundary.
    * `:is_empty` - flag for an empty range.
  """
  @type t(value) :: %__MODULE__{
          lower: value | nil,
          upper: value | nil,
          inc_lower: boolean(),
          inc_upper: boolean(),
          is_empty: boolean()
        }

  @typedoc """
  A value of `t:Gel.Range.value/0` type representing some interval of values.
  """
  @type t() :: t(value())

  @typedoc """
  Options for `Gel.Range.new/3` function.

  Supported options:

    * `:inc_lower` - flag whether the created range should strictly include the lower boundary.
    * `:inc_upper` - flag whether the created range should strictly include the upper boundary.
    * `:empty` - flag to create an empty range.
  """
  @type creation_option() ::
          {:inc_lower, boolean()}
          | {:inc_upper, boolean()}
          | {:empty, boolean()}

  @doc """
  Create an empty range.

  ```iex
  iex(1)> Gel.Range.empty()
  #Gel.Range<empty>
  ```
  """
  @spec empty() :: t()
  def empty do
    new(nil, nil, empty: true)
  end

  @doc """
  Create new range.

  ```iex
  iex(1)> Gel.Range.new(1.1, 3.3, inc_upper: true)
  #Gel.Range<[1.1, 3.3]>
  ```
  """
  @spec new(value | nil, value | nil, list(creation_option())) :: t(value) when value: value()
  def new(lower, upper, opts \\ []) do
    empty? = Keyword.get(opts, :empty, false)
    inc_lower? = Keyword.get(opts, :inc_lower, true)
    inc_upper? = Keyword.get(opts, :inc_upper, false)

    cond do
      empty? and (not is_nil(lower) or not is_nil(upper)) ->
        raise Gel.InvalidArgumentError.new(
                "conflicting arguments to construct range: " <>
                  ":empty is `true` while the specified bounds " <>
                  "suggest otherwise"
              )

      empty? ->
        %__MODULE__{
          lower: nil,
          upper: nil,
          inc_lower: false,
          inc_upper: false,
          is_empty: true
        }

      true ->
        %__MODULE__{
          lower: lower,
          upper: upper,
          inc_lower: not is_nil(lower) and inc_lower?,
          inc_upper: not is_nil(upper) and inc_upper?,
          is_empty: false
        }
    end
  end
end

defimpl Inspect, for: Gel.Range do
  import Inspect.Algebra

  @impl Inspect
  def inspect(%Gel.Range{is_empty: true}, _opts) do
    concat(["#Gel.Range<empty>"])
  end

  @impl Inspect
  def inspect(%Gel.Range{} = range, opts) do
    concat([
      "#Gel.Range<",
      if(range.inc_lower, do: "[", else: "("),
      if(range.lower, do: Inspect.inspect(range.lower, opts), else: empty()),
      ", ",
      if(range.upper, do: Inspect.inspect(range.upper, opts), else: empty()),
      if(range.inc_upper, do: "]", else: ")"),
      ">"
    ])
  end
end
