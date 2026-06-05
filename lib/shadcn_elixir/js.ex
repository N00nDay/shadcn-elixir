defmodule ShadcnElixir.JS do
  @moduledoc """
  Shared `Phoenix.LiveView.JS` command helpers for the interactive components
  (dialogs, popovers, menus, …).

  These run entirely client-side, so they work in both LiveView and dead/static views.
  Modal helpers use LiveView's built-in focus management (`focus_first/1`,
  `pop_focus/0`) and lock body scroll while open.
  """
  alias Phoenix.LiveView.JS

  @doc "Toggle an anchored layer (dropdown/popover/select content) open or closed."
  def toggle(js \\ %JS{}, id) do
    JS.toggle_attribute(js, {"data-state", "open", "closed"}, to: "##{id}")
    |> JS.toggle(to: "##{id}-content")
  end

  @doc "Open an anchored layer."
  def open(js \\ %JS{}, id) do
    js
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}")
    |> JS.show(to: "##{id}-content")
  end

  @doc "Close an anchored layer."
  def close(js \\ %JS{}, id) do
    js
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}")
    |> JS.hide(to: "##{id}-content")
  end

  @doc "Open a modal overlay (dialog/sheet/drawer): show, lock scroll, focus first control."
  def open_modal(js \\ %JS{}, id) do
    js
    |> JS.set_attribute({"data-state", "open"}, to: "##{id}")
    |> JS.show(to: "##{id}-overlay")
    |> JS.show(to: "##{id}-content")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  @doc "Close a modal overlay: hide, restore scroll, restore focus."
  def close_modal(js \\ %JS{}, id) do
    js
    |> JS.set_attribute({"data-state", "closed"}, to: "##{id}")
    |> JS.hide(to: "##{id}-overlay")
    |> JS.hide(to: "##{id}-content")
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end
end
