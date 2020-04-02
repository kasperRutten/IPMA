defmodule PhoWeb.Router do
  use PhoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoWeb do
    pipe_through :browser

    get "/login", LoginController, :login
    get "/", PageController, :index
    get "/users/new", UserController, :new
    post "/users", UserController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoWeb do
  #   pipe_through :api
  # end
end
