defmodule PottyTrackerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid HTTP responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PottyTrackerWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: PottyTrackerWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause handles errors returned by the domain services.
  def call(conn, {:error, message}) when is_binary(message) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: message})
  end

  # This clause handles not found errors.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "Not found"})
  end
end
