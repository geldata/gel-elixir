defmodule Gel.EdgeQL.Generator.Scalar do
  @moduledoc false

  defstruct [
    :module,
    :typespec
  ]

  @type t() :: %__MODULE__{
          module: String.t(),
          typespec: String.t()
        }
end

defimpl Gel.EdgeQL.Generator.Render, for: Gel.EdgeQL.Generator.Scalar do
  alias Gel.EdgeQL.Generator.{
    Scalar,
    Render
  }

  require EEx

  @typespec_tpl Path.join([
                  :code.priv_dir(:gel),
                  "codegen",
                  "templates",
                  "typespecs",
                  "_scalar.eex"
                ])
  EEx.function_from_file(:defp, :render_typespec_tpl, @typespec_tpl, [:assigns], trim: true)

  @impl Render
  def render(%Scalar{} = scalar, :typespec, opts \\ []) do
    Render.Utils.render_to_line(&render_typespec_tpl/1, scalar: scalar, opts: opts)
  end
end

defimpl Gel.EdgeQL.Generator.Handler, for: Gel.EdgeQL.Generator.Scalar do
  alias Gel.EdgeQL.Generator.{
    Scalar,
    Handler
  }

  @impl Handler
  def variable?(%Scalar{}) do
    false
  end

  @impl Handler
  def handle(%Scalar{}, _opts \\ []) do
    ""
  end

  @impl Handler
  def handle?(%Scalar{}) do
    false
  end
end
