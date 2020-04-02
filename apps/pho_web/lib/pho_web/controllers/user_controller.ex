defmodule PhoWeb.UserController do
    use PhoWeb, :controller
  
    alias Pho.UserContext
    alias Pho.UserContext.User
  
    def new(conn, _parameters) do
      changeset = UserContext.change_user(%User{})
      render(conn, "new.html", changeset: changeset)
    end
  
    def create(conn, %{"user" => user_params}) do
      case UserContext.create_user(user_params) do
        {:ok, user} ->
          conn
          |> put_flash(:info, "User #{user.first_name} #{user.last_name} created successfully.")
          |> redirect(to: Routes.user_path(conn, :new))
  
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end