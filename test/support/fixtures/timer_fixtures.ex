defmodule TimeTrackerLive.TimerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeTrackerLive.Timer` context.
  """

  @doc """
  Generate a time_entry.
  """
  def time_entry_fixture(attrs \\ %{}) do
    {:ok, time_entry} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_time: 42,
        start_time: 42
      })
      |> TimeTrackerLive.Timer.create_time_entry()

    time_entry
  end
end
