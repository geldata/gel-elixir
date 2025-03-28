defmodule Gel.EdgeQL.Generator.NamedTuple do
  @moduledoc false

  defmodule Element do
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
      :name,
      :type
    ]

    @type t() :: %__MODULE__{
            name: String.t(),
            type:
              Array.t()
              | Enum.t()
              | NamedTuple.t()
              | Range.t()
              | Scalar.t()
              | Tuple.t()
              | Set.t()
              | Object.t()
          }
  end

  defstruct [
    :elements
  ]

  @type t() :: %__MODULE__{
          elements: list(Element.t())
        }
end

defimpl Gel.EdgeQL.Generator.Render, for: Gel.EdgeQL.Generator.NamedTuple do
  alias Gel.EdgeQL.Generator.{
    NamedTuple,
    Render
  }

  require EEx

  @typespec_tpl Path.join([
                  :code.priv_dir(:gel),
                  "codegen",
                  "templates",
                  "typespecs",
                  "_named_tuple.eex"
                ])
  EEx.function_from_file(:defp, :render_typespec_tpl, @typespec_tpl, [:assigns])

  @impl Render
  def render(%NamedTuple{} = named_tuple, :typespec, opts \\ []) do
    Render.Utils.render_to_line(&render_typespec_tpl/1, named_tuple: named_tuple, opts: opts)
  end
end

defimpl Gel.EdgeQL.Generator.Render, for: Gel.EdgeQL.Generator.NamedTuple.Element do
  alias Gel.EdgeQL.Generator.{
    NamedTuple,
    Render
  }

  @impl Render
  def render(%NamedTuple.Element{} = element, :typespec, opts \\ []) do
    Gel.EdgeQL.Generator.Render.render(element.type, :typespec, opts)
  end
end

defimpl Gel.EdgeQL.Generator.Handler, for: Gel.EdgeQL.Generator.NamedTuple do
  alias Gel.EdgeQL.Generator.{
    NamedTuple,
    Render,
    Handler
  }

  require EEx

  @handler_tpl Path.join([
                 :code.priv_dir(:gel),
                 "codegen",
                 "templates",
                 "handlers",
                 "_named_tuple.eex"
               ])
  EEx.function_from_file(:defp, :render_handler_tpl, @handler_tpl, [:assigns])

  @impl Handler
  def variable?(%NamedTuple{}) do
    true
  end

  @impl Handler
  def handle(%NamedTuple{} = named_tuple, opts \\ []) do
    Render.Utils.render_with_trim(&render_handler_tpl/1, named_tuple: named_tuple, opts: opts)
  end

  @impl Handler
  def handle?(%NamedTuple{}) do
    true
  end
end
