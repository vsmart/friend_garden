defmodule FriendGarden.Repo.Migrations.CreateFriend do
  use Ecto.Migration

  def change do
    create table(:friends) do
      add :name, :string
      add :watering_interval, :integer
      add :watered_at, :utc_datetime

      timestamps()
    end

  end
end
