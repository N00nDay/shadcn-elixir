defmodule ShadcnElixir.Components.ButtonGroup do
  @moduledoc """
  ButtonGroup — a port of shadcn/ui's
  [Button Group](https://ui.shadcn.com/docs/components/button-group).

  Composed of `button_group/1`, `button_group_text/1`, and `button_group_separator/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Variants

  @variants %{
    base:
      "flex w-fit items-stretch has-[>[data-slot=button-group]]:gap-2 " <>
        "[&>*]:focus-visible:relative [&>*]:focus-visible:z-10 " <>
        "has-[select[aria-hidden=true]:last-child]:[&>[data-slot=select-trigger]:last-of-type]:rounded-r-md " <>
        "[&>[data-slot=select-trigger]:not([class*='w-'])]:w-fit [&>input]:flex-1",
    variants: %{
      orientation: %{
        # The `[&>*…]` rules square the *direct* children. A dropdown-menu/popover trigger
        # (split-button pattern) is wrapped in a `relative inline-block` div whose real
        # control is a `data-slot=button` inside a `display:contents` trigger span — so we
        # also reach through that wrapper to square the inner button at the group's seams.
        # (React/Radix needs none of this because `asChild` makes the button the direct
        # child; the port's wrapper div is the divergence.) Classes are written out in full
        # so Tailwind's source scanner emits them — do not build these via interpolation.
        "horizontal" =>
          "[&>*:not(:first-child)]:border-l-0 [&>*:not(:first-child)]:rounded-l-none " <>
            "[&>*:not(:last-child)]:rounded-r-none " <>
            "[&>[data-slot=dropdown-menu]:not(:first-child)>[data-slot=dropdown-menu-trigger]>[data-slot=button]]:rounded-l-none " <>
            "[&>[data-slot=dropdown-menu]:not(:first-child)>[data-slot=dropdown-menu-trigger]>[data-slot=button]]:border-l-0 " <>
            "[&>[data-slot=dropdown-menu]:not(:last-child)>[data-slot=dropdown-menu-trigger]>[data-slot=button]]:rounded-r-none " <>
            "[&>[data-slot=popover]:not(:first-child)>[data-slot=popover-trigger]>[data-slot=button]]:rounded-l-none " <>
            "[&>[data-slot=popover]:not(:first-child)>[data-slot=popover-trigger]>[data-slot=button]]:border-l-0 " <>
            "[&>[data-slot=popover]:not(:last-child)>[data-slot=popover-trigger]>[data-slot=button]]:rounded-r-none",
        "vertical" =>
          "flex-col [&>*:not(:first-child)]:border-t-0 [&>*:not(:first-child)]:rounded-t-none " <>
            "[&>*:not(:last-child)]:rounded-b-none " <>
            "[&>[data-slot=dropdown-menu]:not(:first-child)>[data-slot=dropdown-menu-trigger]>[data-slot=button]]:rounded-t-none " <>
            "[&>[data-slot=dropdown-menu]:not(:first-child)>[data-slot=dropdown-menu-trigger]>[data-slot=button]]:border-t-0 " <>
            "[&>[data-slot=dropdown-menu]:not(:last-child)>[data-slot=dropdown-menu-trigger]>[data-slot=button]]:rounded-b-none " <>
            "[&>[data-slot=popover]:not(:first-child)>[data-slot=popover-trigger]>[data-slot=button]]:rounded-t-none " <>
            "[&>[data-slot=popover]:not(:first-child)>[data-slot=popover-trigger]>[data-slot=button]]:border-t-0 " <>
            "[&>[data-slot=popover]:not(:last-child)>[data-slot=popover-trigger]>[data-slot=button]]:rounded-b-none"
      }
    },
    default_variants: %{orientation: "horizontal"}
  }

  @doc """
  Renders a button group.

  ## Examples

      <.button_group>
        <.button variant="outline">One</.button>
        <.button variant="outline">Two</.button>
      </.button_group>
  """
  attr(:orientation, :string, default: nil, values: [nil, "horizontal", "vertical"])
  attr(:label, :string, default: nil, doc: "Accessible name for the group (role=\"group\").")
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def button_group(assigns) do
    assigns =
      assign(
        assigns,
        :class,
        variant(@variants, orientation: assigns.orientation, class: assigns.class)
      )

    ~H"""
    <div role="group" aria-label={@label} data-slot="button-group" data-orientation={@orientation || "horizontal"} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def button_group_text(assigns) do
    ~H"""
    <div
      data-slot="button-group-text"
      class={
        cn([
          "bg-muted flex items-center gap-2 rounded-md border px-4 text-sm font-medium shadow-xs",
          "[&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4",
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

  def button_group_separator(assigns) do
    ~H"""
    <div
      role="separator"
      aria-orientation="vertical"
      data-orientation="vertical"
      data-slot="button-group-separator"
      class={
        cn([
          "bg-input relative !m-0 self-stretch w-px data-[orientation=vertical]:h-auto",
          @class
        ])
      }
      {@rest}
    />
    """
  end
end
