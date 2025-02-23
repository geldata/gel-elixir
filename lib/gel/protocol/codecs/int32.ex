defmodule Gel.Protocol.Codecs.Int32 do
  @moduledoc false

  @behaviour Gel.Protocol.BaseScalarCodec

  @id UUID.string_to_binary!("00000000-0000-0000-0000-000000000104")
  @name "std::int32"

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

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.Int32 do
  import Gel.Protocol.Converters

  @impl Gel.Protocol.Codec
  def encode(_codec, number, _codec_storage)
      when is_integer(number) and number in -0x80000000..0x7FFFFFFF do
    <<4::uint32(), number::int32()>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, value, _codec_storage) do
    raise Gel.InvalidArgumentError.new(
            "value can not be encoded as std::int32: #{inspect(value)}"
          )
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, <<4::uint32(), number::int32()>>, _codec_storage) do
    number
  end
end
