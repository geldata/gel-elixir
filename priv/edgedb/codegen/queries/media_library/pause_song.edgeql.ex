# AUTOGENERATED: DO NOT MODIFY
# Generated by Elixir client for EdgeDB via `mix edgedb.generate` from
#   `priv/edgedb/edgeql/media_library/pause_song.edgeql`.
defmodule Tests.Codegen.Queries.MediaLibrary.PauseSong do
  @query """
  update Song
    filter .id = <uuid>$song_id
    set {
      status := SongStatus.paused
    }
  """

  @moduledoc """
  Generated module for the EdgeQL query from
    `priv/edgedb/edgeql/media_library/pause_song.edgeql`.

  Query:

  ```edgeql
  #{@query}
  ```
  """

  @typedoc """
  ```edgeql
  std::uuid
  ```
  """
  @type uuid() :: binary()

  @type keyword_args() :: [{:song_id, uuid()}]

  @type map_args() :: %{
          song_id: uuid()
        }

  @type args() :: map_args() | keyword_args()

  @doc """
  Run the query.
  """
  @spec query(
          client :: EdgeDB.client(),
          args :: args(),
          opts :: list(EdgeDB.query_option())
        ) ::
          {:ok, Result.t()}
          | {:error, reason}
        when reason: any()
  def query(client, args, opts \\ []) do
    do_query(client, args, opts)
  end

  @doc """
  Run the query.
  """
  @spec query!(
          client :: EdgeDB.client(),
          args :: args(),
          opts :: list(EdgeDB.query_option())
        ) :: Result.t()
  def query!(client, args, opts \\ []) do
    case do_query(client, args, opts) do
      {:ok, result} ->
        result

      {:error, exc} ->
        raise exc
    end
  end

  defp do_query(client, args, opts) do
    with {:ok, result} when not is_nil(result) <- EdgeDB.query_single(client, @query, args, opts) do
      {:ok, result}
    end
  end
end
