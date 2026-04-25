defmodule PottyTracker.Domain.Services.WalkTrackerService do
  @moduledoc """
  Domain service for managing walk events and tracking statistics.
  """

  alias PottyTracker.Domain.Entities.WalkEvent
  alias PottyTracker.Domain.Ports.WalkEventRepository

  @type stats :: %{
          total_walks: integer(),
          total_duration: integer(),
          average_duration: float(),
          total_pee: integer(),
          total_poop: integer(),
          average_pee_per_walk: float(),
          average_poop_per_walk: float(),
          walks_with_activities: integer()
        }

  @doc """
  Records a new walk event.
  """
  @spec record_walk(WalkEventRepository.t(), map()) :: {:ok, WalkEvent.t()} | {:error, String.t()}
  def record_walk(repository, attrs) do
    with {:ok, walk_event} <- WalkEvent.new(attrs) do
      WalkEventRepository.save(repository, walk_event)
    end
  end

  @doc """
  Retrieves a walk event by ID.
  """
  @spec get_walk(WalkEventRepository.t(), String.t()) ::
          {:ok, WalkEvent.t()} | {:error, String.t()}
  def get_walk(repository, id) do
    WalkEventRepository.find_by_id(repository, id)
  end

  @doc """
  Updates an existing walk event.
  """
  @spec update_walk(WalkEventRepository.t(), String.t(), map()) ::
          {:ok, WalkEvent.t()} | {:error, String.t()}
  def update_walk(repository, id, attrs) do
    with {:ok, existing_walk} <- get_walk(repository, id),
         {:ok, updated_walk} <- WalkEvent.update(existing_walk, attrs) do
      WalkEventRepository.save(repository, updated_walk)
    end
  end

  @doc """
  Deletes a walk event.
  """
  @spec delete_walk(WalkEventRepository.t(), String.t()) :: :ok | {:error, String.t()}
  def delete_walk(repository, id) do
    WalkEventRepository.delete(repository, id)
  end

  @doc """
  Lists all walk events with optional filtering.
  """
  @spec list_walks(WalkEventRepository.t(), keyword()) ::
          {:ok, [WalkEvent.t()]} | {:error, String.t()}
  def list_walks(repository, opts \\ []) do
    WalkEventRepository.find_all(repository, opts)
  end

  @doc """
  Calculates statistics from walk events.
  """
  @spec calculate_stats(WalkEventRepository.t()) :: {:ok, stats()} | {:error, String.t()}
  def calculate_stats(repository) do
    with {:ok, walks} <- list_walks(repository) do
      stats = %{
        total_walks: length(walks),
        total_duration: Enum.sum(Enum.map(walks, & &1.duration_minutes)),
        average_duration: calculate_average(walks, & &1.duration_minutes),
        total_pee: Enum.sum(Enum.map(walks, & &1.pee_count)),
        total_poop: Enum.sum(Enum.map(walks, & &1.poop_count)),
        average_pee_per_walk: calculate_average(walks, & &1.pee_count),
        average_poop_per_walk: calculate_average(walks, & &1.poop_count),
        walks_with_activities: Enum.count(walks, &WalkEvent.has_activities?/1)
      }

      {:ok, stats}
    end
  end

  @doc """
  Gets walks within a date range.
  """
  @spec get_walks_in_range(WalkEventRepository.t(), DateTime.t(), DateTime.t()) ::
          {:ok, [WalkEvent.t()]} | {:error, String.t()}
  def get_walks_in_range(repository, start_date, end_date) do
    with {:ok, walks} <- list_walks(repository) do
      filtered_walks =
        Enum.filter(walks, fn walk ->
          DateTime.compare(walk.timestamp, start_date) in [:gt, :eq] and
            DateTime.compare(walk.timestamp, end_date) in [:lt, :eq]
        end)

      {:ok, filtered_walks}
    end
  end

  # Private helper functions

  defp calculate_average([], _), do: 0.0

  defp calculate_average(walks, field_fn) do
    total = Enum.sum(Enum.map(walks, field_fn))
    total / length(walks)
  end
end
