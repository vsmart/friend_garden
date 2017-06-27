defmodule FriendGarden.FriendControllerTest do
  use FriendGarden.ConnCase

  alias FriendGarden.Friend
  @valid_attrs %{name: "some content", watered_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, watering_interval: 42, user_id: 1}
  @invalid_attrs %{}

  setup do
    user = Repo.insert!(%FriendGarden.User{})
    user = %{id: 147, email: nil}
    conn = Plug.Test. init_test_session(build_conn(), %{current_user: user})
    {:ok, [conn: conn]}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, friend_path(conn, :index)
    assert html_response(conn, 200)
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

  test "returns 302 on index if not logged in", %{conn: conn} do
    conn = remove_user(conn)
    conn = get conn, friend_path(conn, :index)
    assert html_response(conn, 302)
  end

  test "returns 302 on show if not logged in", %{conn: conn} do
    conn = remove_user(conn)
    friend = Repo.insert! %Friend{}
    conn = get conn, friend_path(conn, :show, friend)
    assert html_response(conn, 302)
  end

  test "returns 302 on edit if not logged in", %{conn: conn} do
    conn = remove_user(conn)
    friend = Repo.insert! %Friend{}
    conn = get conn, friend_path(conn, :edit, friend)
    assert html_response(conn, 302)
  end

  test "returns 302 on update if not logged in", %{conn: conn} do
    conn = remove_user(conn)
    friend = Repo.insert! %Friend{}
    conn = get conn, friend_path(conn, :update, friend)
    assert html_response(conn, 302)
  end

  test "returns 302 on create if not logged in", %{conn: conn} do
    conn = remove_user(conn)
    conn = get conn, friend_path(conn, :create)
    assert html_response(conn, 302)
  end

  test "returns 302 on delete if not logged in", %{conn: conn} do
    conn = remove_user(conn)
    friend = Repo.insert! %Friend{}
    conn = get conn, friend_path(conn, :delete, friend)
    assert html_response(conn, 302)
  end

  def remove_user(conn) do
    conn = conn
           |> fetch_session
           |> delete_session(:current_user)
           |> assign(:current_user, nil)
  end

end
