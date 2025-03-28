defmodule Gel.Object do
  @moduledoc """
  An immutable representation of an object instance returned from a query.

  `Gel.Object` implements `Access` behavior to access properties by key.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> object =
  ...(2)>  Gel.query_required_single!(client, "\"\"
  ...(2)>   select schema::ObjectType{
  ...(2)>     name
  ...(2)>   }
  ...(2)>   filter .name = 'std::Object'
  ...(2)>   limit 1
  ...(2)>  \"\"")
  #Gel.Object<name := "std::Object">
  iex(3)> object[:name]
  "std::Object"
  ```

  ### Links and links properties

  In Gel, objects can have links to other objects or a set of objects.
    You can use the same syntax to access links values as for object properties.
    Links can also have their own properties (denoted as `@<link_prop_name>` in EdgeQL syntax).
    You can use the same property name as in the query to access them from the links.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> object =
  ...(2)>  Gel.query_required_single!(client, "\"\"
  ...(2)>   select schema::Property {
  ...(2)>       name,
  ...(2)>       annotations: {
  ...(2)>         name,
  ...(2)>         @value
  ...(2)>       }
  ...(2)>   }
  ...(2)>   filter .name = 'listen_port' and .source.name = 'cfg::Config'
  ...(2)>   limit 1
  ...(2)>  \"\"")
  #Gel.Object<name := "listen_port", annotations := #Gel.Set<{#Gel.Object<name := "cfg::system", @value := "true">}>>
  iex(3)> annotations = object[:annotations]
  #Gel.Set<{#Gel.Object<name := "cfg::system", @value := "true">}>
  iex(4)> link = Enum.at(annotations, 0)
  #Gel.Object<name := "cfg::system", @value := "true">
  iex(5)> link["@value"]
  "true"
  ```
  """

  @behaviour Access

  defstruct id: nil,
            __tid__: nil,
            fields: [],
            order: []

  @typedoc """
  UUID value.
  """
  @type uuid() :: String.t()

  @typedoc since: "0.2.0"
  @typedoc """
  Options for `Gel.Object.fields/2`

  Supported options:

    * `:properties` - flag to include object properties in returning list. The default is `true`.
    * `:links` - flag to include object links in returning list. The default is `true`.
    * `:link_properies` - flag to include object link properties in returning list. The default is `true`.
    * `:id` - flag to include implicit `:id` in returning list. The default is `false`.
    * `:implicit` - flag to include implicit fields (like `:id` or `:__tid__`) in returning list.
      The default is `false`.
  """
  @type fields_option() ::
          {:properties, boolean()}
          | {:links, boolean()}
          | {:link_properties, boolean()}
          | {:id, boolean()}
          | {:implicit, boolean()}

  @typedoc since: "0.2.0"
  @typedoc """
  Options for `Gel.Object.properties/2`

  Supported options:

    * `:id` - flag to include implicit `:id` in returning list. The default is `false`.
    * `:implicit` - flag to include implicit properties (like `:id` or `:__tid__`) in returning list.
      The default is `false`.
  """
  @type properties_option() ::
          {:id, boolean()}
          | {:implicit, boolean()}

  @typedoc since: "0.7.0"
  @typedoc """
  An immutable representation of an object instance returned from a query.
  """
  @opaque t() :: %__MODULE__{
            id: uuid() | nil,
            __tid__: uuid() | nil,
            fields: %{String.t() => Gel.Object.Field.t()},
            order: list(String.t())
          }

  defmodule Field do
    @moduledoc false

    defstruct [
      :name,
      :value,
      :is_link,
      :is_link_property,
      :is_implicit
    ]

    @type t() :: %__MODULE__{
            name: String.t(),
            value: any(),
            is_link: boolean(),
            is_link_property: boolean(),
            is_implicit: boolean()
          }
  end

  @doc since: "0.7.0"
  @doc """
  Get an object ID if it was returned from the query.
  """
  @spec id(t()) :: uuid() | nil
  def id(%__MODULE__{id: id}) do
    id
  end

  @doc since: "0.2.0"
  @doc """
  Get object fields names (properties, links and link propries) as list of strings.

  See `t:Gel.Object.fields_option/0` for supported options.
  """
  @spec fields(t(), list(fields_option())) :: list(String.t())
  def fields(%__MODULE__{} = object, opts \\ []) do
    include_properies? = Keyword.get(opts, :properties, true)
    include_links? = Keyword.get(opts, :links, true)
    include_link_properties? = Keyword.get(opts, :link_propeties, true)
    include_id? = Keyword.get(opts, :id, false)
    include_implicits? = Keyword.get(opts, :implicit, false)

    object.fields
    |> Enum.filter(fn
      {"id", %Field{is_implicit: true}} ->
        include_id? or include_implicits?

      {_name, %Field{is_implicit: true}} ->
        include_implicits?

      {_name, %Field{is_link: true}} ->
        include_links?

      {_name, %Field{is_link_property: true}} ->
        include_link_properties?

      _other ->
        include_properies?
    end)
    |> Enum.map(fn {name, _field} ->
      name
    end)
  end

  @doc since: "0.2.0"
  @doc """
  Get object properties names as list.

  See `t:Gel.Object.properties_option/0` for supported options.
  """
  @spec properties(t(), list(properties_option())) :: list(String.t())
  def properties(%__MODULE__{} = object, opts \\ []) do
    fields(object, Keyword.merge(opts, links: false, link_properties: false))
  end

  @doc since: "0.2.0"
  @doc """
  Get object links names as list.
  """
  @spec links(t()) :: list(String.t())
  def links(%__MODULE__{} = object) do
    fields(object, properties: false, link_properties: false)
  end

  @doc since: "0.2.0"
  @doc """
  Get object link propeties names as list.
  """
  @spec link_properties(t()) :: list(String.t())
  def link_properties(%__MODULE__{} = object) do
    fields(object, properties: false, links: false)
  end

  @doc since: "0.3.0"
  @doc """
  Convert an object into a regular map.

  ```iex
  iex(1)> {:ok, client} = Gel.start_link()
  iex(2)> object =
  ...(2)>  Gel.query_required_single!(client, "\"\"
  ...(2)>   select schema::Property {
  ...(2)>       name,
  ...(2)>       annotations: {
  ...(2)>         name,
  ...(2)>         @value
  ...(2)>       }
  ...(2)>   }
  ...(2)>   filter .name = 'listen_port' and .source.name = 'cfg::Config'
  ...(2)>   limit 1
  ...(2)>  \"\"")
  iex(3)> Gel.Object.to_map(object)
  %{"name" => "listen_port", "annotations" => [%{"name" => "cfg::system", "@value" => "true"}]}
  ```
  """
  @spec to_map(t()) :: %{String.t() => term()}
  def to_map(%__MODULE__{fields: fields}) do
    fields
    |> Enum.reject(fn {_name, field} ->
      field.is_implicit
    end)
    |> Enum.into(%{}, fn
      {name, %Field{is_link: true, value: %Gel.Set{} = links}} ->
        {name, Enum.map(links, &to_map/1)}

      {name, %Field{is_link: true, value: %Gel.Object{} = link}} ->
        {name, to_map(link)}

      {name, %Field{value: property}} ->
        {name, property}
    end)
  end

  @impl Access
  def fetch(%__MODULE__{} = object, key) when is_atom(key) do
    fetch(object, Atom.to_string(key))
  end

  @impl Access
  def fetch(%__MODULE__{fields: fields}, key) when is_binary(key) do
    case fields do
      %{^key => %Field{value: value}} ->
        {:ok, value}

      _other ->
        :error
    end
  end

  @impl Access
  def get_and_update(%__MODULE__{}, _key, _function) do
    raise Gel.InterfaceError.new("objects can't be mutated")
  end

  @impl Access
  def pop(%__MODULE__{}, _key) do
    raise Gel.InterfaceError.new("objects can't be mutated")
  end
end

defimpl Inspect, for: Gel.Object do
  import Inspect.Algebra

  @impl Inspect
  def inspect(%Gel.Object{fields: fields, order: order}, opts) do
    visible_fields =
      Enum.reject(order, fn name ->
        fields[name].is_implicit
      end)

    fields_count = Enum.count(visible_fields)

    elements_docs =
      visible_fields
      |> Enum.with_index(1)
      |> Enum.map(fn
        {name, ^fields_count} ->
          concat([name, " := ", Inspect.inspect(fields[name].value, opts)])

        {name, _index} ->
          concat([name, " := ", Inspect.inspect(fields[name].value, opts), ", "])
      end)

    concat(["#Gel.Object<", concat(elements_docs), ">"])
  end
end
