defmodule PottyTrackerTest do
  use ExUnit.Case
  doctest PottyTracker

  test "greets the world" do
    assert PottyTracker.hello() == :world
  end
end
