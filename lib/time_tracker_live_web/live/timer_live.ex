defmodule TimeTrackerLiveWeb.TimerLive do
  use TimeTrackerLiveWeb, :live_view

  @topic "timer"

  def mount(_params, _session, socket) do
    TimeTrackerLiveWeb.Endpoint.subscribe(@topic)

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
    TimeTrackerLiveWeb.Endpoint.broadcast_from(self(), @topic, "task_started", task);
    {:noreply, socket |> assign(:start_time, task.start_time) |> assign(:tasks, tasks)}
  end

  def handle_event("toggle_timer", _params, socket) do
    TimeTrackerLive.Task.stop_task()
    all_tasks = TimeTrackerLive.Task.all_tasks()
    TimeTrackerLiveWeb.Endpoint.broadcast_from(self(), @topic, "task_stopped", %{})
    {:noreply, socket |> assign(:start_time, nil) |> assign(:tasks, all_tasks)}
  end

  def handle_event("update_name", %{"name" => name}, %{assigns: %{start_time: start_time}} = socket) when not is_nil(start_time) do
    TimeTrackerLive.Task.update_name(name)
    {:noreply, socket}
  end

  def handle_event("update_name", _, socket) do
    {:noreply, socket}
  end

  def handle_info(%{topic: @topic, event: "task_started", payload: payload}, socket) do
    tasks = TimeTrackerLive.Task.all_tasks()
    start_time = payload.start_time

    {:noreply, socket
     |> assign(:tasks, tasks)
     |> assign(:start_time, start_time)}
  end

  def handle_info(%{topic: @topic, event: "task_stopped"}, socket) do
    tasks = TimeTrackerLive.Task.all_tasks()
    {:noreply, socket |> assign(:tasks, tasks) |> assign(:start_time, nil)}
  end

  def handle_info(_msg, socket) do
    {:noreply, socket}
  end
end
