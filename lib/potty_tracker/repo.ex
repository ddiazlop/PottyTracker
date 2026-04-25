defmodule PottyTracker.Repo do
  @moduledoc """
  Ecto repository for PottyTracker.
  """

  use Ecto.Repo,
    otp_app: :potty_tracker,
    adapter: Ecto.Adapters.Postgres
end
