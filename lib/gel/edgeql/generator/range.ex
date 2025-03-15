defmodule Gel.EdgeQL.Generator.Range do
  @moduledoc false

  alias Gel.EdgeQL.Generator.Scalar

  defstruct [
    :type,
    is_multirange: false
  ]

  @type t() :: %__MODULE__{
          type: Scalar.t(),
          is_multirange: boolean()
        }
end

defimpl Gel.EdgeQL.Generator.Render, for: Gel.EdgeQL.Generator.Range do
  alias Gel.EdgeQL.Generator.{
    Range,
    Render
  }

  require EEx

  @typespec_tpl Path.join([
                  :code.priv_dir(:gel),
                  "codegen",
                  "templates",
                  "typespecs",
                  "_range.eex"
                ])
  EEx.function_from_file(:defp, :render_typespec_tpl, @typespec_tpl, [:assigns], trim: true)

  @impl Render
  def render(%Range{} = range, :typespec, opts \\ []) do
    Render.Utils.render_to_line(&render_typespec_tpl/1, range: range, opts: opts)
  end
end

defimpl Gel.EdgeQL.Generator.Handler, for: Gel.EdgeQL.Generator.Range do
  alias Gel.EdgeQL.Generator.{
    Range,
    Handler
  }

  @impl Handler
  def variable?(%Range{}) do
    false
  end

  @impl Handler
  def handle(%Range{}, _opts \\ []) do
    ""
  end

  @impl Handler
  def handle?(%Range{}) do
    false
  end
end
