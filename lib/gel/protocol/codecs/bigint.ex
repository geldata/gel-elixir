defmodule Gel.Protocol.Codecs.BigInt do
  @moduledoc false

  @behaviour Gel.Protocol.BaseScalarCodec

  @id UUID.string_to_binary!("00000000-0000-0000-0000-000000000110")
  @name "std::bigint"

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

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.BigInt do
  import Gel.Protocol.Converters

  alias Gel.Protocol.{
    Codec,
    Codecs
  }

  @decimal_codec Codecs.Decimal.new()

  @impl Codec
  def encode(_codec, number, _codec_storage) when is_float(number) do
    raise Gel.InvalidArgumentError.new(
            "value can not be encoded as std::bigint: value is float: #{inspect(number)}"
          )
  end

  @impl Codec
  def encode(_codec, %Decimal{exp: exp} = number, _codec_storage) when exp != 0 do
    raise Gel.InvalidArgumentError.new(
            "value can not be encoded as std::bigint: bigint numbers can not contain exponent part: #{inspect(number)}"
          )
  end

  @impl Codec
  def encode(_codec, value, codec_storage) do
    [
      <<length::uint32()>>,
      <<ndigits::uint16(), weight::int16(), sign::uint16(), _dscale::uint16()>> | digits
    ] = Codec.encode(@decimal_codec, value, codec_storage)

    [
      <<length::uint32(), ndigits::uint16(), weight::int16(), sign::uint16(), 0::uint16()>>
      | digits
    ]
  rescue
    e in Gel.Error ->
      "value can not be encoded as std::decimal: " <> reason = e.message

      reraise Gel.InvalidArgumentError.new("value can not be encoded as std::bigint: #{reason}"),
              __STACKTRACE__
  end

  @impl Codec
  def decode(_codec, data, codec_storage) do
    Codec.decode(@decimal_codec, data, codec_storage)
  end
end
