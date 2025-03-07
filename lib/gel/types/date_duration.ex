defmodule Gel.DateDuration do
  @moduledoc since: "0.6.0"
  @moduledoc """
  An immutable value represeting an Gel `cal::date_duration` value.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> Gel.query_required_single!(client, "select <cal::date_duration>'1 year 2 days'")
  #Gel.DateDuration<"P1Y2D">
  ```
  """

  defstruct days: 0,
            months: 0

  @typedoc """
  An immutable value represeting an Gel `cal::date_duration` value.

  Fields:

    * `:days` - number of days.
    * `:months` - number of months.
  """
  @type t() :: %__MODULE__{
          days: integer(),
          months: integer()
        }
end

defimpl Inspect, for: Gel.DateDuration do
  import Inspect.Algebra

  @months_per_year 12

  @impl Inspect
  def inspect(%Gel.DateDuration{days: 0, months: 0}, _opts) do
    concat(["#Gel.DateDuration<\"", "P0D", "\">"])
  end

  @impl Inspect
  def inspect(%Gel.DateDuration{} = duration, _opts) do
    concat(["#Gel.DateDuration<\"", format_date("P", duration), "\">"])
  end

  defp format_date(formatted_repr, %Gel.DateDuration{} = duration) do
    formatted_repr
    |> maybe_add_time_part(div(duration.months, @months_per_year), "Y")
    |> maybe_add_time_part(rem(duration.months, @months_per_year), "M")
    |> maybe_add_time_part(duration.days, "D")
  end

  defp maybe_add_time_part(formatted_repr, 0, _letter) do
    formatted_repr
  end

  defp maybe_add_time_part(formatted_repr, value, letter) do
    "#{formatted_repr}#{value}#{letter}"
  end
end
