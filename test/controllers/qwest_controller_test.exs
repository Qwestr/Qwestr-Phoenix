defmodule Qwestr.QwestControllerTest do
  use Qwestr.ConnCase

  alias Qwestr.Qwest

  @valid_attrs %{title: "New Qwest"}
  @invalid_attrs %{}

  @valid_update_completed_attrs %{completed: true}

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
    # check that each qwest_path requires user authentication
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
    # setup qwests
    user_qwest = insert_qwest(user, title: "user qwest")
    other_qwest = insert_qwest(insert_user(username: "other"), title: "another qwest")
    # test connection
    conn = get conn, qwest_path(conn, :index)
    # check that connection contains proper qwest data for the user
    assert html_response(conn, 200) =~ ~r/Listing qwests/ 
    assert String.contains?(conn.resp_body, user_qwest.title) 
    # check that the connection does not contain qwest data for other qwests
    refute String.contains?(conn.resp_body, other_qwest.title)
  end

  @tag :logged_in
  test "creates user qwest and redirects", %{conn: conn, user: user} do
    # test connection
    conn = post conn, qwest_path(conn, :create), qwest: @valid_attrs 
    # check that the connection was redirected to index
    assert redirected_to(conn) == qwest_path(conn, :index)
    # check that the qwest has been created and assigned to the logged in user
    assert Repo.get_by!(Qwest, @valid_attrs).user_id == user.id
  end

  @tag :logged_in
  test "does not create qwest and renders errors when invalid", %{conn: conn} do
    # get the count of qwests before trying to create one
    count_before = qwest_count(Qwest)
    # attempt to create the qwest
    conn = post conn, qwest_path(conn, :create), qwest: @invalid_attrs 
    # check that the response contains the correct error message
    assert html_response(conn, 200) =~ "check the errors"
    # check that new new qwest was created
    assert qwest_count(Qwest) == count_before
  end

  @tag :logged_in
  test "authorizes actions against access by other users", %{user: owner, conn: conn} do
    # setup qwest and non-owner user
    qwest = insert_qwest(owner, @valid_attrs) 
    non_owner = insert_user(username: "hackr") 
    # assign non_owner to user
    conn = assign(conn, :current_user, non_owner)
    # check that no results are returned for the non-owner user
    assert_raise Ecto.NoResultsError, fn -> 
      get(conn, qwest_path(conn, :show, qwest))
    end
    assert_raise Ecto.NoResultsError, fn ->
      get(conn, qwest_path(conn, :edit, qwest)) 
    end
    assert_raise Ecto.NoResultsError, fn ->
      put(conn, qwest_path(conn, :update, qwest, qwest: @valid_attrs))
    end
    assert_raise Ecto.NoResultsError, fn ->
      delete(conn, qwest_path(conn, :delete, qwest)) 
    end
  end

  @tag :logged_in
  test "completes a qwest and redirects", %{user: owner, conn: conn} do
    # setup qwest
    qwest_to_complete = insert_qwest(owner, @valid_attrs)
    # complete the qwest
    conn = put conn, qwest_path(conn, :complete), qwest: qwest_to_complete
    # check that the connection was redirected to index
    assert redirected_to(conn) == qwest_path(conn, :index)
    # check that the index does not contain data for the completed qwest
    refute String.contains?(conn.resp_body, qwest_to_complete.title)
  end

  @tag :logged_in
  test "restart a completed qwest and redirect", %{conn: conn} do
    assert true
  end

  # Private Methods

  defp qwest_count(query) do 
    Repo.one(from v in query, select: count(v.id))
  end

  defp qwest_complete_count(query) do 
    Repo.one(from v in query, select: count(v.id))
  end
end
