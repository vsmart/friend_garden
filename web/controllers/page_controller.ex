defmodule FriendGarden.PageController do
  use FriendGarden.Web, :controller
  alias Addict.Helper

  def index(conn, _params) do
    if Addict.Helper.is_logged_in(conn) do
      redirect conn, to: "/friends"
    else
      render conn, "index.html"
    end
  end

end
