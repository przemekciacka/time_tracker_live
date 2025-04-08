defmodule TimeTrackerLiveWeb.TimerLive do
  use TimeTrackerLiveWeb, :live_view

  def mount(_params, _session, socket) do
    current_task = TimeTrackerLive.Tasks.current_task()
    running = current_task != nil
    seconds = current_task
              |> case do
                nil -> 0
                task -> System.system_time(:second) - task.start_time
              end

    if connected?(socket) && running do
      Process.send_after(self(), :tick, 1000)
    end

    {:ok,
     socket
     |> assign(:current_task, current_task)
     |> assign(:running, running)
     |> assign(:seconds, seconds)
     |> assign(:finished_tasks, TimeTrackerLive.Tasks.finished_tasks())}
  end

  def handle_event("toggle_timer", _params, %{assigns: %{running: false}} = socket) do
    task = TimeTrackerLive.Tasks.new_task("Example task")
    Process.send_after(self(), :tick, 1000);
    {:noreply, socket |> assign(:running, true) |> assign(:current_task, task) |> assign(:seconds, 0)}
  end

  def handle_event("toggle_timer", _params, %{assigns: %{running: true}} = socket) do
    TimeTrackerLive.Tasks.finish_current_task()
    finished_tasks = TimeTrackerLive.Tasks.finished_tasks()
    {:noreply, socket |> assign(:running, false) |> assign(:finished_tasks, finished_tasks) |> assign(:current_task, nil) |> assign(:seconds, 0)}
  end

  def handle_info(:tick, %{assigns: %{running: true}} = socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, socket |> assign(:seconds, socket.assigns.seconds + 1)}
  end

  def handle_info(:tick, socket) do
    {:noreply, socket}
  end
end
