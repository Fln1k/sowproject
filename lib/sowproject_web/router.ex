defmodule SowprojectWeb.Router do
  use SowprojectWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Sowproject.CurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SowprojectWeb do
    pipe_through [:browser, :with_session]

    get "/", PageController, :index
    get "/users/login/forgotpassword", UserController, :password_new
    get "/restorepassword", UserController, :callback
    post "/users/login/forgotpassword/sendrecoverylink", UserController, :change_pass_request
    post "/update", UserController, :update
    resources "/users", UserController, only: [:show, :new, :create, :update]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/pages", PageController
  end

  # Other scopes may use custom stacks.
  # scope "/api", SowprojectWeb do
  #   pipe_through :api
  # end
end
