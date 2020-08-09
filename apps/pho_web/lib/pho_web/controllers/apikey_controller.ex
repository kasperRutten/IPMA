defmodule PhoWeb.ApikeyController do
    use PhoWeb, :controller
  
    alias Pho.UserContext
    alias PhoWeb.Guardian
    alias Pho.ApikeyContext

    plug :put_view, PhoWeb.SessionView

    def new(conn, %{"user" => %{"API_key" => name, "is_writeable" => isWriteable}}) do
      if String.length(name) == 0 do
        IO.puts "its blank"
        conn
        |> put_flash(:error, gettext("API key name can't be blank."))
        |> redirect(to: Routes.session_path(conn, :profile))
      else
        IO.puts isWriteable
        user = Guardian.Plug.current_resource(conn)
        changeset = UserContext.change_user(user)
        _apikey =  ApikeyContext.create_apikey(name, isWriteable, user)
        user_with_loaded_apikeys = ApikeyContext.load_apikeys(user)
        conn
        |> assign(:iswriteable, isWriteable)
        |> put_flash(:info, gettext("API key created succesfully."))
        |> render("profile.html", changeset: changeset, user: user, apikeys: user_with_loaded_apikeys.apikeys)
        end
      end

    def show(conn, %{"id" => id}) do
        allApikeys = ApikeyContext.list_apikeys
        allIds = Enum.map(allApikeys, & &1.id)
        IO.inspect String.to_integer(id)
        IO.inspect List.first(allIds)
        if Enum.any?(allIds, fn x -> x == String.to_integer(id) end) == false do
            render(conn, "showFalseApikey.html", errorMessage: gettext("No such API key ID"))
        else
        apikey = ApikeyContext.get_apikey!(id)
        user = Guardian.Plug.current_resource(conn)
        user_with_loaded_apikeys = ApikeyContext.load_apikeys(user)

        case ApikeyContext.verify_user!(conn, user_with_loaded_apikeys, apikey.id) do
            {:ok, true} ->
              IO.puts "id is right"
              render(conn, "showApikey.html", apikey: apikey)
            {:ok, false} ->
              IO.puts "id is wrong"
              render(conn, "showFalseApikey.html", errorMessage: gettext("Unauthorized access"))
            end
        end
    end

    def delete(conn, %{"id" => id}) do
      allApikeys = ApikeyContext.list_apikeys
        allIds = Enum.map(allApikeys, & &1.id)
        IO.inspect String.to_integer(id)
        IO.inspect List.first(allIds)
        if Enum.any?(allIds, fn x -> x == String.to_integer(id) end) == false do
            render(conn, "showFalseApikey.html", errorMessage: gettext("No such API key ID"))
        else
        apikey = ApikeyContext.get_apikey!(id)
        user = Guardian.Plug.current_resource(conn)
        user_with_loaded_apikeys = ApikeyContext.load_apikeys(user)
        case ApikeyContext.verify_user!(conn, user_with_loaded_apikeys, apikey.id) do
            {:ok, true} ->
              IO.puts "id is right"
              {:ok, _apikey} = ApikeyContext.delete_apikey(apikey)
    
              conn
                |> put_flash(:info, gettext("API key deleted successfully."))
                |> redirect(to: Routes.session_path(conn, :profile))
            {:ok, false} ->
              IO.puts "id is wrong"
              render(conn, "showFalseApikey.html", errorMessage: gettext("Unauthorized access"))
            end
          end
    end

    def update(conn, %{"user" => %{"API_key" => name, "is_writeable" => isWriteable}}) do
      if String.length(name) == 0 do
        IO.puts "its blank"
        conn
        |> put_flash(:error, gettext("API key name can't be blank."))
        |> redirect(to: Routes.session_path(conn, :profile))
      else
        user = Guardian.Plug.current_resource(conn)
        changeset = UserContext.change_user(user)
        _apikey =  ApikeyContext.create_apikey(name, isWriteable, user)
        user_with_loaded_apikeys = ApikeyContext.load_apikeys(user)
        conn
        |> put_flash(:info, gettext("API key created succesfully."))
        |> render("profile.html", changeset: changeset, user: user, apikeys: user_with_loaded_apikeys.apikeys)
      end
    end
  
    
  end