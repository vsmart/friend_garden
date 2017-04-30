defmodule FriendGarden.FriendController do
  use FriendGarden.Web, :controller

  alias FriendGarden.Friend

  def index(conn, _params) do
    friends = Repo.all(Friend)
    render(conn, "index.html", friends: friends)
  end

  def new(conn, _params) do
    changeset = Friend.changeset(%Friend{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"friend" => friend_params}) do
    changeset = Friend.changeset(%Friend{}, friend_params)

    case Repo.insert(changeset) do
      {:ok, _friend} ->
        conn
        |> put_flash(:info, "Friend created successfully.")
        |> redirect(to: friend_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    friend = Repo.get!(Friend, id)
    render(conn, "show.html", friend: friend)
  end

  def edit(conn, %{"id" => id}) do
    friend = Repo.get!(Friend, id)
    changeset = Friend.changeset(friend)
    render(conn, "edit.html", friend: friend, changeset: changeset)
  end

  def update(conn, %{"id" => id, "friend" => friend_params}) do
    friend = Repo.get!(Friend, id)
    changeset = Friend.changeset(friend, friend_params)

    case Repo.update(changeset) do
      {:ok, friend} ->
        conn
        |> put_flash(:info, "Friend updated successfully.")
        |> redirect(to: friend_path(conn, :show, friend))
      {:error, changeset} ->
        render(conn, "edit.html", friend: friend, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    friend = Repo.get!(Friend, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(friend)

    conn
    |> put_flash(:info, "Friend deleted successfully.")
    |> redirect(to: friend_path(conn, :index))
  end
end
