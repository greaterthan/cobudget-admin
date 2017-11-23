defmodule CobudgetAdminWeb.Router do
  use CobudgetAdminWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CobudgetAdminWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/buckets", PageController, :buckets
    get "/contributions", PageController, :contributions
    get "/auth/login", AuthController, :login
    get "/auth/googleauth", AuthController, :googleauth
  end

  # Other scopes may use custom stacks.
  # scope "/api", CobudgetAdminWeb do
  #   pipe_through :api
  # end

end
