defmodule PottyTrackerWeb.WalkEventJSON do
  alias PottyTracker.Domain.Entities.WalkEvent

  @doc """
  Renders a list of walk_events.
  """
  def index(%{walk_events: walk_events}) do
    %{data: for(walk_event <- walk_events, do: data(walk_event))}
  end

  @doc """
  Renders a single walk_event.
  """
  def show(%{walk_event: walk_event}) do
    %{data: data(walk_event)}
  end

  defp data(%WalkEvent{} = walk_event) do
    %{
      id: walk_event.id,
      timestamp: walk_event.timestamp,
      duration_minutes: walk_event.duration_minutes,
      pee_count: walk_event.pee_count,
      poop_count: walk_event.poop_count,
      notes: walk_event.notes
    }
  end
end
