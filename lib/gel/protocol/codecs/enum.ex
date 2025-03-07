defmodule Gel.Protocol.Codecs.Enum do
  @moduledoc false

  alias Gel.Protocol.Codec

  defstruct [:id, :name, :members]

  @spec new(Codec.t(), String.t() | nil, list(String.t())) :: Codec.t()
  def new(id, name, members) do
    %__MODULE__{id: id, name: name, members: members}
  end
end

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.Enum do
  alias Gel.Protocol.{
    Codec,
    Codecs
  }

  @str_codec Codecs.Str.new()

  @impl Codec
  def encode(%{members: members}, value, codec_storage) do
    if value in members do
      Codec.encode(@str_codec, value, codec_storage)
    else
      raise Gel.InvalidArgumentError.new(
              "value can not be encoded as enum: not enum member: #{inspect(value)}"
            )
    end
  end

  @impl Codec
  def decode(_codec, data, codec_storage) do
    Codec.decode(@str_codec, data, codec_storage)
  end
end
