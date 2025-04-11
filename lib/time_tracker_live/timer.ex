defmodule TimeTrackerLive.Timer do
  @moduledoc """
  The Timer context.
  """

  import Ecto.Query, warn: false
  alias TimeTrackerLive.Repo

  alias TimeTrackerLive.Timer.TimeEntry

  @doc """
  Returns time entry for the current timer if it exists.
  If no entry is found, it returns nil.

  ## Examples

      iex> get_current()
      %TimeEntry{}

      iex> get_current()
      nil
  """
  def get_current do
    TimeEntry
    |> where([t], not is_nil(t.start_time))
    |> where([t], is_nil(t.end_time))
    |> Repo.one
  end

  def get_finished do
    TimeEntry
    |> where([t], not is_nil(t.end_time))
    |> Repo.all()
  end

  @doc """
  Creates a new time entry if no timer is currently running.
  If a timer is already running, it returns an error.

  ## Examples

      iex> create_time_entry(%{description: "Test", start_time: 1234567890})
      {:ok, %TimeEntry{}}

      iex> create_time_entry(%{description: "Test"})
      {:error, "A timer is already running"}
  """
  def create_time_entry(attrs \\ %{}) do
    case get_current() do
      nil ->
        %TimeEntry{}
        |> TimeEntry.new_entry_changeset(attrs)
        |> Repo.insert()

      _ ->
        {:error, "A timer is already running"}
    end
  end

  @doc """
  Finishes the current time entry by setting the end_time to the current time.

  ## Examples

      iex> finish_time_entry(%TimeEntry{start_time: 1234567890})
      {:ok, %TimeEntry{}}
  """
  def finish_time_entry(time_entry) do
    time_entry
    |> Ecto.Changeset.change(end_time: DateTime.utc_now() |> DateTime.to_unix())
    |> Repo.update()
  end

  def update_description(time_entry, description) do
    time_entry
    |> Ecto.Changeset.change(description: description)
    |> Repo.update()
  end
end
