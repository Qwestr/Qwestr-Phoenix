defmodule Qwestr.QwestControllerTest do
  use Qwestr.ConnCase

  alias Qwestr.Qwest

  @valid_attrs %{title: "New Qwest"}
  @invalid_attrs %{}

  setup config do
    if config[:logged_in] do
      user = insert_user(username: "testr")
      conn = assign(conn(), :current_user, user) 
      {:ok, conn: conn, user: user}
    else
      {:ok, conn: conn()}
    end
  end

  test "requires user authentication on all actions", %{conn: conn} do 
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

  @tag :logged_in
  test "lists all user's qwests on index", %{conn: conn, user: user} do
    user_qwest = insert_qwest(user, title: "user qwest")
    other_qwest = insert_qwest(insert_user(username: "other"), title: "another qwest")
    conn = get conn, qwest_path(conn, :index)
    
    assert html_response(conn, 200) =~ ~r/Listing qwests/ 
    assert String.contains?(conn.resp_body, user_qwest.title) 

    refute String.contains?(conn.resp_body, other_qwest.title)
  end

  @tag :logged_in
  test "creates user qwest and redirects", %{conn: conn, user: user} do
    conn = post conn, qwest_path(conn, :create), qwest: @valid_attrs 

    assert redirected_to(conn) == qwest_path(conn, :index)
    assert Repo.get_by!(Qwest, @valid_attrs).user_id == user.id
  end

  @tag :logged_in
  test "does not create qwest and renders errors when invalid", %{conn: conn} do
    count_before = qwest_count(Qwest)
    conn = post conn, qwest_path(conn, :create), qwest: @invalid_attrs 

    assert html_response(conn, 200) =~ "check the errors"
    assert qwest_count(Qwest) == count_before
  end

  # Private Methods

  defp qwest_count(query) do 
    Repo.one(from v in query, select: count(v.id))
  end
end
