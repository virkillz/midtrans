defmodule Midtrans do
  @moduledoc """
  Documentation for Midtrans.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Midtrans.hello()
      :world

       Midtrans.get_token(:sandbox, %{"transaction_details" => %{"order_id" => "Order-1012", "gross_amount" => 100000}}, "SB-Mid-server-YY_hqXAGhzyD3iFNf42npUEe")

      "SB-Mid-server-YY_hqXAGhzyD3iFNf42npUEe"

          payload = %{
      "transaction_details" => %{
        "order_id" => "ORDER-101",
        "gross_amount" => 10000
      }
    }

  """

  def get_token(:prod, payload, server_key) do
    url = "https://app.midtrans.com/snap/v1/transactions"
    call_token(url, payload, server_key)
  end

  def get_token(:sandbox, payload, server_key) do
    url = "https://app.sandbox.midtrans.com/snap/v1/transactions"
    call_token(url, payload, server_key)
  end

  defp call_token(url, payload, server_key) do
    header = header_builder(server_key)

    post_body = Jason.encode!(payload)

    case HTTPoison.post(url, post_body, header) do
      {:ok, %HTTPoison.Response{body: body, status_code: 201}} -> Jason.decode(body)
      {:ok, %HTTPoison.Response{body: body}} -> decode_error(body)
      {:ok, _} -> {:error, "Unknown error from Midtrans return"}
      _ -> {:error, "Cannot connect to the server, the issue is from our side."}
    end
  end

  defp decode_error(json) do
    case Jason.decode(json) do
      {:ok, %{"error_messages" => list}} -> {:error, List.first(list)}
      {:ok, _} -> {:error, "Unknown error from Midtrans"}
      {:error, _} -> {:error, "Failed to decode json response from midtrans."}
    end
  end

  defp header_builder(server_key) do
    auth_key = Base.encode64("#{server_key}:")

    %{
      "Content-Type" => "application/json",
      "Accept" => "application/json",
      "Authorization" => "Basic #{auth_key}"
    }
  end
end
