defmodule TimeTrackerLiveWeb.TimerLive do
  use TimeTrackerLiveWeb, :live_view

  def mount(_params, _session, socket) do
    tasks = TimeTrackerLive.Task.all_tasks()
    current_task = TimeTrackerLive.Task.current_task()
    start_time = current_task && current_task.start_time || nil

    {:ok,
     socket
     |> assign(:tasks, tasks)
     |> assign(:start_time, start_time)}
  end

  def handle_event("toggle_timer", %{"name" => name}, %{assigns: %{start_time: nil}} = socket) do
    task = TimeTrackerLive.Task.start_task(name)
    tasks = TimeTrackerLive.Task.all_tasks()
    {:noreply, socket |> assign(:start_time, task.start_time) |> assign(:tasks, tasks)}
  end

  def handle_event("toggle_timer", _params, socket) do
    TimeTrackerLive.Task.stop_task()
    all_tasks = TimeTrackerLive.Task.all_tasks()
    {:noreply, socket |> assign(:start_time, nil) |> assign(:tasks, all_tasks)}
  end

  def handle_event("update_name", %{"name" => name}, %{assigns: %{start_time: start_time}} = socket) when not is_nil(start_time) do
    TimeTrackerLive.Task.update_name(name)
    {:noreply, socket}
  end

  def handle_event("update_name", _, socket) do
    {:noreply, socket}
  end
end
