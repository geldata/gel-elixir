defmodule Gel.Protocol.CustomCodec do
  @moduledoc since: "0.2.0"
  @moduledoc """
  Behaviour for custom scalar codecs.

  See custom codecs development guide on [hex.pm](https://hexdocs.pm/gel/custom-codecs.html) for more information.
  """

  alias Gel.Protocol.Codec

  @doc since: "0.2.0"
  @doc """
  Initialize custom codec.
  """
  @callback new() :: Codec.t()

  @doc since: "0.2.0"
  @doc """
  Get name for type that can be decoded by codec.
  """
  @callback name() :: String.t()
end
