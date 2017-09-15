defmodule FriendGarden.FriendController do
  use FriendGarden.Web, :controller
  use Timex
  alias Addict.Helper

  plug Addict.Plugs.Authenticated
  alias FriendGarden.Friend

  def index(conn, _params) do
    user = Addict.Helper.current_user(conn)
    friends = Repo.all(from f in Friend, where: f.user_id == ^user.id)
    friends = update_all_friend_health(friends)
    csrf_token =  Phoenix.Controller.get_csrf_token
    render(conn, "index.html", friends: friends, csrf_token: csrf_token)
  end

  def new(conn, _params) do
    changeset = Friend.changeset(%Friend{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"friend" => friend_params}) do
    current_user = get_session(conn, :current_user)
    friend_params = Map.put(friend_params, "user_id", current_user.id)
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
      %{ friend | :health => calculate_friend_health(friend) }
    end)
  end

  defp calculate_friend_health(friend) do
    last_watered_time = convert_timestamp_to_timex(friend.watered_at)
    days_since_last_watered = Timex.diff(Timex.today, (last_watered_time |> Timex.to_date), :days)

    health = days_since_last_watered / friend.watering_interval
    if health > 1 do
      10
    else
      (1 - health) * 100
    end
  end

  defp convert_timestamp_to_timex(ecto_time) do
    ecto_time
    |> Ecto.DateTime.dump
    |> elem(1)
    |> Timex.DateTime.Helpers.construct("Etc/UTC")
  end
end
