defmodule Qwestr.QwestViewTest do 
	use Qwestr.ConnCase, async: true 

	alias Qwestr.Qwest
	alias Qwestr.QwestView
	alias Qwestr.Enums.Repeat

	import Phoenix.View

	# Constants

	@valid_incomplete_qwest_1 %Qwest{id: "1", title: "Qwest 1", repeat: :daily} 
	@valid_incomplete_qwest_2 %Qwest{id: "2", title: "Qwest 2", repeat: :yearly}

	@valid_completed_qwest_1 %Qwest{id: "1", title: "Qwest 1", repeat: :daily, completed: true} 
	@valid_completed_qwest_2 %Qwest{id: "2", title: "Qwest 2", repeat: :yearly, completed: true}

	# Setup

	setup do
		{:ok, conn: conn()}
	end

	# Tests

	test "renders index.html", %{conn: conn} do 
		# create view content
		incomplete_qwests = [@valid_incomplete_qwest_1, @valid_incomplete_qwest_2]
		completed_qwests = [@valid_completed_qwest_1, @valid_completed_qwest_2]
		
		# render view content
		content = render_to_string(QwestView, "index.html", conn: conn, incomplete_qwests: incomplete_qwests, completed_qwests: completed_qwests)

		assert String.contains?(content, "Qwest List") 
		# assert that incomplete qwests appear on index
		for qwest <- incomplete_qwests do
    	assert String.contains?(content, qwest.title)
		end
		# assert that completed qwests appear on index
		for qwest <- completed_qwests do
    	assert String.contains?(content, qwest.title)
		end 
	end

	test "renders new.html", %{conn: conn} do
		# create view content
		changeset = Qwest.changeset(%Qwest{}) 
		repeat_options = Repeat.select_map()

		# render view content
		content = render_to_string(QwestView, "new.html", conn: conn, changeset: changeset, repeat_options: repeat_options)

		assert String.contains?(content, "New Qwest") 
	end

	test "renders edit.html", %{conn: conn} do
		# create view content
		qwest = @valid_incomplete_qwest_1
		changeset = Qwest.changeset(qwest) 
		repeat_options = Repeat.select_map()

		# render view content
		content = render_to_string(QwestView, "edit.html", conn: conn, changeset: changeset, qwest: qwest, repeat_options: repeat_options)

		assert String.contains?(content, "Edit Qwest") 
	end

	test "renders show.html", %{conn: conn} do
		# create view content
		qwest = @valid_incomplete_qwest_1
		changeset = Qwest.changeset(qwest) 
		
		# render view content
		content = render_to_string(QwestView, "show.html", conn: conn, changeset: changeset, qwest: qwest)

		assert String.contains?(content, "Show Qwest") 
	end
end