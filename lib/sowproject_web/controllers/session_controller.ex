defmodule SowprojectWeb.SessionController do
  use SowprojectWeb, :controller

  alias Sowproject.{Accounts, Accounts.User, Accounts.Guardian}

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/index")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Accounts.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    # This module's full name is Auth.Accounts.Guardian.Plug,
    |> Guardian.Plug.sign_out()
    # and the arguments specfied in the Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  # docs are not applicable here

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    # This module's full name is Auth.Accounts.Guardian.Plug,
    |> Guardian.Plug.sign_in(user)
    # and the arguments specified in the Guardian.Plug.sign_in()
    |> redirect(to: "/protected")
  end

  # docs are not applicable here.

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
