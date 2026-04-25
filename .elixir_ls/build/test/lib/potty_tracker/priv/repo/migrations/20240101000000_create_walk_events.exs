defmodule PottyTracker.Repo.Migrations.CreateWalkEvents do
  use Ecto.Migration

  def change do
    create table(:walk_events, primary_key: false) do
      add(:id, :string, primary_key: true)
      add(:timestamp, :utc_datetime, null: false)
      add(:duration_minutes, :integer, null: false)
      add(:pee_count, :integer, default: 0, null: false)
      add(:poop_count, :integer, default: 0, null: false)
      add(:notes, :text)

      timestamps()
    end

    create(index(:walk_events, [:timestamp]))
  end
end
