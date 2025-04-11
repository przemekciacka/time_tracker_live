defmodule TimeTrackerLive.Repo.Migrations.CreateTimeEntries do
  use Ecto.Migration

  def change do
    create table(:time_entries) do
      add :description, :string
      add :start_time, :integer, null: false
      add :end_time, :integer

      timestamps(type: :utc_datetime)
    end

    create index(:time_entries, [:id], unique: true, where: "end_time IS NULL", name: :only_one_open_entry)
  end
end
