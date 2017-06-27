defmodule FriendGarden.Repo.Migrations.AddUserFieldToFriend do
  use Ecto.Migration

  def change do
    alter table(:friends) do
      add :user_id, :integer
    end
  end
end
