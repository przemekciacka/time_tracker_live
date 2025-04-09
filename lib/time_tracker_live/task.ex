defmodule TimeTrackerLive.Task do
  use GenServer

  # Client

  def start_link(initial_tasks \\ []) do
    GenServer.start_link(__MODULE__, initial_tasks, name: __MODULE__)
  end

  def current_task() do
    GenServer.call(__MODULE__, :current_task)
  end

  def start_task(name) do
    GenServer.call(__MODULE__, {:start_task, name})
  end

  def stop_task do
    GenServer.call(__MODULE__, :stop_task)
  end

  def all_tasks do
    GenServer.call(__MODULE__, :all_tasks)
  end

  def update_name(name) do
    GenServer.call(__MODULE__, {:update_name, name})
  end

  # Server

  def init(initial_tasks) when is_list(initial_tasks) do
    {:ok, initial_tasks}
  end

  def init(_) do
    {:ok, []}
  end

  def handle_call(:current_task, _, state) do
    current_task = Enum.find(state, fn task -> task.end_time == nil end)
    {:reply, current_task, state}
  end

  def handle_call({:start_task, name}, _, state) do
    task = %{
      name: name,
      start_time: System.system_time(:millisecond),
      end_time: nil
    }
    {:reply, task, [task | state]}
  end

  def handle_call(:stop_task, _, state) do
    current_index = Enum.find_index(state, fn task -> task.end_time == nil end)
    current_task = Enum.at(state, current_index)
    current_task = Map.put(current_task, :end_time, System.system_time(:millisecond))
    new_state = List.replace_at(state, current_index, current_task)
    {:reply, current_task, new_state}
  end

  def handle_call(:all_tasks, _, state) do
    finished = Enum.filter(state, fn task -> task.end_time != nil end)
    {:reply, finished, state}
  end

  def handle_call({:update_name, name}, _, state) do
    current_index = Enum.find_index(state, fn task -> task.end_time == nil end)
    current_task = Enum.at(state, current_index)
    current_task = Map.put(current_task, :name, name)
    new_state = List.replace_at(state, current_index, current_task)
    {:reply, current_task, new_state}
  end
end
