defmodule Qwestr.UserController do 
	use Qwestr.Web, :controller

	alias Qwestr.User
	alias Qwestr.Auth

	plug :authenticate_user when action in [:index, :show]

	def new(conn, _params) do
		changeset = User.changeset(%User{})
		render conn, "new.html", changeset: changeset
	end

	def create(conn, %{"user" => user_params}) do 
		changeset = User.registration_changeset(%User{}, user_params) 
		
		case Repo.insert(changeset) do
			
			{:ok, user} -> 
				conn
				|> Auth.login(user)
				|> put_flash(:info, "#{user.name} created!") 
				|> redirect(to: page_path(conn, :index))
			
			{:error, changeset} ->
				render(conn, "new.html", changeset: changeset)
		end
	end
end