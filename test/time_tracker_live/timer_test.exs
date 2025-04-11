defmodule TimeTrackerLive.TimerTest do
  use TimeTrackerLive.DataCase

  alias TimeTrackerLive.Timer

  describe "time_entries" do
    alias TimeTrackerLive.Timer.TimeEntry

    import TimeTrackerLive.TimerFixtures

    @invalid_attrs %{description: nil, start_time: nil, end_time: nil}

    test "list_time_entries/0 returns all time_entries" do
      time_entry = time_entry_fixture()
      assert Timer.list_time_entries() == [time_entry]
    end

    test "get_time_entry!/1 returns the time_entry with given id" do
      time_entry = time_entry_fixture()
      assert Timer.get_time_entry!(time_entry.id) == time_entry
    end

    test "create_time_entry/1 with valid data creates a time_entry" do
      valid_attrs = %{description: "some description", start_time: 42, end_time: 42}

      assert {:ok, %TimeEntry{} = time_entry} = Timer.create_time_entry(valid_attrs)
      assert time_entry.description == "some description"
      assert time_entry.start_time == 42
      assert time_entry.end_time == 42
    end

    test "create_time_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Timer.create_time_entry(@invalid_attrs)
    end

    test "update_time_entry/2 with valid data updates the time_entry" do
      time_entry = time_entry_fixture()
      update_attrs = %{description: "some updated description", start_time: 43, end_time: 43}

      assert {:ok, %TimeEntry{} = time_entry} = Timer.update_time_entry(time_entry, update_attrs)
      assert time_entry.description == "some updated description"
      assert time_entry.start_time == 43
      assert time_entry.end_time == 43
    end

    test "update_time_entry/2 with invalid data returns error changeset" do
      time_entry = time_entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Timer.update_time_entry(time_entry, @invalid_attrs)
      assert time_entry == Timer.get_time_entry!(time_entry.id)
    end

    test "delete_time_entry/1 deletes the time_entry" do
      time_entry = time_entry_fixture()
      assert {:ok, %TimeEntry{}} = Timer.delete_time_entry(time_entry)
      assert_raise Ecto.NoResultsError, fn -> Timer.get_time_entry!(time_entry.id) end
    end

    test "change_time_entry/1 returns a time_entry changeset" do
      time_entry = time_entry_fixture()
      assert %Ecto.Changeset{} = Timer.change_time_entry(time_entry)
    end
  end
end
