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

    get "/", HomepageController, :index
    get "/login", SessionController, :new
    post "/sessions", SessionController, :create
    get "/register", RegistrationController, :new
    post "/users", RegistrationController, :create
    get "/scan", ScanController, :index
    get "/v/:token", RegistrationController, :verify_email
  end

  scope "/", VisitorTrackingWeb do
    pipe_through [:browser, :authenticate_user]

    delete "/logout", SessionController, :delete
    get "/expecting_verification", RegistrationController, :expecting_verification
    get "/new_token", RegistrationController, :new_token
  end

  scope "/", VisitorTrackingWeb do
    pipe_through [:browser, :authenticate_user, :check_email_verified]

    get "/profiles/new", ProfileController, :new
    post "/profiles", ProfileController, :create
  end

  scope "/", VisitorTrackingWeb do
    pipe_through [:browser, :authenticate_user, :check_email_verified, :profile_created]

    get "/profiles/phone_verification", ProfileController, :phone_verification
    post "/profiles/phone", ProfileController, :verify_phone
  end

  scope "/", VisitorTrackingWeb do
    pipe_through [:browser, :authenticate_user, :check_email_verified, :profile_created, :check_phone_verified]

    get "/events", EventController, :index
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
