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
    plug CORSPlug,
      origin: [
        "https://www.vesita.local:4001",
        "https://0.0.0.0:4001",
        "https://visitor-tracking-staging.gigalixirapp.com",
        "https://www.vesita.ch"
      ]

    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
  end

  scope "/", VisitorTrackingWeb do
    pipe_through :browser

    get "/", CmsController, :homepage
    get "/v/:token", ProfileController, :verify_email
    get "/datenschutz", CmsController, :privacy
    get "/preise", CmsController, :prices
    get "/so-einfach-funktioniert-vesita", CmsController, :howto
    get "/login", SessionController, :new
    post "/sessions", SessionController, :create
    get "/phone_validation", RegistrationController, :phone_validation
    post "/phone_confirmation", RegistrationController, :phone_confirmation
    get "/qr/:uuid", QrController, :show
    get "/kontakt", ContactFormController, :new
  end

  scope "/", VisitorTrackingWeb do
    pipe_through [:browser, :check_registered]

    post "/register", RegistrationController, :new
    post "/users", RegistrationController, :create
  end

  scope "/", VisitorTrackingWeb do
    pipe_through [:browser, :authenticate_user]

    delete "/logout", SessionController, :delete
    get "/new_token", RegistrationController, :new_token
    get "/phone_verification", RegistrationController, :phone_verification
  end

  scope "/", VisitorTrackingWeb do
    pipe_through [:browser, :authenticate_user, :check_phone_verified]

    get "/expecting_verification", ProfileController, :expecting_verification
    resources "/events", EventController
    get "/events/:id/start_event", EventController, :start_event
    get "/events/:id/close_event", EventController, :close_event
    get "/events/:event_id/scan", ScanController, :show
    resources "/events/:event_id/emergency", EmergencyController, only: [:new, :create]
    get "/profile", ProfileController, :show
    get "/profile/qrcode", ProfileController, :show
  end

  scope "/events/:event_id/scanners", VisitorTrackingWeb do
    pipe_through [:browser, :authenticate_user, :check_phone_verified, :check_if_event_organiser]

    resources "/", ScannerController
  end

  scope "/events/:event_id/emergency", VisitorTrackingWeb do
    pipe_through [:browser, :authenticate_user, :check_phone_verified, :check_if_event_organiser]
    # resources "/", EmergencyController
  end

  # Other scopes may use custom stacks.
  scope "/api", VisitorTrackingWeb do
    pipe_through :api

    post "/scan/event_infos", ScanController, :event_infos
    post "/scan/user", ScanController, :user
    post "/scan/assign_visitor", ScanController, :assign_visitor
    post "/contact_forms/create", ContactFormController, :create
    post "/scan/insert_action", ScanController, :insert_action
    post "/registration/user", RegistrationApiController, :create
    post "/phone", RegistrationApiController, :verify_phone
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
