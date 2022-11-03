defmodule RiverWeb.PageController do
  use RiverWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
