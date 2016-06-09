defmodule Qwestr.Repo.Migrations.UpdateQwestAddRepeat do
  use Ecto.Migration

  def change do
  	alter table(:qwests) do
			add :repeat, :int, default: 0
		end
  end
end
