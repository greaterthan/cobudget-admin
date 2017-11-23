defmodule CobudgetAdminWeb.Router do
  use CobudgetAdminWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug CobudgetAdminWeb.Plugs.Authentication, 
      action: :require_auth, 
      redirect_url: "/auth/login"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", CobudgetAdminWeb do
    pipe_through :browser

    get "/login", Plugs.Authentication, action: :login, callback: "/auth/google/oauth2callback"
    get "/google/oauth2callback", Plugs.Authentication, action: :callback, callback: "/auth/google/oauth2callback"
  end

  scope "/", CobudgetAdminWeb do
    pipe_through [:browser, :auth] # Verify user is authenticated

    get "/", PageController, :index
    get "/buckets", PageController, :buckets
    get "/contributions", PageController, :contributions
  end

  # Other scopes may use custom stacks.
  # scope "/api", CobudgetAdminWeb do
  #   pipe_through :api
  # end

end
