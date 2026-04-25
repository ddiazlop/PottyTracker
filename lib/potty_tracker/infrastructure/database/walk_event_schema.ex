defmodule PottyTracker.Infrastructure.Database.WalkEventSchema do
  @moduledoc """
  Ecto schema for walk events.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @timestamps_opts [type: :utc_datetime]

  schema "walk_events" do
    field(:timestamp, :utc_datetime)
    field(:duration_minutes, :integer)
    field(:pee_count, :integer, default: 0)
    field(:poop_count, :integer, default: 0)
    field(:notes, :string)

    timestamps()
  end

  @doc """
  Changeset for creating/updating walk events.
  """
  def changeset(walk_event, attrs) do
    walk_event
    |> cast(attrs, [:id, :timestamp, :duration_minutes, :pee_count, :poop_count, :notes])
    |> validate_required([:timestamp, :duration_minutes])
    |> validate_number(:duration_minutes, greater_than: 0)
    |> validate_number(:pee_count, greater_than_or_equal_to: 0)
    |> validate_number(:poop_count, greater_than_or_equal_to: 0)
    |> validate_length(:notes, max: 1000)
  end
end
