defmodule PhoWeb.ErrorHandler do
    import Plug.Conn
    import PhoWeb.Gettext
  
    @behaviour Guardian.Plug.ErrorHandler
  
    @impl Guardian.Plug.ErrorHandler
    def auth_error(conn, {type, _reason}, _opts) do
      body = Jason.encode!(%{message: gettext("Login or register first")})
      send_resp(conn, 401, body)
    end
  end