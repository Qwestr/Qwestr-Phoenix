defmodule Qwestr.QwestTest do
  use Qwestr.ModelCase

  alias Qwestr.Qwest

  @valid_attrs %{title: "My First Qwest"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Qwest.changeset(%Qwest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Qwest.changeset(%Qwest{}, @invalid_attrs)
    refute changeset.valid?
  end
end
