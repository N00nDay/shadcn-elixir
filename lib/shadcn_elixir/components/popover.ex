defmodule ShadcnElixir.Components.Popover do
  @moduledoc """
  Popover — a port of shadcn/ui's
  [Popover](https://ui.shadcn.com/docs/components/popover).

  Toggled with `Phoenix.LiveView.JS`; dismissed on outside click via `phx-click-away`.
  Positioned with CSS relative to the trigger. Composed of `popover/1`,
  `popover_trigger/1`, and `popover_content/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.JS, only: [toggle: 1, close: 1]

  attr(:id, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def popover(assigns) do
    ~H"""
    <div
      id={@id}
      data-slot="popover"
      data-state="closed"
      class={cn(["relative inline-block", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:popover, :string, required: true)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def popover_trigger(assigns) do
    ~H"""
    <span data-slot="popover-trigger" phx-click={toggle(@popover)} class="contents" {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  attr(:popover, :string, required: true)
  attr(:align, :string, default: "center", values: ["start", "center", "end"])

  attr(:label, :string,
    default: "Popover",
    doc: "Accessible name for the popover dialog (role=\"dialog\" requires a name)."
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def popover_content(assigns) do
    ~H"""
    <div
      id={"#{@popover}-content"}
      role="dialog"
      aria-label={@label}
      data-slot="popover-content"
      data-align={@align}
      data-state="closed"
      phx-click-away={close(@popover)}
      phx-window-keydown={close(@popover)}
      phx-key="escape"
      class={
        cn([
          "data-[state=closed]:hidden",
          "bg-popover text-popover-foreground absolute top-full z-50 mt-2 w-72 origin-top",
          "rounded-md border p-4 shadow-md outline-hidden",
          "data-[state=open]:animate-in data-[state=open]:fade-in-0 data-[state=open]:zoom-in-95",
          align_class(@align),
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  defp align_class("start"), do: "left-0"
  defp align_class("end"), do: "right-0"
  defp align_class(_), do: "left-1/2 -translate-x-1/2"
end
