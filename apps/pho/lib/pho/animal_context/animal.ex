defmodule Pho.AnimalContext.Animal do
    use Ecto.Schema
    import Ecto.Changeset

    alias Pho.UserContext.User
  
    schema "animals" do
      field :name, :string
      field :type, :string
      field :birthday, :string
      belongs_to :user, User
    end
    
    @doc false
  def changeset(animal, attrs) do
    animal
    |> cast(attrs, [:name, :type,:birthday])
    |> validate_required([:name, :type,:birthday])
  end

  @doc false
  def create_changeset(animal, attrs, user) do
    animal
    |> cast(attrs, [:name, :type, :birthday])
    |> validate_required([:name, :type, :birthday])
    |> put_assoc(:user, user)
  end
  end