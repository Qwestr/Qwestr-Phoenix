defmodule Qwestr.Qwest do
  use Qwestr.Web, :model

  schema "qwests" do
    field :title, :string
    field :completed, :boolean, default: false
    belongs_to :user, Qwestr.User

    timestamps
  end

  @required_fields ~w(title)
  @optional_fields ~w()

  @completed_fields ~w(completed)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def complete_changeset(model) do
    model
    |> cast(%{completed: true}, @completed_fields, [])
  end
end
