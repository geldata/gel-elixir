defmodule Gel.Protocol.BaseScalarCodec do
  @moduledoc false

  alias Gel.Protocol.Codec

  @callback new() :: Codec.t()
  @callback id() :: String.t()
  @callback name() :: String.t()
end
