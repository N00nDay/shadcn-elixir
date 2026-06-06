defmodule ShadcnElixir.JS do
  @moduledoc """
  Shared `Phoenix.LiveView.JS` command helpers for the interactive components
  (dialogs, popovers, menus, …).

  Visibility is driven by a `data-state` attribute (`open`/`closed`) plus a
  `data-[state=closed]:hidden` class on the toggled element — rather than `JS.show/hide`,
  which Tailwind v4's `[hidden] { display: none !important }` preflight rule defeats.
  Modal helpers also lock body scroll and use LiveView's built-in focus management
  (`focus_first/1`, `pop_focus/0`).

  These run entirely client-side, so they work in both LiveView and dead/static views.
  """
  alias Phoenix.LiveView.JS

  @doc "Toggle an anchored layer (dropdown/popover/menu content) open or closed."
  def toggle(js \\ %JS{}, id) do
    js
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{id}")
    |> JS.toggle_attribute({"data-state", "open", "closed"}, to: "##{id}-content")
  end

  @doc "Open an anchored layer."
  def open(js \\ %JS{}, id) do
    js
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}")
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-content")
  end

  @doc "Close an anchored layer."
  def close(js \\ %JS{}, id) do
    js
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}")
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-content")
  end

  @doc "Open a modal overlay (dialog/sheet/drawer): reveal, lock scroll, focus first control."
  def open_modal(js \\ %JS{}, id) do
    js
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}")
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-overlay")
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}-content")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  @doc "Close a modal overlay: hide, restore scroll, restore focus."
  def close_modal(js \\ %JS{}, id) do
    js
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}")
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-overlay")
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}-content")
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end
end
