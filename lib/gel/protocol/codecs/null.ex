defmodule Gel.Protocol.Codecs.Null do
  @moduledoc false

  @behaviour Gel.Protocol.BaseScalarCodec

  @id UUID.string_to_binary!("00000000-0000-0000-0000-000000000000")

  defstruct id: @id

  @impl Gel.Protocol.BaseScalarCodec
  def new do
    %__MODULE__{}
  end

  @impl Gel.Protocol.BaseScalarCodec
  def id do
    @id
  end

  @impl Gel.Protocol.BaseScalarCodec
  def name do
    "null"
  end
end

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.Null do
  import Gel.Protocol.Converters

  alias Gel.Protocol.Codec.Gel.Protocol.Codecs.Object

  @impl Gel.Protocol.Codec
  def encode(_codec, [], _codec_storage) do
    <<0::uint32()>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, arguments, _codec_storage) when map_size(arguments) == 0 do
    <<0::uint32()>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, arguments, _codec_storage) when is_list(arguments) or is_map(arguments) do
    arguments
    |> Object.transform_arguments()
    |> Object.raise_wrong_arguments_error!([])
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, nil, _codec_storage) do
    <<>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, value, _codec_storage) do
    Gel.InvalidArgumentError.new("value can not be encoded as null: #{inspect(value)}")
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, _data, _codec_storage) do
    raise Gel.InternalClientError.new("binary data can not be decoded as null")
  end
end
