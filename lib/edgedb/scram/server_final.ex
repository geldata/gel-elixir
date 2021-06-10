defmodule EdgeDB.SCRAM.ServerFinal do
  defstruct [
    :server_signature
  ]

  @type t() :: %__MODULE__{
          server_signature: String.t()
        }

  @spec new(String.t()) :: t()
  def new(server_signature) do
    %__MODULE__{server_signature: server_signature}
  end

  @spec server_final(t(), String.t()) ::
          :ok | {:error, :wrong_server_final_data | :mismatched_server_signatures}
  def server_final(%__MODULE__{} = sf, sf_data) do
    with {:ok, server_signature} <- parse_server_final_data(sf_data) do
      verify_server_signature(server_signature, sf.server_signature)
    end
  end

  @spec parse_server_final_data(String.t()) ::
          {:ok, String.t()} | {:error, :wrong_server_final_data}
  defp parse_server_final_data(server_final_data) do
    with "v=" <> encoded_signature <- server_final_data,
         {:ok, signature} <- Base.decode64(encoded_signature) do
      {:ok, signature}
    else
      _term ->
        {:error, :wrong_server_final_data}
    end
  end

  @spec verify_server_signature(String.t(), String.t()) ::
          :ok | {:error, :mismatched_server_signatures}
  defp verify_server_signature(received_server_signature, calculated_server_signature) do
    if received_server_signature == calculated_server_signature do
      :ok
    else
      {:error, :mismatched_server_signatures}
    end
  end
end
