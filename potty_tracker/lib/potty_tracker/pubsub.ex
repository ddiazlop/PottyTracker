defmodule PottyTracker.PubSub do
  @moduledoc """
  PubSub module for PottyTracker.
  """
  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {Phoenix.PubSub, :start_link, [__MODULE__, []]},
      type: :supervisor
    }
  end
end
