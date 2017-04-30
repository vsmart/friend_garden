defmodule FriendGarden.FriendTest do
  use FriendGarden.ModelCase

  alias FriendGarden.Friend

  @valid_attrs %{name: "some content", watered_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, watering_interval: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Friend.changeset(%Friend{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Friend.changeset(%Friend{}, @invalid_attrs)
    refute changeset.valid?
  end
end
