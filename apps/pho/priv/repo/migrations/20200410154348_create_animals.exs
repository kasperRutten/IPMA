defmodule Pho.Repo.Migrations.CreateAnimals do
  use Ecto.Migration

  def change do
    create table(:animals) do
      add :name, :string, null: false
      add :type, :string, null: false
      add :birthday, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end
    create index(:animals, [:name, :user_id])
  end
end
