defmodule Gel.Protocol.Codecs.DateTime do
  @moduledoc false

  @behaviour Gel.Protocol.BaseScalarCodec

  @id UUID.string_to_binary!("00000000-0000-0000-0000-00000000010A")
  @name "std::datetime"

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

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.DateTime do
  import Gel.Protocol.Converters

  @seconds_before_2000_1_1_utc 946_684_800

  @impl Gel.Protocol.Codec
  def encode(_codec, unix_ts, _codec_storage) when is_integer(unix_ts) do
    edb_datetime =
      System.convert_time_unit(unix_ts - @seconds_before_2000_1_1_utc, :second, :microsecond)

    <<8::uint32(), edb_datetime::int64()>>
  end

  @impl Gel.Protocol.Codec
  def encode(codec, %DateTime{} = dt, codec_storage) do
    unix_ts = DateTime.to_unix(dt)
    encode(codec, unix_ts, codec_storage)
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, value, _codec_storage) do
    raise Gel.InvalidArgumentError.new(
            "value can not be encoded as std::datetime: #{inspect(value)}"
          )
  end

  @impl Gel.Protocol.Codec
  def decode(_codec, <<8::uint32(), edb_datetime::int64()>>, _codec_storage) do
    unix_ts =
      System.convert_time_unit(edb_datetime, :microsecond, :second) + @seconds_before_2000_1_1_utc

    DateTime.from_unix!(unix_ts)
  end
end
