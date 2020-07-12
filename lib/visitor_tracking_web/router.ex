defmodule VisitorTrackingWeb.Router do
  use VisitorTrackingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {VisitorTrackingWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug VisitorTrackingWeb.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VisitorTrackingWeb do
    pipe_through :browser

    live "/", PageLive, :index
    get "/login", SessionController, :new
    post "/sessions", SessionController, :create
    delete "/logout", SessionController, :delete
    get "/register", RegistrationController, :new
    post "/users", RegistrationController, :create
    get "/expecting_verification", RegistrationController, :expecting_verification
    get "/v/:token", RegistrationController, :verify_email
    get "/profiles/new", ProfileController, :new
    post "/profiles/create", ProfileController, :create
    get "/profiles/phone_verification", ProfileController, :phone_verification
    post "/profiles/phone", ProfileController, :verify_phone
  end

  # Other scopes may use custom stacks.
  # scope "/api", VisitorTrackingWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Application.get_env(:visitor_tracking, :developer_tools) == "true" do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: VisitorTrackingWeb.Telemetry
    end

    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
