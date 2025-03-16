defmodule Gel.EdgeQL.Generator.Tuple do
  @moduledoc false

  alias Gel.EdgeQL.Generator.{
    Array,
    Enum,
    NamedTuple,
    Object,
    Range,
    Scalar,
    Set,
    Tuple
  }

  defstruct [
    :elements
  ]

  @type t() :: %__MODULE__{
          elements:
            list(
              Array.t()
              | Enum.t()
              | NamedTuple.t()
              | Range.t()
              | Scalar.t()
              | Tuple.t()
              | Set.t()
              | Object.t()
            )
        }
end

defimpl Gel.EdgeQL.Generator.Render, for: Gel.EdgeQL.Generator.Tuple do
  alias Gel.EdgeQL.Generator.{
    Tuple,
    Render
  }

  require EEx

  @typespec_tpl Path.join([
                  :code.priv_dir(:gel),
                  "codegen",
                  "templates",
                  "typespecs",
                  "_tuple.eex"
                ])
  EEx.function_from_file(:defp, :render_typespec_tpl, @typespec_tpl, [:assigns])

  @impl Render
  def render(%Tuple{} = tuple, :typespec, opts \\ []) do
    Render.Utils.render_with_trim(&render_typespec_tpl/1, tuple: tuple, opts: opts)
  end
end

defimpl Gel.EdgeQL.Generator.Handler, for: Gel.EdgeQL.Generator.Tuple do
  alias Gel.EdgeQL.Generator.{
    Tuple,
    Render,
    Handler
  }

  require EEx

  @handler_tpl Path.join([:code.priv_dir(:gel), "codegen", "templates", "handlers", "_tuple.eex"])
  EEx.function_from_file(:defp, :render_handler_tpl, @handler_tpl, [:assigns])

  @impl Handler
  def variable?(%Tuple{} = tuple) do
    Enum.any?(tuple.elements, &Handler.variable?/1)
  end

  @impl Handler
  def handle(%Tuple{} = tuple, opts \\ []) do
    Render.Utils.render_with_trim(&render_handler_tpl/1, tuple: tuple, opts: opts)
  end

  @impl Handler
  def handle?(%Tuple{} = tuple) do
    Enum.any?(tuple.elements, &Handler.handle?/1)
  end
end
