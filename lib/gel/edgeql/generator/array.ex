defmodule Gel.EdgeQL.Generator.Array do
  @moduledoc false

  alias Gel.EdgeQL.Generator.{
    Enum,
    NamedTuple,
    Range,
    Scalar,
    Tuple
  }

  defstruct [
    :type
  ]

  @type t() :: %__MODULE__{
          type:
            Enum.t()
            | NamedTuple.t()
            | Range.t()
            | Scalar.t()
            | Tuple.t()
        }
end

defimpl Gel.EdgeQL.Generator.Render, for: Gel.EdgeQL.Generator.Array do
  alias Gel.EdgeQL.Generator.{
    Array,
    Render
  }

  require EEx

  @typespec_tpl Path.join([
                  :code.priv_dir(:gel),
                  "codegen",
                  "templates",
                  "typespecs",
                  "_array.eex"
                ])
  EEx.function_from_file(:defp, :render_typespec_tpl, @typespec_tpl, [:assigns])

  @impl Render
  def render(%Array{} = array, :typespec, opts \\ []) do
    Render.Utils.render_to_line(&render_typespec_tpl/1, array: array, opts: opts)
  end
end

defimpl Gel.EdgeQL.Generator.Handler, for: Gel.EdgeQL.Generator.Array do
  alias Gel.EdgeQL.Generator.{
    Array,
    Handler
  }

  require EEx

  @handler_tpl Path.join([:code.priv_dir(:gel), "codegen", "templates", "handlers", "_array.eex"])
  EEx.function_from_file(:defp, :render_handler_tpl, @handler_tpl, [:assigns])

  @impl Handler
  def variable?(%Array{} = array) do
    Handler.variable?(array.type)
  end

  @impl Handler
  def handle(%Array{} = array, opts \\ []) do
    render_handler_tpl(array: array, opts: opts)
  end

  @impl Handler
  def handle?(%Array{} = array) do
    Handler.handle?(array.type)
  end
end
