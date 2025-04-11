defmodule TimeTrackerLiveWeb.TimerLive do
  use TimeTrackerLiveWeb, :live_view
  alias TimeTrackerLive.Timer

  def mount(_params, _session, socket) do
    time_entries = Timer.get_finished()
    current = Timer.get_current()
    start_time = current && current.start_time || nil

    socket =
      socket
      |> assign(:current, current)
      |> assign(:start_time, start_time)
      |> assign(:time_entries, time_entries)

    {:ok, socket}
  end

  def handle_event("toggle_timer", %{"description"=>description}, %{assigns: %{current: nil}} = socket) do
    current_time = DateTime.utc_now() |> DateTime.to_unix()

    socket = Timer.create_time_entry(%{start_time: current_time, description: description})
             |> case do
               {:ok, time_entry} -> assign(socket, current: time_entry, start_time: time_entry.start_time)
               {:error, _} -> socket
             end

    {:noreply, socket}
  end

  def handle_event("toggle_timer", _, %{assigns: %{current: current}} = socket) do
    Timer.finish_time_entry(current)
    time_entries = Timer.get_finished()
    {:noreply, assign(socket, %{current: nil, start_time: nil, time_entries: time_entries})}
  end

  def handle_event("update_description", %{"description"=>description}, %{assigns: %{current: current}} = socket) do
    Timer.update_description(current, description)
    {:noreply, socket}
  end

  def handle_event("delete_time_entry", %{"id"=>id}, socket) do
    Timer.delete_time_entry(id)
    time_entries = Timer.get_finished()
    {:noreply, assign(socket, time_entries: time_entries)}
  end
end
