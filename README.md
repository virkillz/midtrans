# Midtrans

If you building application with Elixir Phoenix and want to use midtrans as your payment gateway, this is the easiest way to implement it on server side with redirection.

## How to use

1. Get your `SERVER_KEY` from [midtrans](https://dashboard.sandbox.midtrans.com/integrations/configurations).

2. Create a Map containing your transaction detail. You can follow [this documentation for refference](https://snap-docs.midtrans.com/#request-body-json-parameter). But the minimum can be made as follow:

```elixir
payload =
  %{"transaction_details" =>
    %{"order_id" => "ORDER-101",
      "gross_amount" => 10000
    }
  }
```

3. Call the function to get the redirect URL

```
  Midtrans.get_token(:sandbox, payload, your_server_key)
```

4. You will receive following response:

   ```elixir
   {:ok,
     %{
       "redirect_url" => "https://app.sandbox.midtrans.com/snap/v2/vtweb/f2fa54e2-5230-4860-b7e5-31c2e74cea81",
       "token" => "f2fa54e2-5230-4860-b7e5-31c2e74cea81"
     }}

   ```

   or if something goes wrong

   ```elixir
    %{:error, "The reason of the error."}
   ```

5. Then simply ask your controller to redirect to that `redirect_url`.

Assuming you already configure the URL correctly in your config. That's all you need to do.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `midtrans` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:midtrans, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/midtrans](https://hexdocs.pm/midtrans).
