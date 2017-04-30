defmodule FriendGarden.PageController do
  use FriendGarden.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
