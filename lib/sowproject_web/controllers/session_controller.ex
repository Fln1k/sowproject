defmodule SowprojectWeb.SessionController do
  use SowprojectWeb, :controller
  plug :scrub_params, "session" when action in ~w(create)a

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Sowproject.Auth.login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "You’re now signed in!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Sowproject.Auth.logout()
    |> put_flash(:info, "See you later!")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
