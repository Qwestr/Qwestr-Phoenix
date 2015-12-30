defmodule Qwestr.Repo.Migrations.CreateQwest do
  use Ecto.Migration

  def change do
    create table(:qwests) do
      add :title, :string
      add :user_id, references(:users)

      timestamps
    end
    create index(:qwests, [:user_id])

  end
end
