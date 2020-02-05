defmodule SowprojectWeb.PageController do
  use SowprojectWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
