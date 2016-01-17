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

  # Changesets

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

  # Queries

  def owned(user) do
    from q in assoc(user, :qwests),
      select: q
  end

  def uncompleted(query) do
    from q in query,
      where: q.completed == false
  end
end
