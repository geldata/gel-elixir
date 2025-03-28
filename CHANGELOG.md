# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.10.0] - Unreleased

[Compare with 0.9.0](https://github.com/geldata/gel-elixir/compare/v0.9.0...HEAD)

### Added

- generation of Elixir modules from EdgeQL queries via `mix gel.generate` task.
- abitility to pass atoms as valid arguments for enums.

### Changed

- `Gel.NamedTuple.to_map/2` to include indexes as keys into result map.

### Fixed

- behavior where an empty link returned an empty instance of `t:Gel.Set.t/0` instead of `nil`.

## [0.9.0] - 2025-03-07

[Compare with 0.8.0](https://github.com/geldata/gel-elixir/compare/v0.8.0...v0.9.0)

> #### NOTE {: .warning}
>
> This release renames the library from `edgedb` to `gel` to reflect the product's name change.
> This version does not bring any change in functionality, but replaces the module names from
> `EdgeDB` to `Gel`, and changes configuration keys from `:edgedb` to `:gel`.

### Changed

- naming of the library and modules from `EdgeDB` to `Gel`.

## [0.8.0] - 2025-02-26

[Compare with 0.7.0](https://github.com/geldata/gel-elixir/compare/v0.7.0...v0.8.0)

### Added

- support for Gel connection options.
- support for `Elixir v1.17`.
- support for `Elixir v1.18`.

## [0.7.0] - 2024-05-05

[Compare with 0.6.1](https://github.com/geldata/gel-elixir/compare/v0.6.1...v0.7.0)

### Added

- rendering hints for query errors from EdgeDB.
- support for EdgeDB binary protocol `2.0`.
- new [`EdgeDB.MultiRange`](`Gel.MultiRange`) type to represent multiranges from `EdgeDB 4.0`.
- [`EdgeDB.Object.id/1`](`Gel.Object.id/1`) to fetch ID from an [`EdgeDB.Object`](`Gel.Object`) if it was returned from the query.
- [`EdgeDB.ConfigMemory.new/1`](`Gel.ConfigMemory.new/1`) to create a new instance of [`EdgeDB.ConfigMemory.t/0`](`t:Gel.ConfigMemory.t/0`).
- support for `Elixir v1.16`.
- support for branches.
- support for server name (SNI) passing to TLS connection.

### Changed

- [`EdgeDB.Object.t/0`](`t:Gel.Object.t/0`) to be `opaque`.
- the behavior of injecting an implicit `:id` field into objects so that this no longer happens.

### Fixed
- client state handling in [`EdgeDB.with_config/2`](`Gel.with_config/2`)/[`EdgeDB.without_config/2`](`Gel.without_config/2`),
    [`EdgeDB.with_globals/2`](`Gel.with_globals/2`)/[`EdgeDB.without_globals/2`](`Gel.without_globals/2`) and
    [`EdgeDB.with_module_aliases/2`](`Gel.with_module_aliases/2`)/[`EdgeDB.without_module_aliases/2`](`Gel.without_module_aliases/2`).

## [0.6.1] - 2023-07-07

[Compare with 0.6.0](https://github.com/geldata/gel-elixir/compare/v0.6.0...v0.6.1)

### Added

- support for `Elixir v1.15` and `Erlang/OTP 26`.

### Fixed

- encoding of [`EdgeDB.Range.t/0`](`t:Gel.Range.t/0`) values.
- constructing [`EdgeDB.Range.t/0`](`t:Gel.Range.t/0`) from [`EdgeDB.Range.new/3`](`Gel.Range.new/3`) with `nil` as values.
- examples in the documentation and the `Inspect` implementation of
    [`EdgeDB.DateDuration.t/0`](`t:Gel.DateDuration.t/0`) and [`EdgeDB.Range.t/0`](`t:Gel.Range.t/0`).

## [0.6.0] - 2023-06-22

[Compare with 0.5.1](https://github.com/geldata/gel-elixir/compare/v0.5.1...v0.6.0)

### Added

- support for `cal::date_duration` EdgeDB type via [`EdgeDB.DateDuration`](`Gel.DateDuration`) structure.
- support for EdgeDB Cloud.
- support for tuples and named tuples as query arguments.
- support for `EdgeDB 3.0`.
- support for `ext::pgvector::vector` type.

### Changed

- implementation of `Enumerable` protocol for [`EdgeDB.Set`](`Gel.Set`).
- [`EdgeDB.State`](`Gel.State`) to [`EdgeDB.Client.State`](`Gel.Client.State`), [`EdgeDB.with_state/2`](`Gel.with_state/2`) to
    [`EdgeDB.with_client_state/2`](`Gel.with_client_state/2`), `:state` option to `:client_state`.
- license from `MIT` to `Apache 2.0`.

### Fixed

- crash after updating `db_connection` to `2.5`.
- decoding a single propery for [`EdgeDB.Object`](`Gel.Object`) that equals to an empty set.
- not catching an [`EdgeDB.Error`](`Gel.Error`) exception during parameters encoding,
    which caused throwing an exception for non-`!` functions.
- silent error for calling [`EdgeDB`](`Gel`) API with wrong module names.

### Removed

- `EdgeDB.subtransaction/2`, `EdgeDB.subtransaction!/2` functions and other mentions of
    subtransactions support in the client.
- support for custom pool configuration.
- `:raw` option from `EdgeDB.query*` functions as well as access to `EdgeDB.Query`
    and `EdgeDB.Result`.
- API for constructing an [`EdgeDB.Error`](`Gel.Error`).

## [0.5.1] - 2022-08-25

[Compare with 0.5.0](https://github.com/geldata/gel-elixir/compare/v0.5.0...v0.5.1)

### Removed

- unintentional ping log for the connection.

## [0.5.0] - 2022-08-20

[Compare with 0.4.0](https://github.com/geldata/gel-elixir/compare/v0.4.0...v0.5.0)

### Added

- [`EdgeDB.Client`](`Gel.Client`) module that is acceptable by all [`EdgeDB`](`Gel`) API.
- `:max_concurrency` option to start pool to control max connections count in `EdgeDB.Pool`.

### Changed

- default pool from `DBConnection.Pool` to `EdgeDB.Pool`.
- `EdgeDB.Pool` to be "real" lazy and dynamic: all idle connections that EdgeDB wants to drop
    will be disconnected from the pool, new connections will be created only on user queries
    depending on EdgeDB concurrency suggest as soft limit and `:max_concurrency` option as hard limit
    of connections count.
- first parameter accepted by callbacks in [`EdgeDB.transaction/3`](`Gel.transaction/3`), `EdgeDB.subtransaction/2`
    and `EdgeDB.subtransaction!/2` from `t:DBConnection.t/0` to [`EdgeDB.Client.t/0`](`t:Gel.Client.t/0`).
- `EdgeDB.connection/0` to [`EdgeDB.client/0`](`t:Gel.client/0`).
- `EdgeDB.edgedb_transaction_option/0` to [`EdgeDB.Client.transaction_option/0`](`t:Gel.Client.transaction_option/0`).
- `EdgeDB.retry_option/0` to [`EdgeDB.Client.retry_option/0`](`t:Gel.Client.retry_option/0`).
- `EdgeDB.retry_rule/0` to [`EdgeDB.Client.retry_rule/0`](`t:Gel.Client.retry_rule/0`).

### Fixed

- concurrent transactions when client was unintentionally marked as borrowed for transaction instead of connection.

### Removed

- `EdgeDB.WrappedConnection` module in favor of [`EdgeDB.Client`](`Gel.Client`).

## [0.4.0] - 2022-08-04

[Compare with 0.3.0](https://github.com/geldata/gel-elixir/compare/v0.3.0...v0.4.0)

### Added

- support for `EdgeDB 2.0` with new binary protocol.
- support for EdgeQL state via [`EdgeDB.State`](`Gel.State`).
- new [`EdgeDB.Range`](`Gel.Range`) type to represent ranges from `EdgeDB 2.0`.
- support for multiple EdgeQL statements execution via [`EdgeDB.execute/4`](`Gel.execute/4`) and [`EdgeDB.execute!/4`](`Gel.execute!/4`).

### Changed

- `io_format` option to `output_format`.

### Fixed

- the ability to pass maps or keyword lists in a query that requires positional arguments.

## [0.3.0] - 2022-05-29

[Compare with 0.2.1](https://github.com/geldata/gel-elixir/compare/v0.2.1...v0.3.0)

### Added

- maps as a valid type for query arguments.
- [`EdgeDB.Object.to_map/1`](`Gel.Object.to_map/1`) and [`EdgeDB.NamedTuple.to_map/1`](`Gel.NamedTuple.to_map/1`) functions.
- optional support for `std::datetime` EdgeDB type via `Timex.Duration` structure.
- custom modules for each EdgeDB exception with the `new/2` function, that will return the [`EdgeDB.Error`](`Gel.Error`) exception.
- documentation for [`EdgeDB.Error`](`Gel.Error`) functions that create new exceptions.

### Removed

- legacy arguments encoding.

### Changed

- `EdgeQL` queries to be lowercase.
- [`EdgeDB.Error.inheritor?/2`](`Gel.Error.inheritor?/2`) to work with generated module names for EdgeDB exceptions instead of atoms.

## [0.2.1] - 2022-05-19

[Compare with 0.2.0](https://github.com/geldata/gel-elixir/compare/v0.2.0...v0.2.1)

### Removed

- mention of `:repeatable_read` option for transaction isolation mode from `EdgeDB.edgedb_transaction_option/0`.

### Fixed

- codec name returned by codec for `std::str` from `std::uuid` to `str::str`.
- documentation for the custom codec example, which did not have a [`EdgeDB.Protocol.Codec.decode/3`](`Gel.Protocol.Codec.decode/3`) implementation and used the wrong protocol.

## [0.2.0] - 2022-05-03

[Compare with 0.1.0](https://github.com/geldata/gel-elixir/compare/v0.1.0...v0.2.0)

### Added

- [`EdgeDB.Object.fields/2`](`Gel.Object.fields/2`), [`EdgeDB.Object.properties/2`](`Gel.Object.properties/2`),
    [`EdgeDB.Object.links/1`](`Gel.Object.links/1`) and [`EdgeDB.Object.link_properties/1`](`Gel.Object.link_properties/1`)
    functions to inspect the fields of the object.
- [`EdgeDB.Error.inheritor?/2`](`Gel.Error.inheritor?/2`) function to check if the exception is an inheritor of another EdgeDB error.
- [`EdgeDB.Sandbox`](`Gel.Sandbox`) module for use in tests involving database modifications.
- `EdgeDB.Pool` to support dynamic resizing of the connection pool via messages from EdgeDB server.

### Fixed

- creation of [`EdgeDB.Object`](`Gel.Object`) properties equal to an empty [`EdgeDB.Set`](`Gel.Set`).
- access to TLS certificate from connection options.
- isolation configuration by dropping `REPEATABLE READ` mode, because only `SERIALIZABLE` is supported by `EdgeDB 1.0` (`REPEATABLE READ` was dropped in `EdgeDB 1.3`).
- preserving the order of the values returned when working with [`EdgeDB.NamedTuple`](`Gel.NamedTuple`)
    ([`EdgeDB.NamedTuple.to_tuple/1`](`Gel.NamedTuple.to_tuple/1`), [`EdgeDB.NamedTuple.keys/1`](`Gel.NamedTuple.keys/1`)),
    including `Enumerable` protocol implementation.

### Changed

- parsing of binary data from EdgeDB by completely reworking the protocol implementation.
- internal implementation of the `Access` behaviour for [`EdgeDB.Object`](`Gel.Object`) to improve fields access performance.

## [0.1.0] - 2022-02-10

[Compare with first commit](https://github.com/geldata/gel-elixir/compare/a9c18f910e36e728eb8d59e6e8e41721474f201c...v0.1.0)

### Added

- First release.
