defmodule PottyTrackerWeb.PageController do
  use PottyTrackerWeb, :controller

  def home(conn, _params) do
    json(conn, %{message: "Welcome to PottyTracker API", version: "1.0.0"})
  end
end
