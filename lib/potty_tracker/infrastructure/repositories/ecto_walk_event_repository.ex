defmodule PottyTracker.Infrastructure.Repositories.EctoWalkEventRepository do
  @moduledoc """
  Ecto-based implementation of the WalkEventRepository port.
  """

  @behaviour PottyTracker.Domain.Ports.WalkEventRepository

  import Ecto.Query
  alias PottyTracker.Repo
  alias PottyTracker.Domain.Entities.WalkEvent
  alias PottyTracker.Infrastructure.Database.WalkEventSchema

  @impl true
  def save(%WalkEvent{} = walk_event) do
    attrs = %{
      id: walk_event.id,
      timestamp: walk_event.timestamp,
      duration_minutes: walk_event.duration_minutes,
      pee_count: walk_event.pee_count,
      poop_count: walk_event.poop_count,
      notes: walk_event.notes
    }

    case Repo.get(WalkEventSchema, walk_event.id) do
      nil ->
        %WalkEventSchema{}
        |> WalkEventSchema.changeset(attrs)
        |> Repo.insert()
        |> handle_result()

      existing ->
        existing
        |> WalkEventSchema.changeset(attrs)
        |> Repo.update()
        |> handle_result()
    end
  end

  @impl true
  def find_by_id(id) do
    case Repo.get(WalkEventSchema, id) do
      nil -> {:error, "Walk event not found"}
      schema -> {:ok, schema_to_entity(schema)}
    end
  end

  @impl true
  def find_all(opts \\ []) do
    query = from(w in WalkEventSchema)

    query =
      case Keyword.get(opts, :order_by) do
        :timestamp_desc -> order_by(query, [w], desc: w.timestamp)
        :timestamp_asc -> order_by(query, [w], asc: w.timestamp)
        _ -> order_by(query, [w], desc: w.inserted_at)
      end

    query =
      case Keyword.get(opts, :limit) do
        limit when is_integer(limit) -> limit(query, ^limit)
        _ -> query
      end

    case Repo.all(query) do
      schemas -> {:ok, Enum.map(schemas, &schema_to_entity/1)}
    end
  rescue
    e -> {:error, "Database error: #{inspect(e)}"}
  end

  @impl true
  def delete(id) do
    case Repo.get(WalkEventSchema, id) do
      nil ->
        {:error, "Walk event not found"}

      schema ->
        case Repo.delete(schema) do
          {:ok, _} -> :ok
          {:error, changeset} -> {:error, "Failed to delete: #{inspect(changeset.errors)}"}
        end
    end
  end

  @impl true
  def exists?(id) do
    Repo.exists?(from(w in WalkEventSchema, where: w.id == ^id))
  end

  @impl true
  def count do
    Repo.aggregate(WalkEventSchema, :count, :id)
  end

  @impl true
  def delete_all do
    case Repo.delete_all(WalkEventSchema) do
      {count, _} -> {:ok, count}
      _ -> {:error, "Failed to delete all walk events"}
    end
  end

  # Private helper functions

  defp handle_result({:ok, schema}), do: {:ok, schema_to_entity(schema)}

  defp handle_result({:error, changeset}),
    do: {:error, "Validation failed: #{inspect(changeset.errors)}"}

  defp schema_to_entity(%WalkEventSchema{} = schema) do
    %WalkEvent{
      id: schema.id,
      timestamp: schema.timestamp,
      duration_minutes: schema.duration_minutes,
      pee_count: schema.pee_count,
      poop_count: schema.poop_count,
      notes: schema.notes
    }
  end
end
