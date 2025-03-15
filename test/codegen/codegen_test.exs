defmodule Tests.CodegenTest do
  use Tests.Support.GelCase

  skip_before(version: 6, scope: :module)

  @aggregate_query File.read!(Path.join(__DIR__, "insert_aggregate.edgeql"))
  @queries_path Application.compile_env!(:gel, :generation)[:queries_path]

  queries =
    [@queries_path, "**", "*.edgeql"]
    |> Path.join()
    |> Path.wildcard()

  setup :gel_client

  for query_path <- queries do
    describe "codegen for #{query_path}" do
      setup do
        query_file = unquote(query_path)

        {:ok, %{^query_file => elixir_file}} =
          Gel.EdgeQL.Generator.generate(silent: true, query_file: query_file)

        Code.put_compiler_option(:ignore_module_conflict, true)

        on_exit(fn ->
          Code.put_compiler_option(:ignore_module_conflict, false)
        end)

        assert [{module, _binary} | _rest] =
                 elixir_file
                 |> Code.compile_file()
                 |> Enum.reverse()

        %{
          query_file: query_file,
          elixir_file: elixir_file,
          module: module,
          insert_aggregate_query: @aggregate_query
        }
      end

      test "equals #{query_path}.ex.assert", context do
        prepared_module =
          "#{context.query_file}.ex.assert"
          |> File.read!()
          |> Code.format_string!()
          |> IO.iodata_to_binary()

        generated_module =
          context.elixir_file
          |> File.read!()
          |> Code.format_string!()
          |> IO.iodata_to_binary()

        assert String.trim(prepared_module) == String.trim(generated_module)
      end

      quoted_query_test =
        "#{query_path}.ex.test"
        |> File.read!()
        |> Code.string_to_quoted!()

      test "results to #{query_path}.ex.test", context do
        assert {:error, :test} =
                 Gel.transaction(context.client, fn client ->
                   context = %{context | client: client}
                   unquote(quoted_query_test)
                   Gel.rollback(client, reason: :test)
                 end)
      end
    end
  end
end
