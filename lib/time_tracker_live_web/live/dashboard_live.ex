defmodule TimeTrackerLiveWeb.DashboardLive do
  use TimeTrackerLiveWeb, :live_view

  def mount(_params, _session, socket) do
    enabled = false
    seconds = 0

    {:ok, assign(socket, enabled: enabled, seconds: seconds)}
  end

  def handle_event("toggle", _params, socket) do
    toggle_timer(socket.assigns.enabled, socket)
  end

  def handle_info(:tick, socket) do
    {:noreply, update(socket, :seconds, &(&1 + 1))}
  end

  defp toggle_timer(false, socket) do
    {:ok, tref} = :timer.send_interval(1000, self(), :tick)
    {:noreply, assign(socket, enabled: true, tref: tref)}
  end

  defp toggle_timer(true, socket) do
    :timer.cancel(socket.assigns.tref)
    {:noreply, assign(socket, enabled: false, tref: nil)}
  end
end
