defmodule Pho.ApikeyContext.Apikey do
    use Ecto.Schema
    import Ecto.Changeset

    alias Pho.UserContext.User
  
    schema "apikeys" do
      field :name, :string
      field :key, :string
      field :isWriteable, :boolean
      belongs_to :user, User
    end
    
    @doc false
  def changeset(apikey, attrs) do
    apikey
    |> cast(attrs, [:name, :key, :isWriteable])
    |> validate_required([:name, :key, :isWriteable])
    |> unique_constraint(:name, name: :apikeys_name_index,
      message:
        "API key with the same name already exists."
    )
  end

  @doc false
  def create_changeset(apikey, attrs, user) do
    apikey
    |> cast(attrs, [:name, :key, :isWriteable])
    |> validate_required([:name, :key, :isWriteable])
    |> put_assoc(:user, user)
  end
  end