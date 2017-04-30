defmodule FriendGarden.FriendController do
  use FriendGarden.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", friends: %{}
  end
end
