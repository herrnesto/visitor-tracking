defmodule VisitorTrackingWeb.ProfileController do
  use VisitorTrackingWeb, :controller

  alias VisitorTracking.{Accounts, Twilio, Verification}

  def new(conn, _) do
    user_id = get_session(conn, :user_id)
    changeset = Accounts.change_profile(user_id)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    with {:ok, profile} <- Accounts.create_profile(params),
         {:ok, token} <- Verification.create_sms_code(profile.user_id, profile.phone),
         {:ok, _} <- Twilio.send_token(%{token: token, target_number: profile.phone}) do
      conn
      |> put_flash(:info, "Profile created. Check your mobile for an sms with a code")
      |> redirect(to: "/profiles/phone_verification")
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "There was a problem creating your profile")
        |> render("new.html", changeset: changeset)

      {:error, status} ->
        conn
        |> put_flash(:error, status)
        |> render(to: "/profiles/phone_verification")

      error ->
        conn
        |> put_flash(:error, error)
        |> render(to: "/profiles/phone_verification")
    end
  end
end
