defmodule SowprojectWeb.Router do
  use SowprojectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug Sowproject.Accounts.Pipeline
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  # Maybe logged in routes
  scope "/", SowprojectWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
  end

  # Definitely logged in scope
  scope "/", SowprojectWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/protected", PageController, :protected
  end
end
