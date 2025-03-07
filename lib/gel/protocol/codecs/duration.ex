defmodule Gel.Protocol.Codecs.Duration do
  @moduledoc false

  @behaviour Gel.Protocol.BaseScalarCodec

  @id UUID.string_to_binary!("00000000-0000-0000-0000-00000000010E")
  @name "std::duration"

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

defimpl Gel.Protocol.Codec, for: Gel.Protocol.Codecs.Duration do
  import Gel.Protocol.Converters

  @use_timex Application.compile_env(
               :gel,
               :timex_duration,
               Application.compile_env(:edgedb, :timex_duration, true)
             )

  @impl Gel.Protocol.Codec
  def encode(_codec, duration, _codec_storage) when is_integer(duration) do
    <<16::uint32(), duration::int64(), 0::int32(), 0::int32()>>
  end

  if @use_timex and Code.ensure_loaded?(Timex) do
    @impl Gel.Protocol.Codec
    def encode(codec, %Timex.Duration{} = duration, codec_storage) do
      duration_in_ms = Timex.Duration.to_microseconds(duration)
      encode(codec, duration_in_ms, codec_storage)
    end
  end

  @impl Gel.Protocol.Codec
  def encode(_codec, value, _codec_storage) do
    raise Gel.InvalidArgumentError.new(
            "value can not be encoded as std::duration: #{inspect(value)}"
          )
  end

  if @use_timex and Code.ensure_loaded?(Timex) do
    @impl Gel.Protocol.Codec
    def decode(
          _codec,
          <<16::uint32(), duration::int64(), 0::int32(), 0::int32()>>,
          _codec_storage
        ) do
      Timex.Duration.from_microseconds(duration)
    end
  else
    @impl Gel.Protocol.Codec
    def decode(
          _codec,
          <<16::uint32(), duration::int64(), 0::int32(), 0::int32()>>,
          _codec_storage
        ) do
      duration
    end
  end
end
