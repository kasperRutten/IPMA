defmodule Pho.UserContext do
  @moduledoc """
  The UserContext context.
  """
  use Plug.Builder
  import Plug.Conn
  import Ecto.Query, warn: false
  alias Pho.Repo

  alias Pho.UserContext.User

  @doc """
  Returns the list of users.
  ## Examples
      iex> list_users()
      [%User{}, ...]
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.
  Raises `Ecto.NoResultsError` if the User does not exist.
  ## Examples
      iex> get_user!(123)
      %User{}
      iex> get_user!(456)
      ** (Ecto.NoResultsError)
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.
  ## Examples
      iex> create_user(%{field: value})
      {:ok, %User{}}
      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  ## Examples
      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}
      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_user(%User{} = user, attrs) do
    IO.puts "we're in usercontext update function"
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_username(%User{} = user, newUsername) do
    if String.length(newUsername) == 0 do
      {:error}
    else
      user
      |> Ecto.Changeset.change(%{username: newUsername})
      |> Pho.Repo.update()
    end
  end

  def update_password(%User{} = user, newPassword) do
    IO.inspect user.password
    IO.inspect user.username
    if String.length(newPassword) == 0 do
      {:error}
    else
      user
      |> Ecto.Changeset.change(%{password: newPassword})
      |> Ecto.Changeset.change(%{hashed_password: Pbkdf2.hash_pwd_salt(newPassword)})
      |> Pho.Repo.update()
    end
  end

  @doc """
  Deletes a user.
  ## Examples
      iex> delete_user(user)
      {:ok, %User{}}
      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  ## Examples
      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}
  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def verify_apiKey!(conn, %User{} = user) do
    if user.apiKey == List.first(get_req_header(conn, "apikeytoken")) do
      {:ok, true}
    else
      {:ok, false}
    end
  end

  def authenticate_user(username, plain_text_password) do
    case Repo.get_by(User, username: username) do
      nil ->
        Pbkdf2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Pbkdf2.verify_pass(plain_text_password, user.hashed_password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  def get_user(id), do: Repo.get(User, id)

  defdelegate get_acceptable_roles(), to: User
end