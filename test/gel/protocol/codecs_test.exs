defmodule Tests.Gel.Protocol.CodecsTest do
  use Tests.Support.GelCase

  @builtin_scalar_codecs %{
    "std::uuid" => Gel.Protocol.Codecs.UUID,
    "std::str" => Gel.Protocol.Codecs.Str,
    "std::bytes" => Gel.Protocol.Codecs.Bytes,
    "std::int16" => Gel.Protocol.Codecs.Int16,
    "std::int32" => Gel.Protocol.Codecs.Int32,
    "std::int64" => Gel.Protocol.Codecs.Int64,
    "std::float32" => Gel.Protocol.Codecs.Float32,
    "std::float64" => Gel.Protocol.Codecs.Float64,
    "std::decimal" => Gel.Protocol.Codecs.Decimal,
    "std::bool" => Gel.Protocol.Codecs.Bool,
    "std::datetime" => Gel.Protocol.Codecs.DateTime,
    "std::duration" => Gel.Protocol.Codecs.Duration,
    "std::json" => Gel.Protocol.Codecs.JSON,
    "cal::local_datetime" => Gel.Protocol.Codecs.LocalDateTime,
    "cal::local_date" => Gel.Protocol.Codecs.LocalDate,
    "cal::local_time" => Gel.Protocol.Codecs.LocalTime,
    "std::bigint" => Gel.Protocol.Codecs.BigInt,
    "cal::relative_duration" => Gel.Protocol.Codecs.RelativeDuration,
    "cfg::memory" => Gel.Protocol.Codecs.ConfigMemory
  }

  describe "scalar codec" do
    for {name, codec_mod} <- @builtin_scalar_codecs do
      test "#{name} returns full qualified name from #{codec_mod}.name/0" do
        assert unquote(codec_mod).name() == unquote(name)
      end
    end
  end
end
