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
        Sowproject.Email.welcome_html_email(user.email) |> Sowproject.Mailer.deliver_now()

        conn
        |> Sowproject.Auth.login(user)
        |> put_flash(:info, "#{user.email} created!")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def password_new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "password_change_request.html", changeset: changeset)
  end

  def change_pass_request(conn, params) do
    if Sowproject.Repo.get_by(User, email: params["user"]["email"]) do
      Sowproject.Email.restore_password_html_email(params["user"]["email"]) |> Sowproject.Mailer.deliver_now()
      render(conn, "check_email.html")
    else
      conn
      |> put_flash(:error, "user with email #{params["user"]["email"]} not found!")
      |> redirect(to: Routes.user_path(conn, :password_new))
    end
  end

  def callback(conn, %{"magic_token" => magic_token}) do
    case Guardian.decode_magic(magic_token) do
      {:ok, user, _claims} ->
        changeset = User.changeset(%User{})
        render(conn, "password_change.html", changeset: changeset)
      _ ->
        conn
        |> put_flash(:error, "Invalid magic link.")
        |> redirect(to: Routes.user_path(conn, :new))
    end
  end
end
