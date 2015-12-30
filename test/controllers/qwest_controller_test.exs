defmodule Qwestr.QwestControllerTest do
  use Qwestr.ConnCase

  alias Qwestr.Qwest
  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, qwest_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing qwests"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, qwest_path(conn, :new)
    assert html_response(conn, 200) =~ "New qwest"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, qwest_path(conn, :create), qwest: @valid_attrs
    assert redirected_to(conn) == qwest_path(conn, :index)
    assert Repo.get_by(Qwest, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, qwest_path(conn, :create), qwest: @invalid_attrs
    assert html_response(conn, 200) =~ "New qwest"
  end

  test "shows chosen resource", %{conn: conn} do
    qwest = Repo.insert! %Qwest{}
    conn = get conn, qwest_path(conn, :show, qwest)
    assert html_response(conn, 200) =~ "Show qwest"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, qwest_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    qwest = Repo.insert! %Qwest{}
    conn = get conn, qwest_path(conn, :edit, qwest)
    assert html_response(conn, 200) =~ "Edit qwest"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    qwest = Repo.insert! %Qwest{}
    conn = put conn, qwest_path(conn, :update, qwest), qwest: @valid_attrs
    assert redirected_to(conn) == qwest_path(conn, :show, qwest)
    assert Repo.get_by(Qwest, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    qwest = Repo.insert! %Qwest{}
    conn = put conn, qwest_path(conn, :update, qwest), qwest: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit qwest"
  end

  test "deletes chosen resource", %{conn: conn} do
    qwest = Repo.insert! %Qwest{}
    conn = delete conn, qwest_path(conn, :delete, qwest)
    assert redirected_to(conn) == qwest_path(conn, :index)
    refute Repo.get(Qwest, qwest.id)
  end
end
