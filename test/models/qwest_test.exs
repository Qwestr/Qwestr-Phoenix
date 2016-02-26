defmodule Qwestr.QwestTest do
  use Qwestr.ModelCase

  alias Qwestr.Qwest

  # Constants

  @valid_attrs %{title: "My First Qwest"}
  @invalid_attrs %{}

  # Setup

  setup do
    user = insert_user(username: "testr")
    {:ok, user: user}
  end

  # Tests

  test "changeset with valid attributes" do
    changeset = Qwest.changeset(%Qwest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "complete changeset with valid attributes", %{user: owner} do
    # setup qwest and changeset
    qwest = insert_qwest(owner, @valid_attrs)
    complete_changeset = Qwest.complete_changeset(qwest)
    # test assertions
    assert complete_changeset.valid?
  end

  test "restart changeset with valid attributes", %{user: owner} do
    # setup qwest and changeset
    qwest = insert_qwest(owner, @valid_attrs)
    restart_changeset = Qwest.restart_changeset(qwest)
    # test assertions
    assert restart_changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Qwest.changeset(%Qwest{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "complete changeset with invalid attributes", %{user: owner} do
    # setup qwest and changeset
    qwest = insert_qwest(owner, @invalid_attrs)
    complete_changeset = Qwest.complete_changeset(qwest)
    # test assertions
    refute complete_changeset.valid?
  end

  test "restart changeset with invalid attributes", %{user: owner} do
    # setup qwest and changeset
    qwest = insert_qwest(owner, @invalid_attrs)
    restart_changeset = Qwest.restart_changeset(qwest)
    # test assertions
    refute restart_changeset.valid?
  end

  test "query for all qwests owned by a user returns with valid set", %{user: owner} do
    # setup qwests
    insert_qwest(owner, @valid_attrs)
    insert_qwest(insert_user(username: "hackr"), @valid_attrs)
    # test assertions
    assert Enum.count(Repo.all(Qwest.owned(owner))) === 1
  end
end
