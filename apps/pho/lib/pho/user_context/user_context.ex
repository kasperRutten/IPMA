defmodule Pho.UserContext do
    alias __MODULE__.User
    alias Pho.Repo
  
    @doc "Returns a user changeset"
    def change_user(%User{} = user) do
      user |> User.changeset(%{})
    end
  
    @doc "Creates a user based on some external attributes"
    def create_user(attributes) do
      %User{}
      |> User.changeset(attributes)
      |> Repo.insert()
    end
  end