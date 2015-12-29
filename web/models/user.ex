defmodule Qwestr.User do 
	use Qwestr.Web, :model

	schema "users" do
		field :name, :string
		field :username, :string
		field :password, :string, virtual: true 
		field :password_hash, :string
		
		timestamps
	end 
end