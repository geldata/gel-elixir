defmodule EdgeQLCodegenTestCaseFormatter do
  @behaviour Mix.Tasks.Format

  @impl Mix.Tasks.Format
  def features(_opts) do
    [extensions: [".test"]]
  end

  @impl Mix.Tasks.Format
  def format(contents, opts) do
    formatted =
      contents
      |> Code.format_string!(opts)
      |> IO.iodata_to_binary()
      |> String.trim()

    "#{formatted}\n"
  end
end

[
  plugins: [EdgeQLCodegenTestCaseFormatter],
  inputs: [
    "{mix,.formatter,.credo}.exs",
    "{config,lib,test}/**/*.{ex,exs}",
    "test/**/*.edgeql.ex.test"
  ]
]
