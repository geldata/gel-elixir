defmodule Gel.Query do
  @moduledoc false

  alias Gel.Protocol.{
    Codec,
    CodecStorage,
    Enums
  }

  defstruct [
    :statement,
    output_format: :binary,
    implicit_limit: 0,
    inline_type_names: false,
    inline_type_ids: false,
    inline_object_ids: false,
    cardinality: :many,
    result_cardinality: :many,
    required: false,
    is_script: false,
    capabilities: [],
    input_codec: nil,
    output_codec: nil,
    codec_storage: nil,
    cached: false,
    params: [],
    __file__: nil
  ]

  @type t() :: %__MODULE__{
          statement: String.t(),
          output_format: Enums.output_format(),
          implicit_limit: non_neg_integer(),
          inline_type_names: boolean(),
          inline_type_ids: boolean(),
          inline_object_ids: boolean(),
          cardinality: Enums.cardinality(),
          result_cardinality: Enums.cardinality(),
          required: boolean(),
          is_script: boolean(),
          capabilities: Enums.capabilities(),
          input_codec: Codec.id() | nil,
          output_codec: Codec.id() | nil,
          codec_storage: CodecStorage.t(),
          cached: boolean(),
          params: map() | list() | Keyword.t(),
          __file__: Path.t() | nil
        }
end

defimpl DBConnection.Query, for: Gel.Query do
  alias Gel.Protocol.{
    Codec,
    CodecStorage
  }

  @empty_set %Gel.Set{}

  @impl DBConnection.Query
  def decode(%Gel.Query{}, %Gel.Result{set: %Gel.Set{}} = result, _opts) do
    result
  end

  @impl DBConnection.Query
  def decode(
        %Gel.Query{output_codec: out_codec, required: required, codec_storage: codec_storage},
        %Gel.Result{} = result,
        _opts
      ) do
    decode_result(%Gel.Result{result | required: required}, out_codec, codec_storage)
  end

  @impl DBConnection.Query
  def describe(query, _opts) do
    query
  end

  @impl DBConnection.Query
  def encode(%Gel.Query{input_codec: nil}, _params, _opts) do
    raise Gel.InterfaceError.new("query hasn't been prepared")
  end

  @impl DBConnection.Query
  def encode(%Gel.Query{input_codec: in_codec, codec_storage: codec_storage}, params, _opts) do
    codec_storage
    |> CodecStorage.get(in_codec)
    |> Codec.encode(params, codec_storage)
  end

  @impl DBConnection.Query
  def parse(%Gel.Query{cached: true}, _opts) do
    raise Gel.InterfaceError.new("query has been prepared")
  end

  @impl DBConnection.Query
  def parse(query, _opts) do
    query
  end

  defp decode_result(%Gel.Result{cardinality: :no_result} = result, _codec, _codec_storage) do
    result
  end

  defp decode_result(%Gel.Result{} = result, codec, codec_storage) do
    encoded_set = result.set
    result = %Gel.Result{result | set: @empty_set}

    encoded_set
    |> Enum.reverse()
    |> Enum.reduce(result, fn data, %Gel.Result{set: set} = result ->
      element =
        codec_storage
        |> CodecStorage.get(codec)
        |> Codec.decode(data, codec_storage)

      %Gel.Result{result | set: add_element_into_set(set, element)}
    end)
    |> then(fn %Gel.Result{set: set} = result ->
      %Gel.Result{result | set: reverse_elements_in_set(set)}
    end)
  end

  defp add_element_into_set(%Gel.Set{items: items} = set, element) do
    %Gel.Set{set | items: [element | items]}
  end

  defp reverse_elements_in_set(%Gel.Set{items: items} = set) do
    %Gel.Set{set | items: Enum.reverse(items)}
  end
end
