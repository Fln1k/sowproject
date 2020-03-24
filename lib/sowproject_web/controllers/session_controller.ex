defmodule SowprojectWeb.SessionController do
  use SowprojectWeb, :controller
  plug(:scrub_params, "session" when action in ~w(create)a)
  plug(:is_sign_in, "session" when action in ~w(new)a)

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Sowproject.Auth.login_by_email_and_pass(conn, email, password) do
      {:ok, conn} ->
        conn
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
    |> redirect(to: Routes.page_path(conn, :index))
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
