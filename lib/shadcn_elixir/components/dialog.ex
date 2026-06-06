defmodule ShadcnElixir.Components.Dialog do
  @moduledoc """
  Dialog — a port of shadcn/ui's [Dialog](https://ui.shadcn.com/docs/components/dialog).

  Modal behavior (open/close, scroll-lock, focus, escape, click-outside) is handled
  with `Phoenix.LiveView.JS` and standard LiveView bindings — no extra JS runtime.

  Composed of `dialog/1`, `dialog_trigger/1`, `dialog_content/1`, `dialog_header/1`,
  `dialog_footer/1`, `dialog_title/1`, `dialog_description/1`, and `dialog_close/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.JS, only: [open_modal: 1, close_modal: 1]

  @doc """
  Renders a dialog. Requires an `id` shared by its trigger/content.

  ## Examples

      <.dialog id="edit">
        <.dialog_trigger dialog="edit"><.button>Edit</.button></.dialog_trigger>
        <.dialog_content dialog="edit">
          <.dialog_header>
            <.dialog_title>Edit profile</.dialog_title>
            <.dialog_description>Make changes here.</.dialog_description>
          </.dialog_header>
          <.dialog_footer><.button>Save</.button></.dialog_footer>
        </.dialog_content>
      </.dialog>
  """
  attr(:id, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dialog(assigns) do
    ~H"""
    <div id={@id} data-slot="dialog" data-state="closed" class={cn(@class)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dialog_trigger(assigns) do
    ~H"""
    <span data-slot="dialog-trigger" phx-click={open_modal(@dialog)} class="contents" {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:show_close, :boolean, default: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dialog_content(assigns) do
    ~H"""
    <div
      id={"#{@dialog}-overlay"}
      data-slot="dialog-overlay"
      data-state="closed"
      phx-click={close_modal(@dialog)}
      class="fixed inset-0 z-50 bg-black/50 data-[state=closed]:hidden data-[state=open]:animate-in data-[state=open]:fade-in-0"
    >
    </div>
    <div
      id={"#{@dialog}-content"}
      role="dialog"
      aria-modal="true"
      data-slot="dialog-content"
      data-state="closed"
      phx-window-keydown={close_modal(@dialog)}
      phx-key="escape"
      class={
        cn([
          "data-[state=closed]:hidden",
          "bg-background fixed top-[50%] left-[50%] z-50 grid w-full max-w-[calc(100%-2rem)]",
          "translate-x-[-50%] translate-y-[-50%] gap-4 rounded-lg border p-6 shadow-lg",
          "duration-200 sm:max-w-lg data-[state=open]:animate-in data-[state=open]:fade-in-0",
          "data-[state=open]:zoom-in-95",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
      <button
        :if={@show_close}
        type="button"
        phx-click={close_modal(@dialog)}
        aria-label="Close"
        class={
          "ring-offset-background focus:ring-ring absolute top-4 right-4 rounded-xs opacity-70 " <>
            "transition-opacity hover:opacity-100 focus:ring-2 focus:ring-offset-2 " <>
            "focus:outline-hidden disabled:pointer-events-none [&_svg]:pointer-events-none " <>
            "[&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4"
        }
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <path d="M18 6 6 18" /><path d="m6 6 12 12" />
        </svg>
        <span class="sr-only">Close</span>
      </button>
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dialog_header(assigns) do
    ~H"""
    <div
      data-slot="dialog-header"
      class={cn(["flex flex-col gap-2 text-center sm:text-left", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dialog_footer(assigns) do
    ~H"""
    <div
      data-slot="dialog-footer"
      class={cn(["flex flex-col-reverse gap-2 sm:flex-row sm:justify-end", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dialog_title(assigns) do
    ~H"""
    <div data-slot="dialog-title" class={cn(["text-lg leading-none font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dialog_description(assigns) do
    ~H"""
    <div data-slot="dialog-description" class={cn(["text-muted-foreground text-sm", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def dialog_close(assigns) do
    ~H"""
    <span data-slot="dialog-close" phx-click={close_modal(@dialog)} class="contents" {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end
end
