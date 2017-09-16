defmodule FriendGarden.FriendView do
  use FriendGarden.Web, :view

  def now_string do
    DateTime.utc_now |> DateTime.to_string
  end
end
