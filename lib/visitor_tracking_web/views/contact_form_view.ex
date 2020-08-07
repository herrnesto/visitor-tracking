defmodule VisitorTrackingWeb.ContactFormView do
  use VisitorTrackingWeb, :view

  def render("response.json", %{status: status, params: params}) do
    %{
      status: status,
      name: Map.get(params, "name")
    }
  end
end
