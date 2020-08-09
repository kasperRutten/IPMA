defmodule Pho.Repo.Migrations.CreateApikeys do
  use Ecto.Migration

  def change do
    create table(:apikeys) do
      add :name, :string
      add :key, :string
      add :isWriteable, :boolean
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
    create index(:apikeys, [:name, :user_id])
  end
end
