defmodule Qwestr.TestHelpers do
	alias Qwestr.Repo
	alias Qwestr.User
	alias Qwestr.Qwest

	def insert_user(attrs \\ %{}) do 
		changes = Dict.merge(%{
			name: "Some User",
			username: "user#{Base.encode16(:crypto.rand_bytes(8))}", password: "supersecret",
		}, attrs)
    
    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!()
	end

	def insert_qwest(user, attrs \\ %{}) do 
		user
		|> Ecto.Model.build(:qwests, attrs)
    |> Repo.insert!()
	end 

	def complete_qwest(qwest) do 
		qwest
		|> Qwest.complete_changeset()
	end 
end
