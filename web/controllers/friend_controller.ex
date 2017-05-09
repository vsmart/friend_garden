defmodule FriendGarden.FriendController do
  use FriendGarden.Web, :controller
  use Timex

  alias FriendGarden.Friend

  def index(conn, _params) do
    friends = Repo.all(Friend)
    friends = update_all_friend_health(friends)
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

  defp update_all_friend_health(friends) do
    Enum.map(friends, fn friend ->
      friend = %{ friend | :health => calculate_friend_health(friend) }
    end)
  end

  # must return a # between 0 and 100
  defp calculate_friend_health(friend) do
    IO.inspect friend.watered_at
    days_since_last_watered = Timex.diff(Timex.today, (friend.watered_at |> Timex.to_date), :days)
    IO.inspect days_since_last_watered
    IO.inspect friend.watering_interval

    #health = days_since_last_watered / friend[:watering_interval]
    health = 2
    if health > 1 do
      50
    else
      1 - health
    end
  end
end
