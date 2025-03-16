select (insert v6::codegen::Aggregate {
    rl_str := (insert v6::codegen::StrPropertiesType {
        rp_str := <str>"rp_str",
        rp_str_type := <v6::codegen::StrType>"rp_str_type",
    }),

    rl_bool := (insert v6::codegen::BoolPropertiesType {
        rp_bool := <bool>true,
        rp_bool_type := <v6::codegen::BoolType>true,
    }),

    rl_number := (insert v6::codegen::NumberPropertiesType {
        rl_int16 := (insert v6::codegen::Int16PropertiesType {
            rp_int16 := <int16>16132,
            rp_int16_type := <v6::codegen::Int16Type>16132,
        }),

        rl_int32 := (insert v6::codegen::Int32PropertiesType {
            rp_int32 := <int32>16132,
            rp_int32_type := <v6::codegen::Int32Type>16132,
        }),

        rl_int64 := (insert v6::codegen::Int64PropertiesType {
            rp_int64 := <int64>16132,
            rp_int64_type := <v6::codegen::Int64Type>16132,
        }),

        rl_float32 := (insert v6::codegen::Float32PropertiesType {
            rp_float32 := <float32>16.5,
            rp_float32_type := <v6::codegen::Float32Type>16.5,
        }),

        rl_float64 := (insert v6::codegen::Float64PropertiesType {
            rp_float64 := <float64>16.5,
            rp_float64_type := <v6::codegen::Float64Type>16.5,
        }),

        rl_decimal := (insert v6::codegen::DecimalPropertiesType {
            rp_decimal := <decimal>16.132,
            rp_decimal_type := <v6::codegen::DecimalType>16.132,
        }),

        rl_bigint := (insert v6::codegen::BigintPropertiesType {
            rp_bigint := <bigint>16132,
            rp_bigint_type := <v6::codegen::BigintType>16132,
        }),
    }),

    rl_json := (insert v6::codegen::JsonPropertiesType {
        rp_json := <json>'{"key": "value"}',
        rp_json_type := <v6::codegen::JsonType>'{"key": "value"}',
    }),

    rl_uuid := (insert v6::codegen::UuidPropertiesType {
        rp_uuid := <uuid>'00000000-0000-0000-0000-000000000000',
        rp_uuid_type := <v6::codegen::UuidType>'00000000-0000-0000-0000-000000000000',
    }),

    rl_date_and_time := (insert v6::codegen::DateAndTimePropertiesType {
        rl_datetime := (insert v6::codegen::DatetimePropertiesType {
            rp_datetime := <datetime>'2000-02-16T16:13:02+00',
            rp_datetime_type := <v6::codegen::DatetimeType>'2000-02-16T16:13:02+00',
        }),

        rl_duration := (insert v6::codegen::DurationPropertiesType {
            rp_duration := <duration>"45.6 seconds",
            rp_duration_type := <v6::codegen::DurationType>"45.6 seconds",
        }),

        rl_cal := (insert v6::codegen::CalPropertiesType {
            rl_cal_local_datetime := (insert v6::codegen::CalLocalDatetimePropertiesType {
                rp_cal_local_datetime := <cal::local_datetime>'2000-02-16T16:13:02',
                rp_cal_local_datetime_type := <v6::codegen::CalLocalDatetimeType>'2000-02-16T16:13:02',
            }),

            rl_cal_local_date := (insert v6::codegen::CalLocalDatePropertiesType {
                rp_cal_local_date := <cal::local_date>'2000-02-16',
                rp_cal_local_date_type := <v6::codegen::CalLocalDateType>'2000-02-16',
            }),

            rl_cal_local_time := (insert v6::codegen::CalLocalTimePropertiesType {
                rp_cal_local_time := <cal::local_time>'16:13:02',
                rp_cal_local_time_type := <v6::codegen::CalLocalTimeType>'16:13:02',
            }),

            rl_cal_relative_duration := (insert v6::codegen::CalRelativeDurationPropertiesType {
                rp_cal_relative_duration := <cal::relative_duration>'1 year',
                rp_cal_relative_duration_type := <v6::codegen::CalRelativeDurationType>'1 year',
            }),

            rl_cal_date_duration := (insert v6::codegen::CalDateDurationPropertiesType {
                rp_cal_date_duration := <cal::date_duration>"45 days",
                rp_cal_date_duration_type := <v6::codegen::CalDateDurationType>"45 days",
            }),
        }),
    }),

    rl_cfg := (insert v6::codegen::CfgPropertiesType {
        rl_cfg_memory := (insert v6::codegen::CfgMemoryPropertiesType {
            rp_cfg_memory :=  <cfg::memory>"1KiB",
            rp_cfg_memory_type :=  <v6::codegen::CfgMemoryType>"1KiB",
        }),
    }),

    rl_sequence := (insert v6::codegen::SequencePropertiesType {
        rp_sequence_type := <v6::codegen::SequenceType>1,
    }),

    rl_enum := (insert v6::codegen::EnumPropertiesType {
        rp_enum_type := <v6::codegen::EnumType>"A",
    }),

    rl_vector := (insert v6::codegen::VectorPropertiesType {
        rp_vector_type := <v6::codegen::VectorType>[1.5, 2.0, 4.5],
    }),

    rl_array := (insert v6::codegen::ArrayPropertiesType {
        rp_array := <array<str>>["hello", "world"],
    }),

    rl_tuple := (insert v6::codegen::TuplePropertiesType {
        rl_unnamed_tuple := (insert v6::codegen::UnnamedTuplePropertiesType {
            rp_unnamed_tuple := ("hello", true, ("world", false, v6::codegen::EnumType.B)),
        }),

        rl_named_tuple := (insert v6::codegen::NamedTuplePropertiesType {
            rp_named_tuple := (a := "hello", b := true, c := (a := "world", b := false, c := v6::codegen::EnumType.B)),
        }),
    }),

    rl_range := (insert v6::codegen::RangePropertiesType {
        rl_range_int32 := (insert v6::codegen::RangeInt32PropertiesType {
            rl_single_range_int32 := (insert v6::codegen::SingleRangeInt32PropertiesType {
                rp_range_int32 := range(1, 10),
            }),

            rl_multi_range_int32 := (insert v6::codegen::MultiRangeInt32PropertiesType {
                rp_multirange_int32 := multirange([range(1, 10)]),
            }),
        }),

        rl_range_int64 := (insert v6::codegen::RangeInt64PropertiesType {
            rl_single_range_int64 := (insert v6::codegen::SingleRangeInt64PropertiesType {
                rp_range_int64 := range(1, 10),
            }),

            rl_multi_range_int64 := (insert v6::codegen::MultiRangeInt64PropertiesType {
                rp_multirange_int64 := multirange([range(1, 10)]),
            }),
        }),

        rl_range_float32 := (insert v6::codegen::RangeFloat32PropertiesType {
            rl_single_range_float32 := (insert v6::codegen::SingleRangeFloat32PropertiesType {
                rp_range_float32 := range(1, 10),
            }),

            rl_multi_range_float32 := (insert v6::codegen::MultiRangeFloat32PropertiesType {
                rp_multirange_float32 := multirange([range(1, 10)]),
            }),
        }),

        rl_range_float64 := (insert v6::codegen::RangeFloat64PropertiesType {
            rl_single_range_float64 := (insert v6::codegen::SingleRangeFloat64PropertiesType {
                rp_range_float64 := range(1, 10),
            }),

            rl_multi_range_float64 := (insert v6::codegen::MultiRangeFloat64PropertiesType {
                rp_multirange_float64 := multirange([range(1, 10)]),
            }),
        }),

        rl_range_decimal := (insert v6::codegen::RangeDecimalPropertiesType {
            rl_single_range_decimal := (insert v6::codegen::SingleRangeDecimalPropertiesType {
                rp_range_decimal := range(1, 10),
            }),

            rl_multi_range_decimal := (insert v6::codegen::MultiRangeDecimalPropertiesType {
                rp_multirange_decimal := multirange([range(1, 10)]),
            }),
        }),

        rl_range_datetime := (insert v6::codegen::RangeDatetimePropertiesType {
            rl_single_range_datetime := (insert v6::codegen::SingleRangeDatetimePropertiesType {
                rp_range_datetime := range(<datetime>'2022-07-01T00:00:00+00', <datetime>'2022-12-01T00:00:00+00'),
            }),

            rl_multi_range_datetime := (insert v6::codegen::MultiRangeDatetimePropertiesType {
                rp_multirange_datetime := multirange([range(<datetime>'2022-07-01T00:00:00+00', <datetime>'2022-12-01T00:00:00+00')]),
            }),
        }),

        rl_range_cal_local_datetime := (insert v6::codegen::RangeCalLocalDatetimePropertiesType {
            rl_single_range_cal_local_datetime := (insert v6::codegen::SingleRangeCalLocalDatetimePropertiesType {
                rp_range_cal_local_datetime := range(<cal::local_datetime>'2022-07-01T00:00:00', <cal::local_datetime>'2022-12-01T00:00:00'),
            }),

            rl_multi_range_cal_local_datetime := (insert v6::codegen::MultiRangeCalLocalDatetimePropertiesType {
                rp_multirange_cal_local_datetime := multirange([range(<cal::local_datetime>'2022-07-01T00:00:00', <cal::local_datetime>'2022-12-01T00:00:00')]),
            }),
        }),

        rl_range_cal_local_date := (insert v6::codegen::RangeCalLocalDatePropertiesType {
            rl_single_range_cal_local_date := (insert v6::codegen::SingleRangeCalLocalDatePropertiesType {
                rp_range_cal_local_date := range(<cal::local_date>'2022-07-01', <cal::local_date>'2022-12-01'),
            }),

            rl_multi_range_cal_local_date := (insert v6::codegen::MultiRangeCalLocalDatePropertiesType {
                rp_multirange_cal_local_date := multirange([range(<cal::local_date>'2022-07-01', <cal::local_date>'2022-12-01')]),
            }),
        }),
    }),
}).id;
