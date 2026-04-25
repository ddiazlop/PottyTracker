defmodule PottyTrackerWeb.WalkEventController do
  use PottyTrackerWeb, :controller

  alias PottyTracker.Domain.Services.WalkTrackerService
  alias PottyTracker.Infrastructure.Repositories.EctoWalkEventRepository

  action_fallback(PottyTrackerWeb.FallbackController)

  def index(conn, params) do
    limit = Map.get(params, "limit", "50") |> String.to_integer()
    order_by = Map.get(params, "order_by", "timestamp_desc") |> String.to_atom()

    with {:ok, walk_events} <-
           WalkTrackerService.list_walks(EctoWalkEventRepository,
             limit: limit,
             order_by: order_by
           ) do
      render(conn, :index, walk_events: walk_events)
    end
  end

  def create(conn, %{"walk_event" => walk_event_params}) do
    with {:ok, walk_event} <-
           WalkTrackerService.record_walk(EctoWalkEventRepository, walk_event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", "/api/walk_events/#{walk_event.id}")
      |> render(:show, walk_event: walk_event)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, walk_event} <- WalkTrackerService.get_walk(EctoWalkEventRepository, id) do
      render(conn, :show, walk_event: walk_event)
    end
  end

  def update(conn, %{"id" => id, "walk_event" => walk_event_params}) do
    with {:ok, walk_event} <-
           WalkTrackerService.update_walk(EctoWalkEventRepository, id, walk_event_params) do
      render(conn, :show, walk_event: walk_event)
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- WalkTrackerService.delete_walk(EctoWalkEventRepository, id) do
      send_resp(conn, :no_content, "")
    end
  end

  def stats(conn, _params) do
    with {:ok, stats} <- WalkTrackerService.calculate_stats(EctoWalkEventRepository) do
      json(conn, stats)
    end
  end
end
