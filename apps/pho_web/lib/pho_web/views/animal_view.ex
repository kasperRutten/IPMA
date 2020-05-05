defmodule PhoWeb.AnimalView do
    use PhoWeb, :view
    alias PhoWeb.AnimalView
  
    def render("index.json", %{animals: animals}) do
      %{data: render_many(animals, AnimalView, "animal.json")}
    end
  
    def render("show.json", %{animal: animal}) do
      %{data: render_one(animal, AnimalView, "animal.json")}
    end
  
    def render("animal.json", %{animal: animal}) do
      %{id: animal.id, name: animal.name, type: animal.type, birthday: animal.birthday}
    end
  end