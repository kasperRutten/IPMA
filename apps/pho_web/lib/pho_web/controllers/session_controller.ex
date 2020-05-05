defmodule PhoWeb.SessionController do
    use PhoWeb, :controller
  
    alias PhoWeb.Guardian
    alias Pho.UserContext
    alias Pho.ApikeyContext
    alias Pho.UserContext.User
    alias Pho.AnimalContext

    def signup(conn, _) do
      changeset = UserContext.change_user(%User{})
      render(conn, "signup.html", changeset: changeset, action: Routes.session_path(conn, :create))
    end

    def create(conn, %{"user" => user_params}) do
      case UserContext.create_user(user_params) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, gettext("User created successfully."))
          |> redirect(to: Routes.session_path(conn, :new))
  
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "signup.html", changeset: changeset, action: Routes.session_path(conn, :create))
      end
    end
  
    def new(conn, _) do
      changeset = UserContext.change_user(%User{})
      maybe_user = Guardian.Plug.current_resource(conn)
  
      if maybe_user do
        redirect(conn, to: "/user_scope")
      else
        render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
      end
    end
  
    def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
      UserContext.authenticate_user(username, password)
      |> login_reply(conn)
    end
  
    def logout(conn, _) do
      conn
      |> Guardian.Plug.sign_out()
      |> redirect(to: "/login")
    end
  
    defp login_reply({:ok, user}, conn) do
      conn
      |> put_flash(:info, gettext("Welcome back!"))
      |> Guardian.Plug.sign_in(user)
      |> redirect(to: "/user_scope")
    end
  
    defp login_reply({:error, _reason}, conn) do
      conn
      |> put_flash(:error, gettext("Invalid credentials, try again."))
      |> new(%{})
    end

    def profile(conn, _) do
      user = Guardian.Plug.current_resource(conn)
      changeset = UserContext.change_user(user)
      user_with_loaded_apikeys = ApikeyContext.load_apikeys(user)
      render(conn, "profile.html", changeset: changeset, user: user, apikeys: user_with_loaded_apikeys.apikeys)
    end

    def overview(conn, _) do
      user = Guardian.Plug.current_resource(conn)
      user_with_loaded_animals = AnimalContext.load_animals(user)
      animals = user_with_loaded_animals.animals
      render(conn, "overview.html", animals: animals)
    end

    def editUsername(conn, _) do
      user = Guardian.Plug.current_resource(conn)
      changeset = UserContext.change_user(user)
      render(conn, "editUsername.html", changeset: changeset, action: Routes.session_path(conn, :updateUsername))
    end

    def updateUsername(conn, %{"user" => %{"username" => username}}) do
      user = Guardian.Plug.current_resource(conn)
      changeset = UserContext.change_user(user)
      case UserContext.update_username(user, username) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, gettext("Username updated successfully."))
          |> redirect(to: Routes.session_path(conn, :profile))
  
        {:error} ->
          conn
          |> put_flash(:error, gettext("Username must be filled in."))
          |> render("editUsername.html", changeset: changeset, action: Routes.session_path(conn, :updateUsername))
      end
    end

    def editPassword(conn, _) do
      user = Guardian.Plug.current_resource(conn)
      changeset = UserContext.change_user(user)
      render(conn, "editPassword.html", changeset: changeset, action: Routes.session_path(conn, :updatePassword))
    end

    def updatePassword(conn, %{"user" => %{"password" => password, "password_confirmation" => confirm_password, "current_password" => current_password}}) do
      user = Guardian.Plug.current_resource(conn)
      changeset = UserContext.change_user(user)
      IO.puts "underneath: hashed_password"
      IO.inspect user.hashed_password
      IO.puts "above: hashed_password"
      if Pbkdf2.verify_pass(current_password, user.hashed_password) do
        case password == confirm_password do
          true ->
        case UserContext.update_password(user, password) do
          {:ok, _user} ->
            conn
            |> put_flash(:info, gettext("Password updated successfully."))
            |> redirect(to: Routes.session_path(conn, :profile))
    
          {:error} ->
            conn
            |> put_flash(:error, gettext("Password must be filled in."))
            |> render("editPassword.html", changeset: changeset, action: Routes.session_path(conn, :updatePassword))
        end
          false ->
            conn
            |> put_flash(:error, gettext("Password confirmation doesn't match password"))
            |> render("editPassword.html", changeset: changeset, action: Routes.session_path(conn, :updatePassword))
          end
      else
        conn
          |> put_flash(:error, gettext("Current password is wrong"))
          |> render("editPassword.html", changeset: changeset, action: Routes.session_path(conn, :updatePassword))
      end


    end
    
  end