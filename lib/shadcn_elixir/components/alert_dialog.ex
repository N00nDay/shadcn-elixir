defmodule ShadcnElixir.Components.AlertDialog do
  @moduledoc """
  AlertDialog — a port of shadcn/ui's
  [Alert Dialog](https://ui.shadcn.com/docs/components/alert-dialog).

  A modal that interrupts the user with important content and expects a response.
  Unlike `Dialog`, clicking the overlay does not dismiss it.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.JS, only: [open_modal: 1, close_modal: 1]
  alias ShadcnElixir.Components.Button

  attr(:id, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def alert_dialog(assigns) do
    ~H"""
    <div id={@id} data-slot="alert-dialog" data-state="closed" class={cn(@class)} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def alert_dialog_trigger(assigns) do
    ~H"""
    <span data-slot="alert-dialog-trigger" phx-click={open_modal(@dialog)} class="contents" {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def alert_dialog_content(assigns) do
    ~H"""
    <div
      id={"#{@dialog}-overlay"}
      data-slot="alert-dialog-overlay"
      hidden
      class="fixed inset-0 z-50 bg-black/50 data-[state=open]:animate-in data-[state=open]:fade-in-0"
    >
    </div>
    <div
      id={"#{@dialog}-content"}
      role="alertdialog"
      aria-modal="true"
      data-slot="alert-dialog-content"
      hidden
      phx-window-keydown={close_modal(@dialog)}
      phx-key="escape"
      class={
        cn([
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
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def alert_dialog_header(assigns) do
    ~H"""
    <div
      data-slot="alert-dialog-header"
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

  def alert_dialog_footer(assigns) do
    ~H"""
    <div
      data-slot="alert-dialog-footer"
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

  def alert_dialog_title(assigns) do
    ~H"""
    <div data-slot="alert-dialog-title" class={cn(["text-lg font-semibold", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def alert_dialog_description(assigns) do
    ~H"""
    <div
      data-slot="alert-dialog-description"
      class={cn(["text-muted-foreground text-sm", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def alert_dialog_action(assigns) do
    ~H"""
    <button
      type="button"
      data-slot="alert-dialog-action"
      phx-click={close_modal(@dialog)}
      class={Button.button_variants(class: @class)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr(:dialog, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def alert_dialog_cancel(assigns) do
    ~H"""
    <button
      type="button"
      data-slot="alert-dialog-cancel"
      phx-click={close_modal(@dialog)}
      class={Button.button_variants(variant: "outline", class: @class)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end
end
