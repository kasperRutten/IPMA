defmodule PhoWeb.Router do
  use PhoWeb, :router

  pipeline :browser do  
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PhoWeb.Plugs.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug PhoWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :allowed_for_users do
    plug PhoWeb.Plugs.AuthorizationPlug, ["Admin", "User"]
  end

  pipeline :allowed_for_admins do
    plug PhoWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  pipeline :no_layout do
    plug :put_layout, false
  end

  scope "/", PhoWeb do
    pipe_through [:browser, :auth, :ensure_auth, :no_layout]

    get "/profile/apikeys/:id", ApikeyController, :show
  end

  scope "/", PhoWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/signup", SessionController, :signup
    post "/create", SessionController, :create
  end

  scope "/", PhoWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]
    get "/profile", SessionController, :profile
    get "/overview", SessionController, :overview
    
    get "/profile/editUsername", SessionController, :editUsername
    put "/profile/editUsername", SessionController, :updateUsername
    patch "/profile/editUsername", SessionController, :updateUsername

    get "/profile/editPassword", SessionController, :editPassword
    put "/profile/editPassword", SessionController, :updatePassword
    patch "/profile/editPassword", SessionController, :updatePassword

    resources "/profile/apikeys", ApikeyController

    get "/user_scope", PageController, :user_index
  end
  
  scope "/admin", PhoWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    resources "/users", UserController
    get "/", PageController, :admin_index
  end

  scope "/api", PhoWeb do
    pipe_through :api

    resources "/users", UserController, only: [] do
      resources "/animals", AnimalController
    end
end
end
