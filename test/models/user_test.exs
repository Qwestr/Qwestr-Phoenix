defmodule Qwestr.UserTest do
	use Qwestr.ModelCase, async: true 

	alias Qwestr.User

	@valid_attrs %{name: "Qwest User", username: "qwestr", password: "secret"} 
	@invalid_attrs %{}

	test "changeset with valid attributes" do
		changeset = User.changeset(%User{}, @valid_attrs) 
		
		assert changeset.valid?
	end

	test "changeset with invalid attributes" do
		changeset = User.changeset(%User{}, @invalid_attrs) 
		
		refute changeset.valid?
	end 
end