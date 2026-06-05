defmodule ShadcnElixir.Components.Button do
  @moduledoc """
  Button — a port of shadcn/ui's [Button](https://ui.shadcn.com/docs/components/button).

  Renders a `<button>` by default, or an `<a>` (via `Phoenix.Component.link/1`) when any
  of `href`, `navigate`, or `patch` is provided — the idiomatic Phoenix equivalent of
  shadcn's `asChild` link pattern.
  """
  use Phoenix.Component

  import ShadcnElixir.Variants

  @variants %{
    base:
      "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm " <>
        "font-medium transition-all disabled:pointer-events-none disabled:opacity-50 " <>
        "[&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 shrink-0 " <>
        "[&_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 " <>
        "focus-visible:ring-[3px] aria-invalid:ring-destructive/20 " <>
        "dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive",
    variants: %{
      variant: %{
        "default" => "bg-primary text-primary-foreground shadow-xs hover:bg-primary/90",
        "destructive" =>
          "bg-destructive text-white shadow-xs hover:bg-destructive/90 " <>
            "focus-visible:ring-destructive/20 dark:focus-visible:ring-destructive/40 " <>
            "dark:bg-destructive/60",
        "outline" =>
          "border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground " <>
            "dark:bg-input/30 dark:border-input dark:hover:bg-input/50",
        "secondary" => "bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80",
        "ghost" => "hover:bg-accent hover:text-accent-foreground dark:hover:bg-accent/50",
        "link" => "text-primary underline-offset-4 hover:underline"
      },
      size: %{
        "default" => "h-9 px-4 py-2 has-[>svg]:px-3",
        "sm" => "h-8 rounded-md gap-1.5 px-3 has-[>svg]:px-2.5",
        "lg" => "h-10 rounded-md px-6 has-[>svg]:px-4",
        "icon" => "size-9"
      }
    },
    default_variants: %{variant: "default", size: "default"}
  }

  @doc """
  Renders a button.

  ## Examples

      <.button>Click me</.button>
      <.button variant="destructive" size="sm">Delete</.button>
      <.button variant="outline" navigate={~p"/settings"}>Settings</.button>
  """
  attr(:variant, :string,
    default: nil,
    values: [nil, "default", "destructive", "outline", "secondary", "ghost", "link"],
    doc: "Visual style variant."
  )

  attr(:size, :string,
    default: nil,
    values: [nil, "default", "sm", "lg", "icon"],
    doc: "Size variant."
  )

  attr(:type, :string, default: nil, doc: "The `type` attribute when rendered as a `<button>`.")
  attr(:class, :any, default: nil, doc: "Additional classes merged over the variant classes.")

  attr(:rest, :global,
    include:
      ~w(disabled form formaction formmethod name value href navigate patch method download),
    doc: "Arbitrary HTML attributes; link attributes switch rendering to an `<a>`."
  )

  slot(:inner_block, required: true)

  def button(assigns) do
    assigns =
      assign(
        assigns,
        :class,
        variant(@variants, variant: assigns.variant, size: assigns.size, class: assigns.class)
      )

    ~H"""
    <.link :if={link?(@rest)} class={@class} {@rest}>{render_slot(@inner_block)}</.link>
    <button :if={not link?(@rest)} type={@type} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc false
  def button_variants(opts \\ []), do: variant(@variants, opts)

  defp link?(rest) do
    Map.has_key?(rest, :href) or Map.has_key?(rest, :navigate) or Map.has_key?(rest, :patch)
  end
end
