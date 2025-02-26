defmodule Gel.Protocol.Codecs.Bool do
  @moduledoc false

  @behaviour Gel.Protocol.BaseScalarCodec

  @id UUID.string_to_binary!("00000000-0000-0000-0000-000000000109")
  @name "std::bool"

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

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.Bool do
  import Gel.Protocol.Converters

  @impl Gel.Protocol.Codec
  def encode(_codec, true, _codec_storage) do
    <<1::uint32(), 1::uint8()>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, false, _codec_storage) do
    <<1::uint32(), 0::uint8()>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, value, _codec_storage) do
    raise Gel.InvalidArgumentError.new("value can not be encoded as std::bool: #{inspect(value)}")
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, <<1::uint32(), 1::uint8()>>, _codec_storage) do
    true
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, <<1::uint32(), 0::uint8()>>, _codec_storage) do
    false
  end
end
