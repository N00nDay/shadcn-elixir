defmodule ShadcnElixir.Components.Toggle do
  @moduledoc """
  Toggle — a port of shadcn/ui's [Toggle](https://ui.shadcn.com/docs/components/toggle).

  A two-state button. Pressed state is tracked with `data-state`/`aria-pressed`,
  toggled client-side via `Phoenix.LiveView.JS`.
  """
  use Phoenix.Component

  import ShadcnElixir.Variants
  alias Phoenix.LiveView.JS

  @variants %{
    base:
      "inline-flex items-center justify-center gap-2 rounded-md text-sm font-medium " <>
        "hover:bg-muted hover:text-muted-foreground disabled:pointer-events-none " <>
        "disabled:opacity-50 data-[state=on]:bg-accent data-[state=on]:text-accent-foreground " <>
        "[&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 [&_svg]:shrink-0 " <>
        "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] " <>
        "outline-none transition-[color,box-shadow] aria-invalid:ring-destructive/20 " <>
        "dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive whitespace-nowrap",
    variants: %{
      variant: %{
        "default" => "bg-transparent",
        "outline" =>
          "border border-input bg-transparent shadow-xs hover:bg-accent hover:text-accent-foreground"
      },
      size: %{
        "default" => "h-9 px-2 min-w-9",
        "sm" => "h-8 px-1.5 min-w-8",
        "lg" => "h-10 px-2.5 min-w-10"
      }
    },
    default_variants: %{variant: "default", size: "default"}
  }

  @doc """
  Renders a toggle.

  ## Examples

      <.toggle>Bold</.toggle>
      <.toggle variant="outline" pressed>Italic</.toggle>
  """
  attr(:variant, :string, default: nil, values: [nil, "default", "outline"])
  attr(:size, :string, default: nil, values: [nil, "default", "sm", "lg"])
  attr(:pressed, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def toggle(assigns) do
    assigns =
      assign(
        assigns,
        :class,
        variant(@variants, variant: assigns.variant, size: assigns.size, class: assigns.class)
      )

    ~H"""
    <button
      type="button"
      aria-pressed={to_string(@pressed)}
      data-state={if @pressed, do: "on", else: "off"}
      data-slot="toggle"
      phx-click={toggle_pressed()}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc false
  def toggle_variants(opts \\ []), do: variant(@variants, opts)

  @doc false
  def toggle_pressed do
    %JS{}
    |> JS.toggle_attribute({"data-state", "on", "off"})
    |> JS.toggle_attribute({"aria-pressed", "true", "false"})
  end
end
