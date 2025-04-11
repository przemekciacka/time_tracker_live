defmodule TimeTrackerLive.Timer.TimeEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "time_entries" do
    field :description, :string
    field :start_time, :integer
    field :end_time, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def new_entry_changeset(time_entry, attrs) do
    time_entry
    |> cast(attrs, [:description, :start_time])
    |> validate_required([:start_time])
  end
end
