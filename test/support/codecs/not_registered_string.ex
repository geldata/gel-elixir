defmodule Tests.Support.Codecs.NotRegisteredString do
  @behaviour Gel.Protocol.CustomCodec

  defstruct []

  @impl Gel.Protocol.CustomCodec
  def new do
    %__MODULE__{}
  end

  @impl Gel.Protocol.CustomCodec
  def name do
    "default::not_registered_string"
  end
end

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.NotRegisteredString do
  alias Gel.Protocol.{Codec, Codecs}

  @str_codec Codecs.Str.new()

  @impl Codec
  def encode(_codec, value, codec_storage) do
    Codec.encode(@str_codec, value, codec_storage)
  end

  @impl Codec
  def decode(_codec, data, codec_storage) do
    Codec.decode(@str_codec, data, codec_storage)
  end
end
