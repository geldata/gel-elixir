defmodule Gel.Protocol.Codecs.ConfigMemory do
  @moduledoc false

  @behaviour Gel.Protocol.BaseScalarCodec

  @id UUID.string_to_binary!("00000000-0000-0000-0000-000000000130")
  @name "cfg::memory"

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

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.ConfigMemory do
  import Gel.Protocol.Converters

  @impl Gel.Protocol.Codec
  def encode(codec, %Gel.ConfigMemory{} = m, codec_storage) do
    encode(codec, m.bytes, codec_storage)
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, bytes, _codec_storage)
      when is_integer(bytes) and bytes in -0x8000000000000000..0x7FFFFFFFFFFFFFFF do
    <<8::uint32(), bytes::int64()>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, value, _codec_storage) do
    raise Gel.InvalidArgumentError.new(
            "value can not be encoded as cfg::memory: #{inspect(value)}"
          )
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, <<8::uint32(), bytes::int64()>>, _codec_storage) do
    %Gel.ConfigMemory{bytes: bytes}
  end
end
