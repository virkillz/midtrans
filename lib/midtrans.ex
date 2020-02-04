defmodule Midtrans do
  @moduledoc """
  This is Module to generate the SNAP token and its respective redirect_url.
  """

  @doc """
  The only function to get the token.

  """


  # Midtrans.get_payment_url(%{"transaction_details" => %{"order_id" => "Order-1012", "gross_amount" => 100000}})

  def get_payment_url(payload) do

    server_key = Application.get_env(:midtrans, :server_key)
    url = Application.get_env(:midtrans, :url)

    cond do
      is_nil(server_key) -> {:error, "Can't find :server_key in your config file under :midtrans"}
      is_nil(url) -> {:error, "Can't find :url in your config file under :midtrans"}
      true ->

        header = header_builder(server_key)

        post_body = Jason.encode!(payload)

        case HTTPoison.post(url, post_body, header) do
          {:ok, %HTTPoison.Response{body: body, status_code: 201}} -> Jason.decode(body)
          {:ok, %HTTPoison.Response{body: body}} -> decode_error(body)
          {:ok, _} -> {:error, "Unknown error from Midtrans return"}
          _ -> {:error, "Cannot connect to the server, the issue is from our side."}
        end

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
