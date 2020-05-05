defmodule Pho.AnimalContext do 
    import Ecto.Query, warn: false
    alias Pho.Repo
  
    alias Pho.AnimalContext.Animal
    alias Pho.UserContext.User
  
    def load_animals(%User{} = u), do: u |> Repo.preload([:animals])
  
    def list_animals do
      Repo.all(Animal)
    end
  
    def get_animal!(id), do: Repo.get!(Animal, id)
  
    def create_animal(attrs, %User{} = user) do
      %Animal{}
      |> Animal.create_changeset(attrs, user)
      |> Repo.insert()
    end
  
    def update_animal(%Animal{} = animal, attrs) do
      animal
      |> Animal.changeset(attrs)
      |> Repo.update()
    end
  
    def delete_animal(%Animal{} = animal) do
      Repo.delete(animal)
    end
  
    def change_animal(%Animal{} = animal) do
      Animal.changeset(animal, %{})
    end   
  end