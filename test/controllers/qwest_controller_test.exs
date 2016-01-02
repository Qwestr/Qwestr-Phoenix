defmodule Qwestr.QwestControllerTest do
  use Qwestr.ConnCase

  # alias Qwestr.Qwest
  # @valid_attrs %{title: "New Qwest"}
  # @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "requires user authentication on all actions" do 

    Enum.each([
      get(conn, qwest_path(conn, :index)),
      get(conn, qwest_path(conn, :show, "123")), 
      get(conn, qwest_path(conn, :edit, "123")), 
      put(conn, qwest_path(conn, :update, "123", %{})), 
      post(conn, qwest_path(conn, :create, %{})), 
      delete(conn, qwest_path(conn, :delete, "123")),
    ], 
      fn conn ->
        assert html_response(conn, 302) 
        assert conn.halted
      end
    ) 
  end
end
