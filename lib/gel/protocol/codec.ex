defprotocol Gel.Protocol.Codec do
  @moduledoc since: "0.2.0"
  @moduledoc """
  A codec knows how to work with the internal binary data from Gel.

  The binary protocol specification for the codecs can be found in
    [the relevant part of the Gel documentation](https://docs.geldata.com/database/reference/protocol).

  Useful links for codec developers:

    * [Gel datatypes used in data descriptions](https://docs.geldata.com/database/reference/protocol#conventions-and-data-types).
    * [Gel data wire formats](https://docs.geldata.com/database/reference/protocol/dataformats).
    * [Built-in Gel codec implementations](https://github.com/geldata/gel-elixir/tree/master/lib/gel/protocol/codecs).
    * [Custom codecs implementations](https://github.com/geldata/gel-elixir/tree/master/test/gel/protocol/codecs/custom).
    * Guide to developing custom codecs on [hex.pm](https://hexdocs.pm/gel/custom-codecs.html).
  """

  alias Gel.Protocol.CodecStorage

  @typedoc """
  Codec ID.
  """
  @type id() :: bitstring()

  @doc """
  Function that can encode an entity to Gel binary format.
  """
  @spec encode(t(), value, CodecStorage.t()) :: iodata() when value: term()
  def encode(codec, value, codec_storage)

  @doc """
  Function that can decode Gel binary format into an entity.
  """
  @spec decode(t(), bitstring(), CodecStorage.t()) :: value when value: term()
  def decode(codec, data, codec_storage)
end
