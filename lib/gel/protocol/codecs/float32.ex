defmodule Gel.Protocol.Codecs.Float32 do
  @moduledoc false

  @behaviour Gel.Protocol.BaseScalarCodec

  @id UUID.string_to_binary!("00000000-0000-0000-0000-000000000106")
  @name "std::float32"

  defstruct id: @id,
            name: @name

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
    @name
  end
end

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.Float32 do
  import Gel.Protocol.Converters

  @impl Gel.Protocol.Codec
  def encode(_codec, number, _codec_storage) when is_number(number) do
    <<4::uint32(), number::float32()>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, nan, _codec_storage) when nan in [:nan, :NaN] do
    <<4::uint32(), 0::1, 255, 1::1, 0::22>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, infinity, _codec_storage) when infinity in [:infinity, :inf] do
    <<4::uint32(), 0::1, 255, 0::23>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, negative_infinity, _codec_storage)
      when negative_infinity in [:negative_infinity, :"-inf"] do
    <<4::uint32(), 1::1, 255, 0::23>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, value, _codec_storage) do
    raise Gel.InvalidArgumentError.new(
            "value can not be encoded as std::float32: #{inspect(value)}"
          )
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, <<4::uint32(), 0::1, 255, 1::1, 0::22>>, _codec_storage) do
    :nan
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, <<4::uint32(), 0::1, 255, 0::23>>, _codec_storage) do
    :infinity
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, <<4::uint32(), 1::1, 255, 0::23>>, _codec_storage) do
    :negative_infinity
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, <<4::uint32(), number::float32()>>, _codec_storage) do
    number
  end
end
