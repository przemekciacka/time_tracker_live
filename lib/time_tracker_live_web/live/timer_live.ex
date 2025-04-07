defmodule TimeTrackerLiveWeb.TimerLive do
  use TimeTrackerLiveWeb, :live_view

  def mount(_params, %{ "session_id" => session_id }, socket) do
    {:ok,
     socket
     |> assign(:session_id, session_id)
     |> assign(:running, false)
     |> assign(:seconds, 0)}
  end

  def handle_event("toggle_timer", _params, %{assigns: %{running: false}} = socket) do
    Process.send_after(self(), :tick, 1000);
    {:noreply, socket |> assign(:running, true)}
  end

  def handle_event("toggle_timer", _params, %{assigns: %{running: true}} = socket) do
    {:noreply, socket |> assign(:running, false)}
  end

  def handle_info(:tick, %{assigns: %{running: true}} = socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, socket |> assign(:seconds, socket.assigns.seconds + 1)}
  end

  def handle_info(:tick, socket) do
    {:noreply, socket}
  end
end
