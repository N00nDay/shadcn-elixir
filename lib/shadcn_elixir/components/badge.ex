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
      "inline-flex w-fit shrink-0 items-center justify-center gap-1 overflow-hidden rounded-full " <>
        "border border-transparent px-2 py-0.5 text-xs font-medium whitespace-nowrap " <>
        "transition-[color,box-shadow] focus-visible:border-ring focus-visible:ring-[3px] " <>
        "focus-visible:ring-ring/50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 " <>
        "dark:aria-invalid:ring-destructive/40 [&>svg]:pointer-events-none [&>svg]:size-3",
    variants: %{
      variant: %{
        "default" => "bg-primary text-primary-foreground [a&]:hover:bg-primary/90",
        "secondary" => "bg-secondary text-secondary-foreground [a&]:hover:bg-secondary/90",
        "destructive" =>
          "bg-destructive text-white focus-visible:ring-destructive/20 " <>
            "dark:bg-destructive/60 dark:focus-visible:ring-destructive/40 " <>
            "[a&]:hover:bg-destructive/90",
        "outline" =>
          "border-border text-foreground [a&]:hover:bg-accent [a&]:hover:text-accent-foreground",
        "ghost" => "[a&]:hover:bg-accent [a&]:hover:text-accent-foreground",
        "link" => "text-primary underline-offset-4 [a&]:hover:underline"
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
    values: [nil, "default", "secondary", "destructive", "outline", "ghost", "link"]
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(href navigate patch))
  slot(:inner_block, required: true)

  def badge(assigns) do
    variant = assigns.variant || "default"

    assigns =
      assigns
      |> assign(:variant, variant)
      |> assign(:class, variant(@variants, variant: variant, class: assigns.class))

    ~H"""
    <.link :if={link?(@rest)} data-slot="badge" data-variant={@variant} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </.link>
    <span :if={not link?(@rest)} data-slot="badge" data-variant={@variant} class={@class} {@rest}>
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
