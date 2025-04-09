# Project Notes — Time Tracker Live

Notes, questions and observations collected during development.
This is a living document, not a polished artifact.

## 🔍 Questions to revisit

Things I'm curious about but not investigating right now.

- Why `<.button>` in HEEx has this `.` (dot) at the beginning?
- How do I define my own reusable components in Phoenix LiveView?
- Why are LiveView templates (e.g. `timer_live.html.heex`) kept in the same directory as the LiveView module, while controller templates are placed in directory named after controller (e.g. `page_html/`)?
- Is it possible to do optimistic UI with LiveView?
- What's the significant difference between function pattern matching vs. `if` conditional statement?
- Is it possible to call `handle_call` from within `handle_call` in GenServer? I faced with `process attempted to call itself` error.
- Would it be hard to make an optimistic UI? User clicks, timer start, it resets on failure.

## 🧠 Insights / Lessons Learned

- In LiveView modules, use `use MyAppWeb, :live_view` instead of `use Phoenix.LiveView`. This ensures shared components, layout, and helpers are available (e.g., `<.button>`).
- There are two approaches to handling LiveView messages:
    1. Using pattern matching in function heads for `handle_info` and `handle_event`
    2. Using conditional statements (`if`) inside a single function
- ⚠️ You can't set cookies when using LiveView. It operates over websocket and doesn't have access to request/response.
- GenServer keeps its state until application is running.
- Any change to supervisor tree in `application.ex` requires application restart.
- I'm used to TypeScript and miss some of the intellisens code features