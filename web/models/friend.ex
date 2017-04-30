defmodule FriendGarden.Friend do
  use FriendGarden.Web, :model

  schema "friends" do
    field :name, :string
    field :watering_interval, :integer
    field :watered_at, Ecto.DateTime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :watering_interval, :watered_at])
    |> validate_required([:name, :watering_interval, :watered_at])
  end
end
