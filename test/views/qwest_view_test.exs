defmodule Qwestr.QwestViewTest do 
	use Qwestr.ConnCase, async: true 

	alias Qwestr.Qwest
	alias Qwestr.QwestView

	import Phoenix.View

	setup do
		{:ok, conn: conn()}
	end

	test "renders index.html", %{conn: conn} do 
		qwests = [
			%Qwest{id: "1", title: "Qwest 1"}, 
			%Qwest{id: "2", title: "Qwest 2"}
		]
		
		# render view content
		content = render_to_string(QwestView, "index.html", conn: conn, qwests: qwests)

		assert String.contains?(content, "Listing qwests") 
		for qwest <- qwests do
    	assert String.contains?(content, qwest.title)
		end 
	end

	test "renders new.html", %{conn: conn} do
		changeset = Qwest.changeset(%Qwest{}) 
		
		# render view content
		content = render_to_string(QwestView, "new.html", conn: conn, changeset: changeset)

		assert String.contains?(content, "New qwest") 
	end
end