defmodule SowprojectWeb.UserController do
  use SowprojectWeb, :controller
  alias Sowproject.Accounts.User
  plug :scrub_params, "user" when action in [:create]

  def show(conn, %{"id" => id}) do
    user = Sowproject.Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = %User{} |> User.registration_changeset(user_params)

    case Sowproject.Repo.insert(changeset) do
      {:ok, user} ->
        Sowproject.Email.welcome_html_email(user.email) |> Sowproject.Mailer.deliver_now
        conn
        |> Sowproject.Auth.login(user)
        |> put_flash(:info, "#{user.email} created!")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
