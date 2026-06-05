defmodule ShadcnElixir.Components.Badge do
  @moduledoc """
  Badge — a port of shadcn/ui's [Badge](https://ui.shadcn.com/docs/components/badge).

  Renders a `<span>`, or an `<a>` (via `Phoenix.Component.link/1`) when a link
  attribute (`href`/`navigate`/`patch`) is present.
  """
  use Phoenix.Component

  import ShadcnElixir.Variants

  @variants %{
    base:
      "inline-flex items-center justify-center rounded-md border px-2 py-0.5 text-xs " <>
        "font-medium w-fit whitespace-nowrap shrink-0 [&>svg]:size-3 gap-1 " <>
        "[&>svg]:pointer-events-none focus-visible:border-ring focus-visible:ring-ring/50 " <>
        "focus-visible:ring-[3px] aria-invalid:ring-destructive/20 " <>
        "dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive " <>
        "transition-[color,box-shadow] overflow-hidden",
    variants: %{
      variant: %{
        "default" =>
          "border-transparent bg-primary text-primary-foreground [a&]:hover:bg-primary/90",
        "secondary" =>
          "border-transparent bg-secondary text-secondary-foreground [a&]:hover:bg-secondary/90",
        "destructive" =>
          "border-transparent bg-destructive text-white [a&]:hover:bg-destructive/90 " <>
            "focus-visible:ring-destructive/20 dark:focus-visible:ring-destructive/40 " <>
            "dark:bg-destructive/60",
        "outline" => "text-foreground [a&]:hover:bg-accent [a&]:hover:text-accent-foreground"
      }
    },
    default_variants: %{variant: "default"}
  }

  @doc """
  Renders a badge.

  ## Examples

      <.badge>New</.badge>
      <.badge variant="destructive">Error</.badge>
      <.badge variant="outline" navigate={~p"/tags/elixir"}>elixir</.badge>
  """
  attr(:variant, :string,
    default: nil,
    values: [nil, "default", "secondary", "destructive", "outline"]
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  def badge(assigns) do
    assigns =
      assign(assigns, :class, variant(@variants, variant: assigns.variant, class: assigns.class))

    ~H"""
    <.link :if={link?(@rest)} data-slot="badge" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </.link>
    <span :if={not link?(@rest)} data-slot="badge" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc false
  def badge_variants(opts \\ []), do: variant(@variants, opts)

  defp link?(rest) do
    Map.has_key?(rest, :href) or Map.has_key?(rest, :navigate) or Map.has_key?(rest, :patch)
  end
end
