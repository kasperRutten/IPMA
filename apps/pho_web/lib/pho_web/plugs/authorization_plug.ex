defmodule PhoWeb.Plugs.AuthorizationPlug do
    import Plug.Conn
    import PhoWeb.Gettext
    alias Pho.UserContext.User
    alias Phoenix.Controller
  
    def init(options), do: options
  
    def call(%{private: %{guardian_default_resource: %User{} = u}} = conn, roles) do
      conn
      |> grant_access(u.role in roles)
    end
  
    def grant_access(conn, true), do: conn
  
    def grant_access(conn, false) do
      conn
      |> Controller.put_flash(:error, gettext "Unauthorized access")
      |> Controller.redirect(to: "/")
      |> halt
    end
  end