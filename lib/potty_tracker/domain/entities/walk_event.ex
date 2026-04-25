defmodule PottyTracker.Domain.Entities.WalkEvent do
  @moduledoc """
  Represents a walk event with pee/poop tracking information.
  """

  @type t :: %__MODULE__{
          id: String.t() | nil,
          timestamp: DateTime.t(),
          duration_minutes: integer(),
          pee_count: integer(),
          poop_count: integer(),
          notes: String.t() | nil
        }

  defstruct [:id, :timestamp, :duration_minutes, :pee_count, :poop_count, :notes]

  @doc """
  Creates a new WalkEvent with validation.
  """
  @spec new(map()) :: {:ok, t()} | {:error, String.t()}
  def new(attrs) do
    with {:ok, timestamp} <- validate_timestamp(attrs[:timestamp]),
         {:ok, duration} <- validate_duration(attrs[:duration_minutes]),
         {:ok, pee_count} <- validate_count(attrs[:pee_count]),
         {:ok, poop_count} <- validate_count(attrs[:poop_count]) do
      {:ok,
       %__MODULE__{
         id: attrs[:id] || generate_id(),
         timestamp: timestamp,
         duration_minutes: duration,
         pee_count: pee_count,
         poop_count: poop_count,
         notes: attrs[:notes]
       }}
    end
  end

  @doc """
  Updates an existing WalkEvent.
  """
  @spec update(t(), map()) :: {:ok, t()} | {:error, String.t()}
  def update(%__MODULE__{} = event, attrs) do
    new_attrs =
      Map.merge(
        %{
          id: event.id,
          timestamp: event.timestamp,
          duration_minutes: event.duration_minutes,
          pee_count: event.pee_count,
          poop_count: event.poop_count,
          notes: event.notes
        },
        attrs
      )

    new(new_attrs)
  end

  @doc """
  Calculates total activities (pee + poop) for the walk.
  """
  @spec total_activities(t()) :: integer()
  def total_activities(%__MODULE__{pee_count: pee, poop_count: poop}) do
    pee + poop
  end

  @doc """
  Checks if the walk had any activities.
  """
  @spec has_activities?(t()) :: boolean()
  def has_activities?(%__MODULE__{} = event) do
    total_activities(event) > 0
  end

  # Private validation functions

  defp validate_timestamp(nil), do: {:error, "timestamp is required"}
  defp validate_timestamp(%DateTime{} = dt), do: {:ok, dt}
  defp validate_timestamp(_), do: {:error, "timestamp must be a DateTime"}

  defp validate_duration(nil), do: {:error, "duration_minutes is required"}
  defp validate_duration(duration) when is_integer(duration) and duration > 0, do: {:ok, duration}
  defp validate_duration(_), do: {:error, "duration_minutes must be a positive integer"}

  defp validate_count(nil), do: {:ok, 0}
  defp validate_count(count) when is_integer(count) and count >= 0, do: {:ok, count}
  defp validate_count(_), do: {:error, "count must be a non-negative integer"}

  defp generate_id do
    :crypto.strong_rand_bytes(16) |> Base.encode16(case: :lower)
  end
end
