defmodule Gel.Protocol.Codecs.Str do
  @moduledoc false

  @behaviour Gel.Protocol.BaseScalarCodec

  @id UUID.string_to_binary!("00000000-0000-0000-0000-000000000101")
  @name "std::str"

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

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.Str do
  import Gel.Protocol.Converters

  @impl Gel.Protocol.Codec
  def encode(_codec, string, _codec_storage) when is_binary(string) do
    [<<byte_size(string)::uint32()>>, string]
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, value, _codec_storage) do
    raise Gel.InvalidArgumentError.new("value can not be encoded as std::str: #{inspect(value)}")
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, <<string_size::uint32(), string::binary(string_size)>>, _codec_storage) do
    :binary.copy(string)
  end
end
