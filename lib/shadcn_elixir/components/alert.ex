defmodule ShadcnElixir.Components.Alert do
  @moduledoc """
  Alert — a port of shadcn/ui's [Alert](https://ui.shadcn.com/docs/components/alert).

  Composed of `alert/1`, `alert_title/1`, and `alert_description/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Variants

  @variants %{
    base:
      "relative w-full rounded-lg border px-4 py-3 text-sm grid " <>
        "has-[>svg]:grid-cols-[calc(var(--spacing)*4)_1fr] grid-cols-[0_1fr] " <>
        "has-[>svg]:gap-x-3 gap-y-0.5 items-start [&>svg]:size-4 [&>svg]:translate-y-0.5 " <>
        "[&>svg]:text-current",
    variants: %{
      variant: %{
        "default" => "bg-card text-card-foreground",
        "destructive" =>
          "text-destructive bg-card [&>svg]:text-current " <>
            "*:data-[slot=alert-description]:text-destructive/90"
      }
    },
    default_variants: %{variant: "default"}
  }

  @doc """
  Renders an alert.

  ## Examples

      <.alert>
        <.alert_title>Heads up!</.alert_title>
        <.alert_description>You can add components to your app.</.alert_description>
      </.alert>
  """
  attr(:variant, :string, default: nil, values: [nil, "default", "destructive"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def alert(assigns) do
    assigns =
      assign(assigns, :class, variant(@variants, variant: assigns.variant, class: assigns.class))

    ~H"""
    <div role="alert" data-slot="alert" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def alert_title(assigns) do
    ~H"""
    <div
      data-slot="alert-title"
      class={cn(["col-start-2 line-clamp-1 min-h-4 font-medium tracking-tight", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def alert_description(assigns) do
    ~H"""
    <div
      data-slot="alert-description"
      class={
        cn([
          "text-muted-foreground col-start-2 grid justify-items-start gap-1 text-sm",
          "[&_p]:leading-relaxed",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
