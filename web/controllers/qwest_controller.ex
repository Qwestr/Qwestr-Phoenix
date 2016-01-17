defmodule Qwestr.QwestController do
  use Qwestr.Web, :controller

  alias Qwestr.Qwest

  plug :scrub_params, "qwest" when action in [:create, :update]

  def action(conn, _) do 
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    # list all uncompleted qwests in the index
    qwests = Repo.all(uncompleted_qwests(user)) 
    render(conn, "index.html", qwests: qwests)
  end

  def new(conn, _params, user) do 
    changeset =
      user
      |> build(:qwests)
      |> Qwest.changeset()
    
    render(conn, "new.html", changeset: changeset) 
  end

  def create(conn, %{"qwest" => qwest_params}, user) do 
    changeset =
      user
      |> build(:qwests)
      |> Qwest.changeset(qwest_params)

    case Repo.insert(changeset) do
      {:ok, _qwest} ->
        conn
        |> put_flash(:info, "Qwest created successfully!")
        |> redirect(to: qwest_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do 
    qwest = Repo.get!(user_qwests(user), id) 
    render(conn, "show.html", qwest: qwest)
  end

  def edit(conn, %{"id" => id}, user) do
    qwest = Repo.get!(user_qwests(user), id)
    changeset = Qwest.changeset(qwest)
    render(conn, "edit.html", qwest: qwest, changeset: changeset)
  end

  def update(conn, %{"id" => id, "qwest" => qwest_params}, user) do 
    qwest = Repo.get!(user_qwests(user), id)
    changeset = Qwest.changeset(qwest, qwest_params)

    case Repo.update(changeset) do
      {:ok, qwest} ->
        conn
        |> put_flash(:info, "Qwest updated successfully!")
        |> redirect(to: qwest_path(conn, :show, qwest))
      {:error, changeset} ->
        render(conn, "edit.html", qwest: qwest, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do 
    qwest = Repo.get!(user_qwests(user), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(qwest)

    conn
    |> put_flash(:info, "Qwest deleted successfully!")
    |> redirect(to: qwest_path(conn, :index))
  end

  def complete(conn, %{"id" => id}, user) do
    # create complete changeset
    changeset = 
      Repo.get!(user_qwests(user), id) 
      |> Qwest.complete_changeset()

    # update Repo and act accordingly
    case Repo.update(changeset) do
      {:ok, qwest} ->
        conn
        |> put_flash(:info, "Qwest completed successfully!")
        |> redirect(to: qwest_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Qwest cannot be completed")
        |> redirect(to: qwest_path(conn, :index))
    end
  end

  # Private Methods
  
  defp user_qwests(user) do 
    Qwest.owned(user)
  end

  defp uncompleted_qwests(user) do 
    Qwest.owned(user)
    |> Qwest.uncompleted()
  end
end
