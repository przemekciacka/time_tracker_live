defmodule TimeTrackerLiveWeb.DashboardLive do
  use TimeTrackerLiveWeb, :live_view

  def mount(_params, _session, socket) do
    enabled = false
    {:ok, assign(socket, enabled: enabled)}
  end

  def handle_event("toggle", _params, socket) do
    {:noreply, assign(socket, enabled: !socket.assigns.enabled)}
  end
end
