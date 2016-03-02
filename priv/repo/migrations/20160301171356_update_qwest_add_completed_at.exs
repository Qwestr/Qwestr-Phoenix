defmodule Qwestr.Repo.Migrations.UpdateQwestAddCompletedAt do
  use Ecto.Migration

  def change do
  	alter table(:qwests) do
			add :completed_at, :datetime
		end
  end
end
