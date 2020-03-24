defmodule SowprojectWeb.Router do
  use SowprojectWeb, :router

  pipeline :browser do
    plug(:accepts, ["html", "json"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :with_session do
    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.LoadResource)
    plug(Sowproject.CurrentUser)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SowprojectWeb do
    pipe_through([:browser, :with_session])

    get("/", PageController, :index)
    get("/users/login/forgotpassword", UserController, :password_change_request)
    get("/restorepassword", UserController, :callback)
    delete("/resetproject", PageController, :reset_project)
    post("/users/login/forgotpassword/sendrecoverylink", UserController, :send_recovery_link)
    post("/callback/update/user", UserController, :callback_update_user)
    post("/callback/update/results", FeaturesController, :callback_update_result)
    post("/callback/update/answer", FeaturesController, :callback_update_answer)
    post("/update", UserController, :update)
    post("/createresults", FeaturesController, :create_results)
    resources("/users", UserController, only: [:show, :new, :create, :update])
    resources("/sessions", SessionController, only: [:new, :create, :delete])
    resources("/pages", PageController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", SowprojectWeb do
  #   pipe_through :api
  # end
end
