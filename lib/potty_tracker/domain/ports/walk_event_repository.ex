defmodule PottyTracker.Domain.Ports.WalkEventRepository do
  @moduledoc """
  Port interface for walk event persistence operations.
  This defines the contract that any repository implementation must follow.
  """

  alias PottyTracker.Domain.Entities.WalkEvent

  @type t :: module()

  @doc """
  Saves a walk event to the repository.
  """
  @callback save(WalkEvent.t()) :: {:ok, WalkEvent.t()} | {:error, String.t()}

  @doc """
  Finds a walk event by its ID.
  """
  @callback find_by_id(String.t()) :: {:ok, WalkEvent.t()} | {:error, String.t()}

  @doc """
  Finds all walk events with optional filtering options.
  """
  @callback find_all(keyword()) :: {:ok, [WalkEvent.t()]} | {:error, String.t()}

  @doc """
  Deletes a walk event by its ID.
  """
  @callback delete(String.t()) :: :ok | {:error, String.t()}

  @doc """
  Checks if a walk event exists by its ID.
  """
  @callback exists?(String.t()) :: boolean()

  @doc """
  Returns the total count of walk events.
  """
  @callback count() :: integer()

  @doc """
  Deletes all walk events (useful for testing).
  """
  @callback delete_all() :: :ok | {:error, String.t()}
end
