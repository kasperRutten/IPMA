defmodule PhoWeb.PageController do
  use PhoWeb, :controller
  alias Pho.UserContext
  alias Pho.AnimalContext
  alias PhoWeb.Guardian
  plug :put_view, PhoWeb.SessionView

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    if user == nil do
      noAnimals = Map.new()
      render(conn, "overview.html", animals: noAnimals)
    else
      user_with_loaded_animals = AnimalContext.load_animals(user)
      animals = user_with_loaded_animals.animals
      render(conn, "overview.html", animals: animals)
    end
  end

  def user_index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    user_with_loaded_animals = AnimalContext.load_animals(user)
    animals = user_with_loaded_animals.animals
    render(conn, "overview.html", animals: animals)
  end

  def admin_index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    user_with_loaded_animals = AnimalContext.load_animals(user)
    animals = user_with_loaded_animals.animals
    render(conn, "overview.html", animals: animals)
  end
end