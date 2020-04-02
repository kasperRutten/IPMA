defmodule PhoWeb.LoginController do
  use PhoWeb, :controller

  def login(conn, _params) do
    render(conn, "login.html")
  end
end