defmodule Gel.ConfigMemory do
  @moduledoc """
  An immutable value represeting an Gel `cfg::memory` value as a quantity of memory storage.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> mem = Gel.query_required_single!(client, "select <cfg::memory>'5KiB'")
  #Gel.ConfigMemory<"5KiB">
  iex(3)> Gel.ConfigMemory.bytes(mem)
  5120
  ```
  """

  defstruct bytes: 0

  @typedoc """
  An immutable value represeting an Gel `cfg::memory` value as a quantity of memory storage.
  """
  @opaque t() :: %__MODULE__{
            bytes: non_neg_integer()
          }

  @doc since: "0.7.0"
  @doc """
  Create a new config memory value.
  """
  @spec new(non_neg_integer()) :: t()
  def new(bytes) do
    %__MODULE__{bytes: bytes}
  end

  @doc """
  Get a quantity of memory storage in bytes.
  """
  @spec bytes(t()) :: pos_integer()
  def bytes(%__MODULE__{bytes: bytes}) do
    bytes
  end
end

defimpl Inspect, for: Gel.ConfigMemory do
  import Inspect.Algebra

  @kib 1024
  @mib 1024 * @kib
  @gib 1024 * @mib
  @tib 1024 * @gib
  @pib 1024 * @tib

  @impl Inspect
  def inspect(%Gel.ConfigMemory{bytes: bytes}, _opts) do
    bytes_repr =
      cond do
        bytes >= @pib and rem(bytes, @pib) == 0 ->
          "#{div(bytes, @pib)}PiB"

        bytes >= @tib and rem(bytes, @tib) == 0 ->
          "#{div(bytes, @tib)}TiB"

        bytes >= @gib and rem(bytes, @gib) == 0 ->
          "#{div(bytes, @gib)}GiB"

        bytes >= @mib and rem(bytes, @mib) == 0 ->
          "#{div(bytes, @mib)}MiB"

        bytes >= @kib and rem(bytes, @kib) == 0 ->
          "#{div(bytes, @kib)}KiB"

        true ->
          "#{bytes}B"
      end

    concat(["#Gel.ConfigMemory<\"", bytes_repr, "\">"])
  end
end
