defmodule Tests.Support.Codecs.ShortStr do
  @behaviour Gel.Protocol.CustomCodec

  defstruct []

  @impl Gel.Protocol.CustomCodec
  def new do
    %__MODULE__{}
  end

  @impl Gel.Protocol.CustomCodec
  def name do
    "v1::short_str"
  end
end

defimpl Gel.Protocol.Codec, for: Tests.Support.Codecs.ShortStr do
  alias Gel.Protocol.{Codec, Codecs}

  @str_codec Codecs.Str.new()

  @impl Codec
  def encode(_codec, value, codec_storage) when is_binary(value) do
    if String.length(value) <= 5 do
      Codec.encode(@str_codec, value, codec_storage)
    else
      raise Gel.InvalidArgumentError.new("string is too long")
    end
  end

  @impl Codec
  def decode(_codec, data, codec_storage) do
    Codec.decode(@str_codec, data, codec_storage)
  end
end
