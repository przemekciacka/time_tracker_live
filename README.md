# Time Tracker Live (Phoenix LiveView)

A lightweight time tracker built as part of a creative microcycle project.
This is an experiment in building functional software over perfect code, using Phoenix LiveView in a fullstack way, with minimal JavaScript.

## 📦 Features (MVP)
- [x] Start/stop a timer
- [ ] Add a description to a task
- [ ] Show a list of completed entries
- [ ] Preserve timer state across browser sessions
- [ ] Sync between multiple open browser windows
- [ ] Session-level user differentiation (no login)

## 🔧 Under the Hood
- Phoenix LiveView (Elixir)
- GenServer for in-memory state
- PubSub for real-time sync
- `cookie` or `localStorage` for session ID

## 🎯 Development Goals
- Explore fullstack development in a functional paradigm
- Avoid premature optimization or visual polish
- Build iteratively from general to specific

## 🚀 How to Run

```bash
# Clone the project
git clone https://github.com/your-username/time_tracker_live.git
cd time_tracker_live

# Install dependencies
mix deps.get

# Start the Phoenix server
mix phx.server
```

Then visit [localhost:4000](http://localhost:4000) in your browser.