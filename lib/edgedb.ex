defmodule EdgeDB do
  @type connection :: pid()
  @type result :: term()
  @type params :: list()

  @type opts :: []
  @type query_opts :: [] | opts()
  @type transaction_opts :: [] | opts()

  @spec start_link(list()) :: DBConnection.start_link()
  def start_link(opts) do
    DBConnection.start_link(EdgeDB.Connection, opts)
  end

  @spec query(connection(), String.t(), params(), query_opts()) ::
          {:ok, result()} | {:error, Exception.t()}
  def query(conn, statement, params \\ [], opts \\ []) do
    q = %EdgeDB.Query{
      statement: statement
    }

    prepare_execute_query(conn, q, params, opts)
  end

  @spec query!(connection(), String.t(), params(), query_opts()) :: result()
  def query!(conn, statement, params \\ [], opts \\ []) do
    case query(conn, statement, params, opts) do
      {:ok, result} ->
        result

      {:error, _error} ->
        # use normal error here
        raise RuntimeError
    end
  end

  @spec query_one(connection(), String.t(), params(), query_opts()) ::
          {:ok, result()} | {:error, Exception.t()}
  def query_one(conn, statement, params \\ [], opts \\ []) do
    q = %EdgeDB.Query{
      statement: statement,
      cardinality: :one
    }

    prepare_execute_query(conn, q, params, opts)
  end

  @spec query_one!(connection(), String.t(), params(), query_opts()) :: result()
  def query_one!(conn, statement, params \\ [], opts \\ []) do
    case query_one(conn, statement, params, opts) do
      {:ok, result} ->
        result

      {:error, _error} ->
        # use normal error here
        raise RuntimeError
    end
  end

  @spec transaction(connection(), (DBConnection.t() -> result()), transaction_opts()) ::
          {:ok, result()} | {:error, term()}
  def transaction(conn, callback, opts \\ []) do
    DBConnection.transaction(conn, callback, opts)
  end

  @spec rollback(DBConnection.t(), term()) :: no_return()
  def rollback(conn, reason) do
    DBConnection.rollback(conn, reason)
  end

  @spec prepare_execute_query(connection(), EdgeDB.Query.t(), list(), list()) ::
          {:ok, term()} | {:error, Exception.t()}
  defp prepare_execute_query(conn, query, params, opts) do
    with {:ok, _q, %EdgeDB.Result{} = r} <-
           DBConnection.prepare_execute(conn, query, params, opts) do
      {:ok, EdgeDB.Result.extract(r)}
    end
  end
end
