defmodule PhoWeb.PageController do
  use PhoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
