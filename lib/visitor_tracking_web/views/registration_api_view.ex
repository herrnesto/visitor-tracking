defmodule VisitorTrackingWeb.RegistrationApiView do
  use VisitorTrackingWeb, :view

  def render("response.json", %{status: status, params: params}) do
    %{
      status: status
    }
  end
end
