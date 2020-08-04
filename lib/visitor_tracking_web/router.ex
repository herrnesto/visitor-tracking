defmodule VisitorTrackingWeb.Router do
  use VisitorTrackingWeb, :router

  use Plug.ErrorHandler
  use Sentry.Plug

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
    plug :fetch_session
  end

  scope "/", VisitorTrackingWeb do
    pipe_through :browser

    get "/", CmsController, :homepage
    get "/datenschutz", CmsController, :privacy
    get "/login", SessionController, :new
    post "/sessions", SessionController, :create
    post "/users", RegistrationController, :create
    get "/phone_validation", RegistrationController, :phone_validation
    post "/register", RegistrationController, :new
    get "/phone_verification", RegistrationController, :phone_verification
    get "/qr/:uuid", QrController, :show
  end

  scope "/", VisitorTrackingWeb do
    pipe_through [:browser, :authenticate_user]

    delete "/logout", SessionController, :delete
    get "/new_token", RegistrationController, :new_token
    post "/phone", RegistrationController, :verify_phone
  end

  scope "/", VisitorTrackingWeb do
    pipe_through [:browser, :authenticate_user, :check_phone_verified]

    get "/expecting_verification", ProfileController, :expecting_verification
    get "/v/:token", ProfileController, :verify_email
    resources "/events", EventController
    get "/events/:id/scan", ScanController, :show
    get "/profile", ProfileController, :show
    get "/profile/qrcode", ProfileController, :show
  end

  # Other scopes may use custom stacks.
  scope "/api", VisitorTrackingWeb do
    pipe_through :api

    post "/scan/event_infos", ScanController, :event_infos
    post "/scan/user", ScanController, :user
    post "/scan/assign_visitor", ScanController, :assign_visitor
  end

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
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
