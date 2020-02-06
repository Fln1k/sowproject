defmodule SowprojectWeb.UserController do
  use SowprojectWeb, :controller
  alias Sowproject.Accounts.User
  import Comeonin.Bcrypt, only: [checkpw: 2]
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
      Sowproject.Email.restore_password_html_email(params["user"]["email"],User.gen_token(params["user"]["email"]))
      |> Sowproject.Mailer.deliver_now()

      render(conn, "check_email.html")
    else
      conn
      |> put_flash(:error, "user with email #{params["user"]["email"]} not found!")
      |> redirect(to: Routes.user_path(conn, :password_new))
    end
  end

  def callback(conn, params) do
    user=Sowproject.Accounts.get_user_by_params(%{email: params["email"]})
    if checkpw(user.password,params["token"]) do
      conn = Guardian.Plug.sign_in(conn, user)
      changeset = User.changeset(%User{})
      render(conn, "password_change.html", changeset: changeset)
    else
    end
  end

  def update(conn, %{"user" => user_params}) do
    IO.inspect(user_params)
    user = Guardian.Plug.current_resource(conn)
    case Sowproject.Accounts.update_user(user, %{password: Comeonin.Bcrypt.hashpwsalt(user_params["password"])}) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Changed successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Oops. smt was wrong")
        render(conn, "password_change.html", changeset: changeset,user: user)
    end
  end
end
