defmodule FriendGarden.Friend do
  use FriendGarden.Web, :model

  schema "friends" do
    field :name, :string
    field :watering_interval, :integer
    field :watered_at, Ecto.DateTime
    field :health, :float, virtual: true
    field :user_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :watering_interval, :watered_at, :user_id])
    |> validate_required([:name, :watering_interval, :watered_at, :user_id])
  end
end
