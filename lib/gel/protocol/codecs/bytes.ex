defmodule Gel.Protocol.Codecs.Bytes do
  @moduledoc false

  @behaviour Gel.Protocol.BaseScalarCodec

  @id UUID.string_to_binary!("00000000-0000-0000-0000-000000000102")
  @name "std::bytes"

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

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.Bytes do
  import Gel.Protocol.Converters

  @impl Gel.Protocol.Codec
  def encode(_codec, bytes, _codec_storage) when is_binary(bytes) do
    [<<byte_size(bytes)::uint32()>>, bytes]
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, value, _codec_storage) do
    raise Gel.InvalidArgumentError.new(
            "value can not be encoded as std::bytes: #{inspect(value)}"
          )
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, <<bytes_size::uint32(), bytes::binary(bytes_size)>>, _codec_storage) do
    :binary.copy(bytes)
  end
end
