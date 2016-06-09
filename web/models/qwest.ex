defmodule Qwestr.Qwest do
  use Qwestr.Web, :model
  use Timex

  alias Qwestr.Enums.Repeat
  alias Qwestr.User

  schema "qwests" do
    field :title, :string
    field :completed, :boolean, default: false
    field :repeat, Repeat.Values, default: :never
    field :completed_at, Timex.Ecto.DateTime
    belongs_to :user, User

    timestamps
  end

  @required_fields ~w(title repeat)
  @optional_fields ~w(completed completed_at)

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

  def complete_changeset(model, params \\ %{}) do
    default_params = %{completed: true, completed_at: DateTime.now}
    
    model
    |> cast(Map.merge(default_params, params), @required_fields, @optional_fields)
  end

  def restart_changeset(model, params \\ %{}) do
    default_params = %{completed: false, completed_at: nil}

    model
    |> cast(Map.merge(default_params, params), @required_fields, @optional_fields)
  end

  # Queries

  def owned(user) do
    from q in assoc(user, :qwests),
      select: q
  end

  def active(query, repeat) when repeat == :daily do
    from q in query,
      where: q.repeat == ^repeat
        and (
          q.completed == false
            or q.completed_at <= datetime_add(^Ecto.DateTime.utc, -1, "day")
        ) 
  end
  def active(query, repeat) when repeat == :weekly do
    from q in query,
      where: q.repeat == ^repeat
        and (
          q.completed == false
            or q.completed_at <= datetime_add(^Ecto.DateTime.utc, -1, "week")
        ) 
  end
  def active(query, repeat) when repeat == :monthly do
    from q in query,
      where: q.repeat == ^repeat
        and (
          q.completed == false
            or q.completed_at <= datetime_add(^Ecto.DateTime.utc, -1, "month")
        ) 
  end
  def active(query, repeat) when repeat == :yearly do
    from q in query,
      where: q.repeat == ^repeat
        and (
          q.completed == false
            or q.completed_at <= datetime_add(^Ecto.DateTime.utc, -1, "year")
        ) 
  end
  def active(query, repeat) do
    from q in query,
      where: q.repeat == ^repeat
        and q.completed == false
  end

  def active_for_user(user, repeat) do
    owned(user)
    |> active(repeat)
  end

  def completed(query, repeat) when repeat == :daily do
    from q in query,
      where: q.repeat == ^repeat
        and (
          q.completed == true
            and q.completed_at > datetime_add(^Ecto.DateTime.utc, -1, "day")
        ) 
  end
  def completed(query, repeat) when repeat == :weekly do
    from q in query,
      where: q.repeat == ^repeat
        and (
          q.completed == true
            and q.completed_at > datetime_add(^Ecto.DateTime.utc, -1, "week")
        ) 
  end
  def completed(query, repeat) when repeat == :monthly do
    from q in query,
      where: q.repeat == ^repeat
        and (
          q.completed == true
            and q.completed_at > datetime_add(^Ecto.DateTime.utc, -1, "month")
        ) 
  end
  def completed(query, repeat) when repeat == :yearly do
    from q in query,
      where: q.repeat == ^repeat
        and (
          q.completed == true
            and q.completed_at > datetime_add(^Ecto.DateTime.utc, -1, "year")
        ) 
  end
  def completed(query, repeat) do
    from q in query,
      where: q.repeat == ^repeat
        and q.completed == true
  end

  def completed_for_user(user, repeat) do
    owned(user)
    |> completed(repeat)
  end
end
