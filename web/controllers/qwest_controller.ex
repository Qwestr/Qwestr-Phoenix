defmodule Qwestr.QwestController do
  use Qwestr.Web, :controller

  alias Qwestr.Qwest

  plug :scrub_params, "qwest" when action in [:create, :update]

  def index(conn, _params) do
    qwests = Repo.all(Qwest)
    render(conn, "index.html", qwests: qwests)
  end

  def new(conn, _params) do
    changeset = Qwest.changeset(%Qwest{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"qwest" => qwest_params}) do
    changeset = Qwest.changeset(%Qwest{}, qwest_params)

    case Repo.insert(changeset) do
      {:ok, _qwest} ->
        conn
        |> put_flash(:info, "Qwest created successfully.")
        |> redirect(to: qwest_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    qwest = Repo.get!(Qwest, id)
    render(conn, "show.html", qwest: qwest)
  end

  def edit(conn, %{"id" => id}) do
    qwest = Repo.get!(Qwest, id)
    changeset = Qwest.changeset(qwest)
    render(conn, "edit.html", qwest: qwest, changeset: changeset)
  end

  def update(conn, %{"id" => id, "qwest" => qwest_params}) do
    qwest = Repo.get!(Qwest, id)
    changeset = Qwest.changeset(qwest, qwest_params)

    case Repo.update(changeset) do
      {:ok, qwest} ->
        conn
        |> put_flash(:info, "Qwest updated successfully.")
        |> redirect(to: qwest_path(conn, :show, qwest))
      {:error, changeset} ->
        render(conn, "edit.html", qwest: qwest, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    qwest = Repo.get!(Qwest, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(qwest)

    conn
    |> put_flash(:info, "Qwest deleted successfully.")
    |> redirect(to: qwest_path(conn, :index))
  end
end
