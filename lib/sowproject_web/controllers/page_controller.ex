defmodule SowprojectWeb.PageController do
  use SowprojectWeb, :controller
  plug :is_sign_in

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def is_sign_in(conn, _params) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      conn
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt
    end
  end
end
