defmodule Qwestr.Repo.Migrations.UpdateQwestAddComplete do
  use Ecto.Migration

  def change do
  	alter table(:qwests) do
      add :completed, :boolean, default: false
		end
  end
end
