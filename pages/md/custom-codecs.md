# Custom codecs for Gel scalars

`Gel.Protocol.Codec` is a codec that knows how to encode or decode Elixir types into Gel types
  and vice versa using the Gel binary format.

Custom codecs can be useful when your Gel scalars need their own processing.

> #### NOTE {: .warning}
>
> Although most of the client API is complete, some internal parts may be changed in the future.
>   The implementation of the binary protocol (including the definition of custom codecs) is on the list of possible changes.

In most cases you can use already defined codecs to work with the Gel binary protocol. Otherwise,
  you will need to check to the Gel [binary protocol documentation](https://docs.geldata.com/database/reference/protocol).

To implement custom codec it will be required to implement `Gel.Protocol.CustomCodec` behaviour
  and implement `Gel.Protocol.Codec` protocol.

As an example, let's create a custom codec for a scalar that extends the standard `std::json` type.

```sdl
module default {
    scalar type JSONPayload extending json;

    type User {
        required name: str {
            constraint exclusive;
        };

        required payload: JSONPayload;
    }
};
```

We will convert the following structure to `default::JSONPayload`:

```elixir
defmodule MyApp.Users.Payload do
  defstruct [
    :public_id,
    :first_name,
    :last_name
  ]

  @type t() :: %__MODULE__{
          public_id: integer(),
          first_name: String.t(),
          last_name: String.t()
        }
end
```

The implementation of the codec itself:

```elixir
defmodule MyApp.Gel.Codecs.JSONPayload do
  @behviour Gel.Protocol.CustomCodec

  defstruct []

  @impl Gel.Protocol.CustomCodec
  def new do
    %__MODULE__{}
  end

  @impl Gel.Protocol.CustomCodec
  def name do
    "default::JSONPayload"
  end
end

defimpl Gel.Protocol.Codec, for: MyApp.Gel.Codecs.JSONPayload do
  alias Gel.Protocol.{
    Codec,
    CodecStorage
  }

  alias MyApp.Gel.Codecs.JSONPayload
  alias MyApp.Users.Payload

  @impl Codec
  def encode(_codec, %Payload{} = payload, codec_storage) do
    json_codec = CodecStorage.get_by_name(codec_storage, "std::json")
    Codec.encode(json_codec, Map.from_struct(payload), codec_storage)
  end

  @impl Codec
  def encode(_codec, value, codec_storage) do
    raise Gel.InterfaceError.new(
            "unexpected value to encode as #{inspect(JSONPayload.name())}: #{inspect(value)}"
          )
  end

  @impl Codec
  def decode(_codec, data, codec_storage) do
    json_codec = CodecStorage.get_by_name(codec_storage, "std::json")
    payload = Codec.decode(json_codec, data, codec_storage)
    %Payload{
      public_id: payload["public_id"]
      first_name: payload["first_name"]
      last_name: payload["last_name"]
    }
  end
end
```

Now let's test this codec:

```iex
iex(1)> {:ok, client} = Gel.start_link(codecs: [MyApp.Gel.Codecs.JSONPayload])
iex(2)> payload = %MyApp.Users.Payload{public_id: 1, first_name: "Harry", last_name: "Potter"}
iex(3)> Gel.query!(client, "insert User { name := <str>$username, payload := <JSONPayload>$payload }", username: "user", payload: payload)
iex(4)> object = Gel.query_required_single!(client, "select User {name, payload} filter .name = 'user' limit 1")
#Gel.Object<name := "user", payload := %MyApp.Users.Payload{
  first_name: "Harry",
  last_name: "Potter",
  public_id: 1
}>
```
