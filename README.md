# VisitorTracking

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## SMS Gateway Twilio
For `dev` and `prod` you have to setup environment variables:
```
export TWILIO_ACCOUNT_SID=xxx
export TWILIO_AUTH_TOKEN=xxx
export TWILIO_FROM=41793154409
export MAILTRAP_USER=xxxx
export MAILTRAP_PASSWORD=xxx
```

## Email test
```
"hello@vesita.ch" |> Email.verification_email("tokentest") |> Mailer.deliver_now()
```	