defmodule SowprojectWeb.UserController do
  use SowprojectWeb, :controller
  alias Sowproject.Accounts.User
  import Comeonin.Bcrypt, only: [checkpw: 2]

  plug(
    :is_sign_in
    when action in [
           :new,
           :create,
           :password_change_request,
           :send_recovery_link,
           :callback,
           :update
         ]
  )

  plug(:scrub_params, "user" when action in [:create])
  plug(:assign_token when action in [:callback])
  plug(:check_token when action in [:callback, :update])

  def show(conn, %{"id" => id}) do
    user = Sowproject.Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Sowproject.Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Sowproject.Auth.login(user)
        |> put_flash(:info, "#{user.email} created!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def password_change_request(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "password_change_request.html", changeset: changeset)
  end

  def send_recovery_link(conn, params) do
    email = params["user"]["email"]
    render(conn, "send_recovery_link.html", email: email)
  end

  def callback(conn, _params) do
    changeset = User.changeset(%User{})

    conn
    |> render("callback.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns[:user]

    case Sowproject.Accounts.update_user(user, %{
           password: user_params["password"]
         }) do
      {:ok, _user} ->
        conn
        |> Sowproject.Auth.login(user)
        |> put_flash(:info, "Changed successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Oops. smth was wrong")

        render(conn, "password_change.html", changeset: changeset, user: user)
    end
  end

  def callback_update_user(conn, user_params) do
    case Sowproject.Accounts.update_user(
           Sowproject.Accounts.get_user_by_params(%{id: user_params["id"]}),
           user_params
         ) do
      {:ok, user} ->
        response =
          user
          |> SowprojectWeb.PageController.prepare_variables()
          |> Enum.into(%{})
          |> Poison.encode!()

        send_resp(conn, 200, response)

      {:error, _} ->
        send_resp(conn, 400, "Oops. smth was wrong")
    end
  end

  def assign_token(conn, _params) do
    assign(conn, :token, conn.params["token"])
  end

  def check_token(conn, _params) do
    token = conn.assigns[:token] || conn.body_params["user"]["token"]

    case Sowproject.Accounts.User.decode_token(token) do
      [email, password] ->
        user = Sowproject.Accounts.get_user_by_params(%{email: email})

        if user && checkpw(user.password, password) do
          assign(conn, :user, user)
        else
          conn
          |> put_flash(:error, "Invalid Link")
          |> redirect(to: Routes.user_path(conn, :new))
        end

      :error ->
        conn
        |> put_flash(:error, "Invalid Link")
        |> redirect(to: Routes.user_path(conn, :new))
    end
  end

  def is_sign_in(conn, _params) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt
    else
      conn
    end
  end
end
