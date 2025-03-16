CREATE MIGRATION m1idwmhxpsv2pamu6jm2fv5wipu7ef5str3nil4buejdn2bdyh4lvq
    ONTO m1hb3dkxkqwr2gjsbtb5x2hudlbmhm74jbrzhxwtii2dghsegsan3q
{
  CREATE MODULE v6::codegen IF NOT EXISTS;
  CREATE SCALAR TYPE v6::codegen::BigintType EXTENDING std::bigint;
  CREATE SCALAR TYPE v6::codegen::BoolType EXTENDING std::bool;
  CREATE SCALAR TYPE v6::codegen::BytesType EXTENDING std::bytes;
  CREATE SCALAR TYPE v6::codegen::CalDateDurationType EXTENDING std::cal::date_duration;
  CREATE SCALAR TYPE v6::codegen::CalLocalDateType EXTENDING std::cal::local_date;
  CREATE SCALAR TYPE v6::codegen::CalLocalDatetimeType EXTENDING std::cal::local_datetime;
  CREATE SCALAR TYPE v6::codegen::CalLocalTimeType EXTENDING std::cal::local_time;
  CREATE SCALAR TYPE v6::codegen::CalRelativeDurationType EXTENDING std::cal::relative_duration;
  CREATE SCALAR TYPE v6::codegen::CfgMemoryType EXTENDING cfg::memory;
  CREATE SCALAR TYPE v6::codegen::DatetimeType EXTENDING std::datetime;
  CREATE SCALAR TYPE v6::codegen::DecimalType EXTENDING std::decimal;
  CREATE SCALAR TYPE v6::codegen::DurationType EXTENDING std::duration;
  CREATE SCALAR TYPE v6::codegen::EnumType EXTENDING enum<A, B, C>;
  CREATE SCALAR TYPE v6::codegen::Float32Type EXTENDING std::float32;
  CREATE SCALAR TYPE v6::codegen::Float64Type EXTENDING std::float64;
  CREATE SCALAR TYPE v6::codegen::Int16Type EXTENDING std::int16;
  CREATE SCALAR TYPE v6::codegen::Int32Type EXTENDING std::int32;
  CREATE SCALAR TYPE v6::codegen::Int64Type EXTENDING std::int64;
  CREATE SCALAR TYPE v6::codegen::JsonType EXTENDING std::json;
  CREATE SCALAR TYPE v6::codegen::SequenceType EXTENDING std::sequence;
  CREATE SCALAR TYPE v6::codegen::StrType EXTENDING std::str;
  CREATE SCALAR TYPE v6::codegen::UuidType EXTENDING std::uuid;
  CREATE SCALAR TYPE v6::codegen::VectorType EXTENDING ext::pgvector::vector<1>;
  CREATE TYPE v6::codegen::ArrayPropertiesType {
      CREATE MULTI PROPERTY mp_array: array<std::str>;
      CREATE PROPERTY op_array: array<std::str>;
      CREATE REQUIRED PROPERTY rp_array: array<std::str>;
  };
  CREATE TYPE v6::codegen::BoolPropertiesType {
      CREATE MULTI PROPERTY mp_bool: std::bool;
      CREATE MULTI PROPERTY mp_bool_type: v6::codegen::BoolType;
      CREATE PROPERTY op_bool: std::bool;
      CREATE PROPERTY op_bool_type: v6::codegen::BoolType;
      CREATE REQUIRED PROPERTY rp_bool: std::bool;
      CREATE REQUIRED PROPERTY rp_bool_type: v6::codegen::BoolType;
  };
  CREATE TYPE v6::codegen::CfgMemoryPropertiesType {
      CREATE MULTI PROPERTY mp_cfg_memory: cfg::memory;
      CREATE MULTI PROPERTY mp_cfg_memory_type: v6::codegen::CfgMemoryType;
      CREATE PROPERTY op_cfg_memory: cfg::memory;
      CREATE PROPERTY op_cfg_memory_type: v6::codegen::CfgMemoryType;
      CREATE REQUIRED PROPERTY rp_cfg_memory: cfg::memory;
      CREATE REQUIRED PROPERTY rp_cfg_memory_type: v6::codegen::CfgMemoryType;
  };
  CREATE TYPE v6::codegen::CfgPropertiesType {
      CREATE MULTI LINK ml_cfg_memory: v6::codegen::CfgMemoryPropertiesType;
      CREATE LINK ol_cfg_memory: v6::codegen::CfgMemoryPropertiesType;
      CREATE REQUIRED LINK rl_cfg_memory: v6::codegen::CfgMemoryPropertiesType;
  };
  CREATE TYPE v6::codegen::CalDateDurationPropertiesType {
      CREATE MULTI PROPERTY mp_cal_date_duration: std::cal::date_duration;
      CREATE MULTI PROPERTY mp_cal_date_duration_type: v6::codegen::CalDateDurationType;
      CREATE PROPERTY op_cal_date_duration: std::cal::date_duration;
      CREATE PROPERTY op_cal_date_duration_type: v6::codegen::CalDateDurationType;
      CREATE REQUIRED PROPERTY rp_cal_date_duration: std::cal::date_duration;
      CREATE REQUIRED PROPERTY rp_cal_date_duration_type: v6::codegen::CalDateDurationType;
  };
  CREATE TYPE v6::codegen::CalLocalDatePropertiesType {
      CREATE MULTI PROPERTY mp_cal_local_date: std::cal::local_date;
      CREATE MULTI PROPERTY mp_cal_local_date_type: v6::codegen::CalLocalDateType;
      CREATE PROPERTY op_cal_local_date: std::cal::local_date;
      CREATE PROPERTY op_cal_local_date_type: v6::codegen::CalLocalDateType;
      CREATE REQUIRED PROPERTY rp_cal_local_date: std::cal::local_date;
      CREATE REQUIRED PROPERTY rp_cal_local_date_type: v6::codegen::CalLocalDateType;
  };
  CREATE TYPE v6::codegen::CalLocalDatetimePropertiesType {
      CREATE MULTI PROPERTY mp_cal_local_datetime: std::cal::local_datetime;
      CREATE MULTI PROPERTY mp_cal_local_datetime_type: v6::codegen::CalLocalDatetimeType;
      CREATE PROPERTY op_cal_local_datetime: std::cal::local_datetime;
      CREATE PROPERTY op_cal_local_datetime_type: v6::codegen::CalLocalDatetimeType;
      CREATE REQUIRED PROPERTY rp_cal_local_datetime: std::cal::local_datetime;
      CREATE REQUIRED PROPERTY rp_cal_local_datetime_type: v6::codegen::CalLocalDatetimeType;
  };
  CREATE TYPE v6::codegen::CalLocalTimePropertiesType {
      CREATE MULTI PROPERTY mp_cal_local_time: std::cal::local_time;
      CREATE MULTI PROPERTY mp_cal_local_time_type: v6::codegen::CalLocalTimeType;
      CREATE PROPERTY op_cal_local_time: std::cal::local_time;
      CREATE PROPERTY op_cal_local_time_type: v6::codegen::CalLocalTimeType;
      CREATE REQUIRED PROPERTY rp_cal_local_time: std::cal::local_time;
      CREATE REQUIRED PROPERTY rp_cal_local_time_type: v6::codegen::CalLocalTimeType;
  };
  CREATE TYPE v6::codegen::CalRelativeDurationPropertiesType {
      CREATE MULTI PROPERTY mp_cal_relative_duration: std::cal::relative_duration;
      CREATE MULTI PROPERTY mp_cal_relative_duration_type: v6::codegen::CalRelativeDurationType;
      CREATE PROPERTY op_cal_relative_duration: std::cal::relative_duration;
      CREATE PROPERTY op_cal_relative_duration_type: v6::codegen::CalRelativeDurationType;
      CREATE REQUIRED PROPERTY rp_cal_relative_duration: std::cal::relative_duration;
      CREATE REQUIRED PROPERTY rp_cal_relative_duration_type: v6::codegen::CalRelativeDurationType;
  };
  CREATE TYPE v6::codegen::CalPropertiesType {
      CREATE MULTI LINK ml_cal_date_duration: v6::codegen::CalDateDurationPropertiesType;
      CREATE LINK ol_cal_date_duration: v6::codegen::CalDateDurationPropertiesType;
      CREATE REQUIRED LINK rl_cal_date_duration: v6::codegen::CalDateDurationPropertiesType;
      CREATE MULTI LINK ml_cal_local_date: v6::codegen::CalLocalDatePropertiesType;
      CREATE LINK ol_cal_local_date: v6::codegen::CalLocalDatePropertiesType;
      CREATE REQUIRED LINK rl_cal_local_date: v6::codegen::CalLocalDatePropertiesType;
      CREATE MULTI LINK ml_cal_local_datetime: v6::codegen::CalLocalDatetimePropertiesType;
      CREATE LINK ol_cal_local_datetime: v6::codegen::CalLocalDatetimePropertiesType;
      CREATE REQUIRED LINK rl_cal_local_datetime: v6::codegen::CalLocalDatetimePropertiesType;
      CREATE MULTI LINK ml_cal_local_time: v6::codegen::CalLocalTimePropertiesType;
      CREATE LINK ol_cal_local_time: v6::codegen::CalLocalTimePropertiesType;
      CREATE REQUIRED LINK rl_cal_local_time: v6::codegen::CalLocalTimePropertiesType;
      CREATE MULTI LINK ml_cal_relative_duration: v6::codegen::CalRelativeDurationPropertiesType;
      CREATE LINK ol_cal_relative_duration: v6::codegen::CalRelativeDurationPropertiesType;
      CREATE REQUIRED LINK rl_cal_relative_duration: v6::codegen::CalRelativeDurationPropertiesType;
  };
  CREATE TYPE v6::codegen::DatetimePropertiesType {
      CREATE MULTI PROPERTY mp_datetime: std::datetime;
      CREATE MULTI PROPERTY mp_datetime_type: v6::codegen::DatetimeType;
      CREATE PROPERTY op_datetime: std::datetime;
      CREATE PROPERTY op_datetime_type: v6::codegen::DatetimeType;
      CREATE REQUIRED PROPERTY rp_datetime: std::datetime;
      CREATE REQUIRED PROPERTY rp_datetime_type: v6::codegen::DatetimeType;
  };
  CREATE TYPE v6::codegen::DurationPropertiesType {
      CREATE MULTI PROPERTY mp_duration: std::duration;
      CREATE MULTI PROPERTY mp_duration_type: v6::codegen::DurationType;
      CREATE PROPERTY op_duration: std::duration;
      CREATE PROPERTY op_duration_type: v6::codegen::DurationType;
      CREATE REQUIRED PROPERTY rp_duration: std::duration;
      CREATE REQUIRED PROPERTY rp_duration_type: v6::codegen::DurationType;
  };
  CREATE TYPE v6::codegen::DateAndTimePropertiesType {
      CREATE MULTI LINK ml_cal: v6::codegen::CalPropertiesType;
      CREATE LINK ol_cal: v6::codegen::CalPropertiesType;
      CREATE REQUIRED LINK rl_cal: v6::codegen::CalPropertiesType;
      CREATE MULTI LINK ml_datetime: v6::codegen::DatetimePropertiesType;
      CREATE MULTI LINK ml_duration: v6::codegen::DurationPropertiesType;
      CREATE LINK ol_datetime: v6::codegen::DatetimePropertiesType;
      CREATE LINK ol_duration: v6::codegen::DurationPropertiesType;
      CREATE REQUIRED LINK rl_datetime: v6::codegen::DatetimePropertiesType;
      CREATE REQUIRED LINK rl_duration: v6::codegen::DurationPropertiesType;
  };
  CREATE TYPE v6::codegen::EnumPropertiesType {
      CREATE MULTI PROPERTY mp_enum_type: v6::codegen::EnumType;
      CREATE PROPERTY op_enum_type: v6::codegen::EnumType;
      CREATE REQUIRED PROPERTY rp_enum_type: v6::codegen::EnumType;
  };
  CREATE TYPE v6::codegen::JsonPropertiesType {
      CREATE MULTI PROPERTY mp_json: std::json;
      CREATE MULTI PROPERTY mp_json_type: v6::codegen::JsonType;
      CREATE PROPERTY op_json: std::json;
      CREATE PROPERTY op_json_type: v6::codegen::JsonType;
      CREATE REQUIRED PROPERTY rp_json: std::json;
      CREATE REQUIRED PROPERTY rp_json_type: v6::codegen::JsonType;
  };
  CREATE TYPE v6::codegen::BigintPropertiesType {
      CREATE MULTI PROPERTY mp_bigint: std::bigint;
      CREATE MULTI PROPERTY mp_bigint_type: v6::codegen::BigintType;
      CREATE PROPERTY op_bigint: std::bigint;
      CREATE PROPERTY op_bigint_type: v6::codegen::BigintType;
      CREATE REQUIRED PROPERTY rp_bigint: std::bigint;
      CREATE REQUIRED PROPERTY rp_bigint_type: v6::codegen::BigintType;
  };
  CREATE TYPE v6::codegen::DecimalPropertiesType {
      CREATE MULTI PROPERTY mp_decimal: std::decimal;
      CREATE MULTI PROPERTY mp_decimal_type: v6::codegen::DecimalType;
      CREATE PROPERTY op_decimal: std::decimal;
      CREATE PROPERTY op_decimal_type: v6::codegen::DecimalType;
      CREATE REQUIRED PROPERTY rp_decimal: std::decimal;
      CREATE REQUIRED PROPERTY rp_decimal_type: v6::codegen::DecimalType;
  };
  CREATE TYPE v6::codegen::Float32PropertiesType {
      CREATE MULTI PROPERTY mp_float32: std::float32;
      CREATE MULTI PROPERTY mp_float32_type: v6::codegen::Float32Type;
      CREATE PROPERTY op_float32: std::float32;
      CREATE PROPERTY op_float32_type: v6::codegen::Float32Type;
      CREATE REQUIRED PROPERTY rp_float32: std::float32;
      CREATE REQUIRED PROPERTY rp_float32_type: v6::codegen::Float32Type;
  };
  CREATE TYPE v6::codegen::Float64PropertiesType {
      CREATE MULTI PROPERTY mp_float64: std::float64;
      CREATE MULTI PROPERTY mp_float64_type: v6::codegen::Float64Type;
      CREATE PROPERTY op_float64: std::float64;
      CREATE PROPERTY op_float64_type: v6::codegen::Float64Type;
      CREATE REQUIRED PROPERTY rp_float64: std::float64;
      CREATE REQUIRED PROPERTY rp_float64_type: v6::codegen::Float64Type;
  };
  CREATE TYPE v6::codegen::Int16PropertiesType {
      CREATE MULTI PROPERTY mp_int16: std::int16;
      CREATE MULTI PROPERTY mp_int16_type: v6::codegen::Int16Type;
      CREATE PROPERTY op_int16: std::int16;
      CREATE PROPERTY op_int16_type: v6::codegen::Int16Type;
      CREATE REQUIRED PROPERTY rp_int16: std::int16;
      CREATE REQUIRED PROPERTY rp_int16_type: v6::codegen::Int16Type;
  };
  CREATE TYPE v6::codegen::Int32PropertiesType {
      CREATE MULTI PROPERTY mp_int32: std::int32;
      CREATE MULTI PROPERTY mp_int32_type: v6::codegen::Int32Type;
      CREATE PROPERTY op_int32: std::int32;
      CREATE PROPERTY op_int32_type: v6::codegen::Int32Type;
      CREATE REQUIRED PROPERTY rp_int32: std::int32;
      CREATE REQUIRED PROPERTY rp_int32_type: v6::codegen::Int32Type;
  };
  CREATE TYPE v6::codegen::Int64PropertiesType {
      CREATE MULTI PROPERTY mp_int64: std::int64;
      CREATE MULTI PROPERTY mp_int64_type: v6::codegen::Int64Type;
      CREATE PROPERTY op_int64: std::int64;
      CREATE PROPERTY op_int64_type: v6::codegen::Int64Type;
      CREATE REQUIRED PROPERTY rp_int64: std::int64;
      CREATE REQUIRED PROPERTY rp_int64_type: v6::codegen::Int64Type;
  };
  CREATE TYPE v6::codegen::NumberPropertiesType {
      CREATE MULTI LINK ml_bigint: v6::codegen::BigintPropertiesType;
      CREATE LINK ol_bigint: v6::codegen::BigintPropertiesType;
      CREATE REQUIRED LINK rl_bigint: v6::codegen::BigintPropertiesType;
      CREATE MULTI LINK ml_decimal: v6::codegen::DecimalPropertiesType;
      CREATE LINK ol_decimal: v6::codegen::DecimalPropertiesType;
      CREATE REQUIRED LINK rl_decimal: v6::codegen::DecimalPropertiesType;
      CREATE MULTI LINK ml_float32: v6::codegen::Float32PropertiesType;
      CREATE LINK ol_float32: v6::codegen::Float32PropertiesType;
      CREATE REQUIRED LINK rl_float32: v6::codegen::Float32PropertiesType;
      CREATE MULTI LINK ml_float64: v6::codegen::Float64PropertiesType;
      CREATE LINK ol_float64: v6::codegen::Float64PropertiesType;
      CREATE REQUIRED LINK rl_float64: v6::codegen::Float64PropertiesType;
      CREATE MULTI LINK ml_int16: v6::codegen::Int16PropertiesType;
      CREATE LINK ol_int16: v6::codegen::Int16PropertiesType;
      CREATE REQUIRED LINK rl_int16: v6::codegen::Int16PropertiesType;
      CREATE MULTI LINK ml_int32: v6::codegen::Int32PropertiesType;
      CREATE LINK ol_int32: v6::codegen::Int32PropertiesType;
      CREATE REQUIRED LINK rl_int32: v6::codegen::Int32PropertiesType;
      CREATE MULTI LINK ml_int64: v6::codegen::Int64PropertiesType;
      CREATE LINK ol_int64: v6::codegen::Int64PropertiesType;
      CREATE REQUIRED LINK rl_int64: v6::codegen::Int64PropertiesType;
  };
  CREATE TYPE v6::codegen::MultiRangeCalLocalDatePropertiesType {
      CREATE MULTI PROPERTY mp_multirange_cal_local_date: multirange<std::cal::local_date>;
      CREATE PROPERTY op_multirange_cal_local_date: multirange<std::cal::local_date>;
      CREATE REQUIRED PROPERTY rp_multirange_cal_local_date: multirange<std::cal::local_date>;
  };
  CREATE TYPE v6::codegen::SingleRangeCalLocalDatePropertiesType {
      CREATE MULTI PROPERTY mp_range_cal_local_date: range<std::cal::local_date>;
      CREATE PROPERTY op_range_cal_local_date: range<std::cal::local_date>;
      CREATE REQUIRED PROPERTY rp_range_cal_local_date: range<std::cal::local_date>;
  };
  CREATE TYPE v6::codegen::RangeCalLocalDatePropertiesType {
      CREATE MULTI LINK ml_multi_range_cal_local_date: v6::codegen::MultiRangeCalLocalDatePropertiesType;
      CREATE LINK ol_multi_range_cal_local_date: v6::codegen::MultiRangeCalLocalDatePropertiesType;
      CREATE REQUIRED LINK rl_multi_range_cal_local_date: v6::codegen::MultiRangeCalLocalDatePropertiesType;
      CREATE MULTI LINK ml_single_range_cal_local_date: v6::codegen::SingleRangeCalLocalDatePropertiesType;
      CREATE LINK ol_single_range_cal_local_date: v6::codegen::SingleRangeCalLocalDatePropertiesType;
      CREATE REQUIRED LINK rl_single_range_cal_local_date: v6::codegen::SingleRangeCalLocalDatePropertiesType;
  };
  CREATE TYPE v6::codegen::MultiRangeCalLocalDatetimePropertiesType {
      CREATE MULTI PROPERTY mp_multirange_cal_local_datetime: multirange<std::cal::local_datetime>;
      CREATE PROPERTY op_multirange_cal_local_datetime: multirange<std::cal::local_datetime>;
      CREATE REQUIRED PROPERTY rp_multirange_cal_local_datetime: multirange<std::cal::local_datetime>;
  };
  CREATE TYPE v6::codegen::SingleRangeCalLocalDatetimePropertiesType {
      CREATE MULTI PROPERTY mp_range_cal_local_datetime: range<std::cal::local_datetime>;
      CREATE PROPERTY op_range_cal_local_datetime: range<std::cal::local_datetime>;
      CREATE REQUIRED PROPERTY rp_range_cal_local_datetime: range<std::cal::local_datetime>;
  };
  CREATE TYPE v6::codegen::RangeCalLocalDatetimePropertiesType {
      CREATE MULTI LINK ml_multi_range_cal_local_datetime: v6::codegen::MultiRangeCalLocalDatetimePropertiesType;
      CREATE LINK ol_multi_range_cal_local_datetime: v6::codegen::MultiRangeCalLocalDatetimePropertiesType;
      CREATE REQUIRED LINK rl_multi_range_cal_local_datetime: v6::codegen::MultiRangeCalLocalDatetimePropertiesType;
      CREATE MULTI LINK ml_single_range_cal_local_datetime: v6::codegen::SingleRangeCalLocalDatetimePropertiesType;
      CREATE LINK ol_single_range_cal_local_datetime: v6::codegen::SingleRangeCalLocalDatetimePropertiesType;
      CREATE REQUIRED LINK rl_single_range_cal_local_datetime: v6::codegen::SingleRangeCalLocalDatetimePropertiesType;
  };
  CREATE TYPE v6::codegen::MultiRangeDatetimePropertiesType {
      CREATE MULTI PROPERTY mp_multirange_datetime: multirange<std::datetime>;
      CREATE PROPERTY op_multirange_datetime: multirange<std::datetime>;
      CREATE REQUIRED PROPERTY rp_multirange_datetime: multirange<std::datetime>;
  };
  CREATE TYPE v6::codegen::SingleRangeDatetimePropertiesType {
      CREATE MULTI PROPERTY mp_range_datetime: range<std::datetime>;
      CREATE PROPERTY op_range_datetime: range<std::datetime>;
      CREATE REQUIRED PROPERTY rp_range_datetime: range<std::datetime>;
  };
  CREATE TYPE v6::codegen::RangeDatetimePropertiesType {
      CREATE MULTI LINK ml_multi_range_datetime: v6::codegen::MultiRangeDatetimePropertiesType;
      CREATE LINK ol_multi_range_datetime: v6::codegen::MultiRangeDatetimePropertiesType;
      CREATE REQUIRED LINK rl_multi_range_datetime: v6::codegen::MultiRangeDatetimePropertiesType;
      CREATE MULTI LINK ml_single_range_datetime: v6::codegen::SingleRangeDatetimePropertiesType;
      CREATE LINK ol_single_range_datetime: v6::codegen::SingleRangeDatetimePropertiesType;
      CREATE REQUIRED LINK rl_single_range_datetime: v6::codegen::SingleRangeDatetimePropertiesType;
  };
  CREATE TYPE v6::codegen::MultiRangeDecimalPropertiesType {
      CREATE MULTI PROPERTY mp_multirange_decimal: multirange<std::decimal>;
      CREATE PROPERTY op_multirange_decimal: multirange<std::decimal>;
      CREATE REQUIRED PROPERTY rp_multirange_decimal: multirange<std::decimal>;
  };
  CREATE TYPE v6::codegen::SingleRangeDecimalPropertiesType {
      CREATE MULTI PROPERTY mp_range_decimal: range<std::decimal>;
      CREATE PROPERTY op_range_decimal: range<std::decimal>;
      CREATE REQUIRED PROPERTY rp_range_decimal: range<std::decimal>;
  };
  CREATE TYPE v6::codegen::RangeDecimalPropertiesType {
      CREATE MULTI LINK ml_multi_range_decimal: v6::codegen::MultiRangeDecimalPropertiesType;
      CREATE LINK ol_multi_range_decimal: v6::codegen::MultiRangeDecimalPropertiesType;
      CREATE REQUIRED LINK rl_multi_range_decimal: v6::codegen::MultiRangeDecimalPropertiesType;
      CREATE MULTI LINK ml_single_range_decimal: v6::codegen::SingleRangeDecimalPropertiesType;
      CREATE LINK ol_single_range_decimal: v6::codegen::SingleRangeDecimalPropertiesType;
      CREATE REQUIRED LINK rl_single_range_decimal: v6::codegen::SingleRangeDecimalPropertiesType;
  };
  CREATE TYPE v6::codegen::MultiRangeFloat32PropertiesType {
      CREATE MULTI PROPERTY mp_multirange_float32: multirange<std::float32>;
      CREATE PROPERTY op_multirange_float32: multirange<std::float32>;
      CREATE REQUIRED PROPERTY rp_multirange_float32: multirange<std::float32>;
  };
  CREATE TYPE v6::codegen::SingleRangeFloat32PropertiesType {
      CREATE MULTI PROPERTY mp_range_float32: range<std::float32>;
      CREATE PROPERTY op_range_float32: range<std::float32>;
      CREATE REQUIRED PROPERTY rp_range_float32: range<std::float32>;
  };
  CREATE TYPE v6::codegen::RangeFloat32PropertiesType {
      CREATE MULTI LINK ml_multi_range_float32: v6::codegen::MultiRangeFloat32PropertiesType;
      CREATE LINK ol_multi_range_float32: v6::codegen::MultiRangeFloat32PropertiesType;
      CREATE REQUIRED LINK rl_multi_range_float32: v6::codegen::MultiRangeFloat32PropertiesType;
      CREATE MULTI LINK ml_single_range_float32: v6::codegen::SingleRangeFloat32PropertiesType;
      CREATE LINK ol_single_range_float32: v6::codegen::SingleRangeFloat32PropertiesType;
      CREATE REQUIRED LINK rl_single_range_float32: v6::codegen::SingleRangeFloat32PropertiesType;
  };
  CREATE TYPE v6::codegen::MultiRangeFloat64PropertiesType {
      CREATE MULTI PROPERTY mp_multirange_float64: multirange<std::float64>;
      CREATE PROPERTY op_multirange_float64: multirange<std::float64>;
      CREATE REQUIRED PROPERTY rp_multirange_float64: multirange<std::float64>;
  };
  CREATE TYPE v6::codegen::SingleRangeFloat64PropertiesType {
      CREATE MULTI PROPERTY mp_range_float64: range<std::float64>;
      CREATE PROPERTY op_range_float64: range<std::float64>;
      CREATE REQUIRED PROPERTY rp_range_float64: range<std::float64>;
  };
  CREATE TYPE v6::codegen::RangeFloat64PropertiesType {
      CREATE MULTI LINK ml_multi_range_float64: v6::codegen::MultiRangeFloat64PropertiesType;
      CREATE LINK ol_multi_range_float64: v6::codegen::MultiRangeFloat64PropertiesType;
      CREATE REQUIRED LINK rl_multi_range_float64: v6::codegen::MultiRangeFloat64PropertiesType;
      CREATE MULTI LINK ml_single_range_float64: v6::codegen::SingleRangeFloat64PropertiesType;
      CREATE LINK ol_single_range_float64: v6::codegen::SingleRangeFloat64PropertiesType;
      CREATE REQUIRED LINK rl_single_range_float64: v6::codegen::SingleRangeFloat64PropertiesType;
  };
  CREATE TYPE v6::codegen::MultiRangeInt32PropertiesType {
      CREATE MULTI PROPERTY mp_multi_range_int32: multirange<std::int32>;
      CREATE PROPERTY op_multi_range_int32: multirange<std::int32>;
      CREATE REQUIRED PROPERTY rp_multi_range_int32: multirange<std::int32>;
  };
  CREATE TYPE v6::codegen::SingleRangeInt32PropertiesType {
      CREATE MULTI PROPERTY mp_range_int32: range<std::int32>;
      CREATE PROPERTY op_range_int32: range<std::int32>;
      CREATE REQUIRED PROPERTY rp_range_int32: range<std::int32>;
  };
  CREATE TYPE v6::codegen::RangeInt32PropertiesType {
      CREATE MULTI LINK ml_multi_range_int32: v6::codegen::MultiRangeInt32PropertiesType;
      CREATE LINK ol_multi_range_int32: v6::codegen::MultiRangeInt32PropertiesType;
      CREATE REQUIRED LINK rl_multi_range_int32: v6::codegen::MultiRangeInt32PropertiesType;
      CREATE MULTI LINK ml_single_range_int32: v6::codegen::SingleRangeInt32PropertiesType;
      CREATE LINK ol_single_range_int32: v6::codegen::SingleRangeInt32PropertiesType;
      CREATE REQUIRED LINK rl_single_range_int32: v6::codegen::SingleRangeInt32PropertiesType;
  };
  CREATE TYPE v6::codegen::MultiRangeInt64PropertiesType {
      CREATE MULTI PROPERTY mp_multi_range_int64: multirange<std::int64>;
      CREATE PROPERTY op_multi_range_int64: multirange<std::int64>;
      CREATE REQUIRED PROPERTY rp_multi_range_int64: multirange<std::int64>;
  };
  CREATE TYPE v6::codegen::SingleRangeInt64PropertiesType {
      CREATE MULTI PROPERTY mp_range_int64: range<std::int64>;
      CREATE PROPERTY op_range_int64: range<std::int64>;
      CREATE REQUIRED PROPERTY rp_range_int64: range<std::int64>;
  };
  CREATE TYPE v6::codegen::RangeInt64PropertiesType {
      CREATE MULTI LINK ml_multi_range_int64: v6::codegen::MultiRangeInt64PropertiesType;
      CREATE LINK ol_multi_range_int64: v6::codegen::MultiRangeInt64PropertiesType;
      CREATE REQUIRED LINK rl_multi_range_int64: v6::codegen::MultiRangeInt64PropertiesType;
      CREATE MULTI LINK ml_single_range_int64: v6::codegen::SingleRangeInt64PropertiesType;
      CREATE LINK ol_single_range_int64: v6::codegen::SingleRangeInt64PropertiesType;
      CREATE REQUIRED LINK rl_single_range_int64: v6::codegen::SingleRangeInt64PropertiesType;
  };
  CREATE TYPE v6::codegen::RangePropertiesType {
      CREATE MULTI LINK ml_range_cal_local_date: v6::codegen::RangeCalLocalDatePropertiesType;
      CREATE LINK ol_range_cal_local_date: v6::codegen::RangeCalLocalDatePropertiesType;
      CREATE REQUIRED LINK rl_range_cal_local_date: v6::codegen::RangeCalLocalDatePropertiesType;
      CREATE MULTI LINK ml_range_cal_local_datetime: v6::codegen::RangeCalLocalDatetimePropertiesType;
      CREATE LINK ol_range_cal_local_datetime: v6::codegen::RangeCalLocalDatetimePropertiesType;
      CREATE REQUIRED LINK rl_range_cal_local_datetime: v6::codegen::RangeCalLocalDatetimePropertiesType;
      CREATE MULTI LINK ml_range_datetime: v6::codegen::RangeDatetimePropertiesType;
      CREATE LINK ol_range_datetime: v6::codegen::RangeDatetimePropertiesType;
      CREATE REQUIRED LINK rl_range_datetime: v6::codegen::RangeDatetimePropertiesType;
      CREATE MULTI LINK ml_range_decimal: v6::codegen::RangeDecimalPropertiesType;
      CREATE LINK ol_range_decimal: v6::codegen::RangeDecimalPropertiesType;
      CREATE REQUIRED LINK rl_range_decimal: v6::codegen::RangeDecimalPropertiesType;
      CREATE MULTI LINK ml_range_float32: v6::codegen::RangeFloat32PropertiesType;
      CREATE LINK ol_range_float32: v6::codegen::RangeFloat32PropertiesType;
      CREATE REQUIRED LINK rl_range_float32: v6::codegen::RangeFloat32PropertiesType;
      CREATE MULTI LINK ml_range_float64: v6::codegen::RangeFloat64PropertiesType;
      CREATE LINK ol_range_float64: v6::codegen::RangeFloat64PropertiesType;
      CREATE REQUIRED LINK rl_range_float64: v6::codegen::RangeFloat64PropertiesType;
      CREATE MULTI LINK ml_range_int32: v6::codegen::RangeInt32PropertiesType;
      CREATE LINK ol_range_int32: v6::codegen::RangeInt32PropertiesType;
      CREATE REQUIRED LINK rl_range_int32: v6::codegen::RangeInt32PropertiesType;
      CREATE MULTI LINK ml_range_int64: v6::codegen::RangeInt64PropertiesType;
      CREATE LINK ol_range_int64: v6::codegen::RangeInt64PropertiesType;
      CREATE REQUIRED LINK rl_range_int64: v6::codegen::RangeInt64PropertiesType;
  };
  CREATE TYPE v6::codegen::SequencePropertiesType {
      CREATE MULTI PROPERTY mp_sequence_type: v6::codegen::SequenceType;
      CREATE PROPERTY op_sequence_type: v6::codegen::SequenceType;
      CREATE REQUIRED PROPERTY rp_sequence_type: v6::codegen::SequenceType;
  };
  CREATE TYPE v6::codegen::StrPropertiesType {
      CREATE MULTI PROPERTY mp_str: std::str;
      CREATE MULTI PROPERTY mp_str_type: v6::codegen::StrType;
      CREATE PROPERTY op_str: std::str;
      CREATE PROPERTY op_str_type: v6::codegen::StrType;
      CREATE REQUIRED PROPERTY rp_str: std::str;
      CREATE REQUIRED PROPERTY rp_str_type: v6::codegen::StrType;
  };
  CREATE TYPE v6::codegen::NamedTuplePropertiesType {
      CREATE MULTI PROPERTY mp_named_tuple: tuple<a: std::str, b: std::bool, c: tuple<a: std::str, b: std::bool, c: v6::codegen::EnumType>>;
      CREATE PROPERTY op_named_tuple: tuple<a: std::str, b: std::bool, c: tuple<a: std::str, b: std::bool, c: v6::codegen::EnumType>>;
      CREATE REQUIRED PROPERTY rp_named_tuple: tuple<a: std::str, b: std::bool, c: tuple<a: std::str, b: std::bool, c: v6::codegen::EnumType>>;
  };
  CREATE TYPE v6::codegen::UnnamedTuplePropertiesType {
      CREATE MULTI PROPERTY mp_unnamed_tuple: tuple<std::str, std::bool, tuple<std::str, std::bool, v6::codegen::EnumType>>;
      CREATE PROPERTY op_unnamed_tuple: tuple<std::str, std::bool, tuple<std::str, std::bool, v6::codegen::EnumType>>;
      CREATE REQUIRED PROPERTY rp_unnamed_tuple: tuple<std::str, std::bool, tuple<std::str, std::bool, v6::codegen::EnumType>>;
  };
  CREATE TYPE v6::codegen::TuplePropertiesType {
      CREATE MULTI LINK ml_named_tuple: v6::codegen::NamedTuplePropertiesType;
      CREATE LINK ol_named_tuple: v6::codegen::NamedTuplePropertiesType;
      CREATE REQUIRED LINK rl_named_tuple: v6::codegen::NamedTuplePropertiesType;
      CREATE MULTI LINK ml_unnamed_tuple: v6::codegen::UnnamedTuplePropertiesType;
      CREATE LINK ol_unnamed_tuple: v6::codegen::UnnamedTuplePropertiesType;
      CREATE REQUIRED LINK rl_unnamed_tuple: v6::codegen::UnnamedTuplePropertiesType;
  };
  CREATE TYPE v6::codegen::UuidPropertiesType {
      CREATE MULTI PROPERTY mp_uuid: std::uuid;
      CREATE MULTI PROPERTY mp_uuid_type: v6::codegen::UuidType;
      CREATE PROPERTY op_uuid: std::uuid;
      CREATE PROPERTY op_uuid_type: v6::codegen::UuidType;
      CREATE REQUIRED PROPERTY rp_uuid: std::uuid;
      CREATE REQUIRED PROPERTY rp_uuid_type: v6::codegen::UuidType;
  };
  CREATE TYPE v6::codegen::VectorPropertiesType {
      CREATE MULTI PROPERTY mp_vector_type: v6::codegen::VectorType;
      CREATE PROPERTY op_vector_type: v6::codegen::VectorType;
      CREATE REQUIRED PROPERTY rp_vector_type: v6::codegen::VectorType;
  };
  CREATE TYPE v6::codegen::Aggregate {
      CREATE MULTI LINK ml_array: v6::codegen::ArrayPropertiesType;
      CREATE MULTI LINK ml_bool: v6::codegen::BoolPropertiesType;
      CREATE MULTI LINK ml_cfg: v6::codegen::CfgPropertiesType;
      CREATE MULTI LINK ml_date_and_time: v6::codegen::DateAndTimePropertiesType;
      CREATE MULTI LINK ml_enum: v6::codegen::EnumPropertiesType;
      CREATE MULTI LINK ml_json: v6::codegen::JsonPropertiesType;
      CREATE MULTI LINK ml_number: v6::codegen::NumberPropertiesType;
      CREATE MULTI LINK ml_range: v6::codegen::RangePropertiesType;
      CREATE MULTI LINK ml_sequence: v6::codegen::SequencePropertiesType;
      CREATE MULTI LINK ml_str: v6::codegen::StrPropertiesType;
      CREATE MULTI LINK ml_tuple: v6::codegen::TuplePropertiesType;
      CREATE MULTI LINK ml_uuid: v6::codegen::UuidPropertiesType;
      CREATE MULTI LINK ml_vector: v6::codegen::VectorPropertiesType;
      CREATE LINK ol_array: v6::codegen::ArrayPropertiesType;
      CREATE LINK ol_bool: v6::codegen::BoolPropertiesType;
      CREATE LINK ol_cfg: v6::codegen::CfgPropertiesType;
      CREATE LINK ol_date_and_time: v6::codegen::DateAndTimePropertiesType;
      CREATE LINK ol_enum: v6::codegen::EnumPropertiesType;
      CREATE LINK ol_json: v6::codegen::JsonPropertiesType;
      CREATE LINK ol_number: v6::codegen::NumberPropertiesType;
      CREATE LINK ol_range: v6::codegen::RangePropertiesType;
      CREATE LINK ol_sequence: v6::codegen::SequencePropertiesType;
      CREATE LINK ol_str: v6::codegen::StrPropertiesType;
      CREATE LINK ol_tuple: v6::codegen::TuplePropertiesType;
      CREATE LINK ol_uuid: v6::codegen::UuidPropertiesType;
      CREATE LINK ol_vector: v6::codegen::VectorPropertiesType;
      CREATE REQUIRED LINK rl_array: v6::codegen::ArrayPropertiesType;
      CREATE REQUIRED LINK rl_bool: v6::codegen::BoolPropertiesType;
      CREATE REQUIRED LINK rl_cfg: v6::codegen::CfgPropertiesType;
      CREATE REQUIRED LINK rl_date_and_time: v6::codegen::DateAndTimePropertiesType;
      CREATE REQUIRED LINK rl_enum: v6::codegen::EnumPropertiesType;
      CREATE REQUIRED LINK rl_json: v6::codegen::JsonPropertiesType;
      CREATE REQUIRED LINK rl_number: v6::codegen::NumberPropertiesType;
      CREATE REQUIRED LINK rl_range: v6::codegen::RangePropertiesType;
      CREATE REQUIRED LINK rl_sequence: v6::codegen::SequencePropertiesType;
      CREATE REQUIRED LINK rl_str: v6::codegen::StrPropertiesType;
      CREATE REQUIRED LINK rl_tuple: v6::codegen::TuplePropertiesType;
      CREATE REQUIRED LINK rl_uuid: v6::codegen::UuidPropertiesType;
      CREATE REQUIRED LINK rl_vector: v6::codegen::VectorPropertiesType;
  };
};
