defmodule Pho.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  import PhoWeb.Gettext

  @acceptable_roles ["Admin", "User"]


  schema "users" do
    field :role, :string, default: "User"
    field :username, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :hashed_password, :string
    has_many :animals, Pho.AnimalContext.Animal
    has_many :apikeys, Pho.ApikeyContext.Apikey
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role])
    |> validate_required([:username, :password, :role])
    |> unique_constraint(:username, name: :users_username_index,
      message:
        gettext("User with the same username already exists.")
    )
    |> validate_inclusion(:role, @acceptable_roles)
    |> validate_confirmation(:password)
    |> put_password_hash()
  end
    
  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

end
