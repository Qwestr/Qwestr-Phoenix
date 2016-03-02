defmodule Qwestr.QwestTest do
  use Qwestr.ModelCase
  use Timex

  alias Qwestr.Qwest

  # Constants

  @one 1

  @valid_attrs %{title: "My First Qwest"}
  @valid_daily_attrs %{title: "My First Daily Qwest", repeat: :daily}
  @valid_weekly_attrs %{title: "My First Weekly Qwest", repeat: :weekly}
  @valid_monthly_attrs %{title: "My First Monthly Qwest", repeat: :monthly}
  @valid_yearly_attrs %{title: "My First Yearly Qwest", repeat: :yearly}
  
  @valid_daily_completed_attrs %{completed_at: datetime_before_current_date(-1, :days)}
  @valid_weekly_completed_attrs %{completed_at: datetime_before_current_date(-1, :weeks)}
  @valid_monthly_completed_attrs %{completed_at: datetime_before_current_date(-1, :months)}
  @valid_yearly_completed_attrs %{completed_at: datetime_before_current_date(-1, :years)}

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
    assert Enum.count(Repo.all(Qwest.owned(owner))) === @one
  end

  test "query for all active qwests owned by a user returns with valid set", %{user: owner} do
    # setup qwests
    insert_qwest(owner, @valid_attrs)
    insert_qwest(owner, @valid_daily_attrs)
    insert_qwest(owner, @valid_weekly_attrs)
    insert_qwest(owner, @valid_monthly_attrs)
    insert_qwest(owner, @valid_yearly_attrs)

    other_user = insert_user(username: "hackr")
    insert_qwest(other_user, @valid_attrs)
    insert_qwest(other_user, @valid_daily_attrs)
    insert_qwest(other_user, @valid_weekly_attrs)
    insert_qwest(other_user, @valid_monthly_attrs)
    insert_qwest(other_user, @valid_yearly_attrs)
    
    # test assertions
    assert Enum.count(Repo.all(Qwest.incomplete_for_user(owner, :never))) === @one
    assert Enum.count(Repo.all(Qwest.incomplete_for_user(owner, :daily))) === @one
    assert Enum.count(Repo.all(Qwest.incomplete_for_user(owner, :weekly))) === @one
    assert Enum.count(Repo.all(Qwest.incomplete_for_user(owner, :monthly))) === @one
    assert Enum.count(Repo.all(Qwest.incomplete_for_user(owner, :yearly))) === @one
  end

  test "query for all active qwests returns valid scheduled completed qwests", %{user: owner} do
    # setup qwests
    insert_qwest(owner, @valid_daily_attrs)
      |> complete_qwest(@valid_daily_completed_attrs)
    insert_qwest(owner, @valid_weekly_attrs)
      |> complete_qwest(@valid_weekly_completed_attrs)
    insert_qwest(owner, @valid_monthly_attrs)
      |> complete_qwest(@valid_monthly_completed_attrs)
    insert_qwest(owner, @valid_yearly_attrs)
      |> complete_qwest(@valid_yearly_completed_attrs)
    
    # test assertions
    assert Enum.count(Repo.all(Qwest.incomplete_for_user(owner, :daily))) === @one
    assert Enum.count(Repo.all(Qwest.incomplete_for_user(owner, :weekly))) === @one
    assert Enum.count(Repo.all(Qwest.incomplete_for_user(owner, :monthly))) === @one
    assert Enum.count(Repo.all(Qwest.incomplete_for_user(owner, :yearly))) === @one
  end

  test "query for all completed qwests owned by a user returns with valid set", %{user: owner} do
    # setup qwests
    insert_qwest(owner, @valid_attrs)
      |> complete_qwest
    insert_qwest(owner, @valid_daily_attrs)
      |> complete_qwest
    insert_qwest(owner, @valid_weekly_attrs)
      |> complete_qwest
    insert_qwest(owner, @valid_monthly_attrs)
      |> complete_qwest
    insert_qwest(owner, @valid_yearly_attrs)
      |> complete_qwest

    other_user = insert_user(username: "hackr")
    insert_qwest(other_user, @valid_attrs)
      |> complete_qwest
    insert_qwest(other_user, @valid_daily_attrs)
      |> complete_qwest
    insert_qwest(other_user, @valid_weekly_attrs)
      |> complete_qwest
    insert_qwest(other_user, @valid_monthly_attrs)
      |> complete_qwest
    insert_qwest(other_user, @valid_yearly_attrs)
      |> complete_qwest
    
    # test assertions
    assert Enum.count(Repo.all(Qwest.completed_for_user(owner, :never))) === @one
    assert Enum.count(Repo.all(Qwest.completed_for_user(owner, :daily))) === @one
    assert Enum.count(Repo.all(Qwest.completed_for_user(owner, :weekly))) === @one
    assert Enum.count(Repo.all(Qwest.completed_for_user(owner, :monthly))) === @one
    assert Enum.count(Repo.all(Qwest.completed_for_user(owner, :yearly))) === @one
  end
end
