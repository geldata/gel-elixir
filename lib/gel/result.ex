defmodule Gel.Result do
  @moduledoc false

  alias Gel.Protocol.Enums

  defstruct [
    :cardinality,
    :required,
    set: [],
    statement: nil
  ]

  @type t() :: %__MODULE__{
          statement: String.t() | nil,
          required: boolean(),
          set: Gel.Set.t() | list(binary()),
          cardinality: Enums.cardinality()
        }

  @spec extract(t()) ::
          {:ok, Gel.Set.t() | term() | :done}
          | {:error, Exception.t()}

  def extract(%__MODULE__{set: data}) when is_list(data) do
    {:error, Gel.InterfaceError.new("result hasn't been decoded yet")}
  end

  def extract(%__MODULE__{cardinality: :at_most_one, required: required, set: set}) do
    if Gel.Set.empty?(set) and required do
      {:error, Gel.NoDataError.new("expected result, but query did not return any data")}
    else
      value =
        set
        |> Enum.take(1)
        |> List.first()

      {:ok, value}
    end
  end

  def extract(%__MODULE__{cardinality: :many, set: %Gel.Set{} = set}) do
    {:ok, set}
  end

  def extract(%__MODULE__{cardinality: :no_result, required: true}) do
    {:error, Gel.InterfaceError.new("query does not return data")}
  end

  def extract(%__MODULE__{cardinality: :no_result}) do
    {:ok, :executed}
  end
end
