defmodule TimeTrackerLive.Tasks do
  use GenServer

  def start_link(initial_tasks \\ []) do
    GenServer.start_link(__MODULE__, initial_tasks, name: __MODULE__)
  end

  def current_task() do
    GenServer.call(__MODULE__, :current_task)
  end

  def new_task(name) do
    GenServer.call(__MODULE__, {:new_task, name})
  end

  def finish_current_task() do
    GenServer.call(__MODULE__, :finish_current_task)
  end

  def finished_tasks() do
    GenServer.call(__MODULE__, :finished_tasks)
  end

  def init(initial_tasks) when is_list(initial_tasks) do
    {:ok, initial_tasks}
  end

  def init(_) do
    {:ok, []}
  end

  def handle_call(:current_task, _from, tasks) do
    Enum.find(tasks, fn task -> task[:end_time] == nil end)
    |> case do
      nil -> {:reply, nil, tasks}
      task -> {:reply, task, tasks}
    end
  end

  def handle_call({:new_task, name}, _from, tasks) do
    new_task = %{start_time: System.system_time(:second), end_time: nil, name: name}
    {:reply, new_task, [new_task | tasks]}
  end

  def handle_call(:finish_current_task, _from, tasks) do
    current = Enum.find(tasks, fn task -> task[:end_time] == nil end)
    finished_task = Map.put(current, :end_time, System.system_time(:second))
    unfinished_index = Enum.find_index(tasks, fn task -> task[:end_time] == nil end)
    tasks = List.replace_at(tasks, unfinished_index, finished_task)
    {:reply, finished_task, tasks}
  end

  def handle_call(:finished_tasks, _from, tasks) do
    finished_tasks = Enum.filter(tasks, fn task -> task[:end_time] != nil end)
    {:reply, finished_tasks, tasks}
  end
end
