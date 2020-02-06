defmodule SowprojectWeb.SessionController do
  use SowprojectWeb, :controller
  plug :scrub_params, "session" when action in ~w(create)a
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Sowproject.Accounts.User

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    user = Sowproject.Repo.get_by(User, email: email)
    result =
      cond do
        user && checkpw(password, user.password) ->
          {:ok, login(conn, user)}
        user ->
          {:error, :unauthorized, conn}
        true ->
          dummy_checkpw
          {:error, :not_found, conn}
      end

    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You’re now logged in!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  defp login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

  def delete(conn, _) do
  end
end
