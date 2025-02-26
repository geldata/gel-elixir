# Datatypes

Gel client for Elixir automatically converts Gel types to the corresponding Elixir types and vice versa.

The table below shows the correspondence between Gel and Elixir types.

| Gel                                      | Elixir                                | Example                                           |
| ---------------------------------------- | ------------------------------------- | ------------------------------------------------- |
| `std::str`                               | `t:String.t/0`                        | `"Hello Gel!"`                                    |
| `std::int16`, `std::int32`, `std::int64` | `t:integer/0`                         | `16`                                              |
| `std::float32`, `std::float64`           | `t:float/0`                           | `3.1415`                                          |
| `std::bigint`, `std::decimal`            | `t:Decimal.t/0`                       | `#Decimal<1.23>`                                  |
| `std::bool`                              | `t:boolean/0`                         | `true`, `false`                                   |
| `std::datetime`                          | `t:DateTime.t/0`                      | `~U[2018-05-07 15:01:22Z]`                        |
| `std::duration`                          | `t:integer/0` or `Timex.Duration`     | `-420000000`, `#<Duration(PT7M)>`                 |
| `cal::local_datetime`                    | `t:NaiveDateTime.t/0`                 | `~N[2018-05-07 15:01:22]`                         |
| `cal::local_date`                        | `t:Date.t/0`                          | `~D[2018-05-07]`                                  |
| `cal::local_time`                        | `t:Time.t/0`                          | `~T[15:01:22]`                                    |
| `cal::relative_duration`                 | `t:Gel.RelativeDuration.t/0`          | `#Gel.RelativeDuration<"PT45.6S">`                |
| `cal::date_duration`                     | `t:Gel.DateDuration.t/0`              | `#Gel.DateDuration<"P4Y12D">`                     |
| `std::json`                              | `t:any/0`                             | `42`                                              |
| `std::uuid`                              | `t:String.t/0`                        | `"0eba1636-846e-11ec-845e-276b0105b857"`          |
| `std::bytes`                             | `t:binary/0`                          | `<<1, 2, 3>>`, `"some bytes"`                     |
| `cfg::memory`                            | `t:Gel.ConfigMemory.t/0`              | `#Gel.ConfigMemory<"5KiB">`                       |
| `ext::pgvector::vector`                  | `t:list/0`                            | `[1.5, 2.0, 4.5]`                                 |
| `anyenum`                                | `t:String.t/0`                        | `"green"`                                         |
| `array<anytype>`                         | `t:list/0`                            | `[1, 2, 3]`                                       |
| `anytuple`                               | `t:tuple/0` or `t:Gel.NamedTuple.t/0` | `{1, 2, 3}`, `#Gel.NamedTuple<a: 1, b: 2, c: 3>}` |
| `range`                                  | `t:Gel.Range.t/0`                     | `#Gel.Range<[1.1, 3.3)>`                          |
| `object`                                 | `t:Gel.Object.t/0`                    | `#Gel.Object<name := "username">}`                |
| `set`                                    | `t:Gel.Set.t/0`                       | `#Gel.Set<{1, 2, 3}>}`                            |
