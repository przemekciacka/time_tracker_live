defmodule TimeTrackerLiveWeb.PageController do
  use TimeTrackerLiveWeb, :controller
  import Phoenix.LiveView.Controller


  def home(conn, _params) do
    session_id = get_session(conn, :session_id) || "example_session_id"

    conn
    |> live_render(TimeTrackerLiveWeb.TimerLive, session: %{ "session_id" => session_id })
  end
end
