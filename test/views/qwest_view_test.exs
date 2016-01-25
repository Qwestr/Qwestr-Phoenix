defmodule Qwestr.QwestViewTest do 
	use Qwestr.ConnCase, async: true 

	alias Qwestr.Qwest
	alias Qwestr.QwestView
	alias Qwestr.Enums.Repeat

	import Phoenix.View

	# Constants

	@valid_qwest_1 %Qwest{id: "1", title: "Qwest 1", repeat: :daily} 
	@valid_qwest_2 %Qwest{id: "2", title: "Qwest 2", repeat: :yearly}

	# Setup

	setup do
		{:ok, conn: conn()}
	end

	# Tests

	test "renders index.html", %{conn: conn} do 
		# create view content
		qwests = [@valid_qwest_1, @valid_qwest_2]
		
		# render view content
		content = render_to_string(QwestView, "index.html", conn: conn, qwests: qwests)

		assert String.contains?(content, "Listing qwests") 
		for qwest <- qwests do
    	assert String.contains?(content, qwest.title)
		end 
	end

	test "renders new.html", %{conn: conn} do
		# create view content
		changeset = Qwest.changeset(%Qwest{}) 
		repeat_options = Repeat.select_map()

		# render view content
		content = render_to_string(QwestView, "new.html", conn: conn, changeset: changeset, repeat_options: repeat_options)

		assert String.contains?(content, "New qwest") 
	end

	test "renders edit.html", %{conn: conn} do
		# create view content
		qwest = @valid_qwest_1
		changeset = Qwest.changeset(qwest) 
		repeat_options = Repeat.select_map()

		# render view content
		content = render_to_string(QwestView, "edit.html", conn: conn, changeset: changeset, qwest: qwest, repeat_options: repeat_options)

		assert String.contains?(content, "Edit qwest") 
	end

	test "renders show.html", %{conn: conn} do
		# create view content
		qwest = @valid_qwest_1
		changeset = Qwest.changeset(qwest) 
		
		# render view content
		content = render_to_string(QwestView, "show.html", conn: conn, changeset: changeset, qwest: qwest)

		assert String.contains?(content, "Show qwest") 
	end
end