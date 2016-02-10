defmodule Qwestr.Qwest do
  use Qwestr.Web, :model

  alias Qwestr.Enums.Repeat

  schema "qwests" do
    field :title, :string
    field :completed, :boolean, default: false
    field :repeat, Repeat.Values, default: :never
    belongs_to :user, Qwestr.User

    timestamps
  end

  @required_fields ~w(title repeat)
  @optional_fields ~w(completed)

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
    |> cast(%{completed: true}, @required_fields, @optional_fields)
  end

  def restart_changeset(model) do
    model
    |> cast(%{completed: false}, @required_fields, @optional_fields)
  end

  # Queries

  def owned(user) do
    from q in assoc(user, :qwests),
      select: q
  end

  def incomplete(query) do
    from q in query,
      where: q.completed == false
  end

  def completed(query) do
    from q in query,
      where: q.completed == true
  end
end
