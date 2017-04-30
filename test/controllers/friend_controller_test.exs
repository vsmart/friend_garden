defmodule FriendGarden.FriendControllerTest do
  use FriendGarden.ConnCase

  alias FriendGarden.Friend
  @valid_attrs %{name: "some content", watered_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, watering_interval: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, friend_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing friends"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, friend_path(conn, :new)
    assert html_response(conn, 200) =~ "New friend"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, friend_path(conn, :create), friend: @valid_attrs
    assert redirected_to(conn) == friend_path(conn, :index)
    assert Repo.get_by(Friend, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, friend_path(conn, :create), friend: @invalid_attrs
    assert html_response(conn, 200) =~ "New friend"
  end

  test "shows chosen resource", %{conn: conn} do
    friend = Repo.insert! %Friend{}
    conn = get conn, friend_path(conn, :show, friend)
    assert html_response(conn, 200) =~ "Show friend"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, friend_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    friend = Repo.insert! %Friend{}
    conn = get conn, friend_path(conn, :edit, friend)
    assert html_response(conn, 200) =~ "Edit friend"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    friend = Repo.insert! %Friend{}
    conn = put conn, friend_path(conn, :update, friend), friend: @valid_attrs
    assert redirected_to(conn) == friend_path(conn, :show, friend)
    assert Repo.get_by(Friend, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    friend = Repo.insert! %Friend{}
    conn = put conn, friend_path(conn, :update, friend), friend: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit friend"
  end

  test "deletes chosen resource", %{conn: conn} do
    friend = Repo.insert! %Friend{}
    conn = delete conn, friend_path(conn, :delete, friend)
    assert redirected_to(conn) == friend_path(conn, :index)
    refute Repo.get(Friend, friend.id)
  end
end
