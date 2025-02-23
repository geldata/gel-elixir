defmodule Gel.Protocol.Codecs.DateDuration do
  @moduledoc false

  @behaviour Gel.Protocol.BaseScalarCodec

  @id UUID.string_to_binary!("00000000-0000-0000-0000-000000000112")
  @name "cal::date_duration"

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

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.DateDuration do
  import Gel.Protocol.Converters

  @impl Gel.Protocol.Codec
  def encode(_codec, %Gel.DateDuration{} = d, _codec_storage) do
    <<16::uint32(), 0::int64(), d.days::int32(), d.months::int32()>>
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, value, _codec_storage) do
    raise Gel.InvalidArgumentError.new(
            "value can not be encoded as cal::date_duration: #{inspect(value)}"
          )
  end

  @impl Gel.Protocol.Codec
  def decode(
        _codec,
        <<16::uint32(), _reserved::int64(), days::int32(), months::int32()>>,
        _codec_storage
      ) do
    %Gel.DateDuration{
      days: days,
      months: months
    }
  end
end
