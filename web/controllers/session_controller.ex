defmodule Qwestr.SessionController do 
	use Qwestr.Web, :controller

	def new(conn, _) do 
		render conn, "new.html"
	end 
end