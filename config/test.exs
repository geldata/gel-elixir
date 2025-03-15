import Config

config :gel,
  rended_colored_errors: false,
  generation: [
    queries_path: "test/support/codegen/edgeql/",
    output_path: "test/codegen/queries/",
    module_prefix: Tests.Codegen.Queries
  ]

config :gel,
  __file_module__: Tests.Support.Mocks.FileMock,
  __path_module__: Tests.Support.Mocks.PathMock,
  __system_module__: Tests.Support.Mocks.SystemMock
