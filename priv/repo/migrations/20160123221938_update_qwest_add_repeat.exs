defmodule Qwestr.Repo.Migrations.UpdateQwestAddRepeat do
  use Ecto.Migration

  def change do
  	alter table(:qwests) do
			add :repeat, :integer, default: 0
		end
  end
end
