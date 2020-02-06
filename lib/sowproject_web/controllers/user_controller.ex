defmodule SowprojectWeb.UserController do
    use SowprojectWeb, :controller
    alias Sowproject.Accounts.User
    def show(conn, %{"id" => id}) do
      user = Sowproject.Repo.get!(User, id)
      render(conn, "show.html", user: user)
    end
    def new(conn, _params) do
      changeset = User.changeset(%User{})
      render conn, "new.html", changeset: changeset
    end
    def create(conn, %{"user" => user_params}) do
      # here will be an implementation
    end
  end