defmodule TimeTrackerLiveWeb.PageController do
  use TimeTrackerLiveWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
