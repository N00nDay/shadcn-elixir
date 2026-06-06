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
      "inline-flex shrink-0 items-center justify-center gap-2 rounded-md text-sm font-medium " <>
        "whitespace-nowrap transition-all outline-none focus-visible:border-ring " <>
        "focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none " <>
        "disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20 " <>
        "dark:aria-invalid:ring-destructive/40 [&_svg]:pointer-events-none [&_svg]:shrink-0 " <>
        "[&_svg:not([class*='size-'])]:size-4",
    variants: %{
      variant: %{
        "default" => "bg-primary text-primary-foreground hover:bg-primary/90",
        "destructive" =>
          "bg-destructive text-white hover:bg-destructive/90 " <>
            "focus-visible:ring-destructive/20 dark:bg-destructive/60 " <>
            "dark:focus-visible:ring-destructive/40",
        "outline" =>
          "border bg-background shadow-xs hover:bg-accent hover:text-accent-foreground " <>
            "dark:border-input dark:bg-input/30 dark:hover:bg-input/50",
        "secondary" => "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        "ghost" => "hover:bg-accent hover:text-accent-foreground dark:hover:bg-accent/50",
        "link" => "text-primary underline-offset-4 hover:underline"
      },
      size: %{
        "default" => "h-9 px-4 py-2 has-[>svg]:px-3",
        "xs" =>
          "h-6 gap-1 rounded-md px-2 text-xs has-[>svg]:px-1.5 " <>
            "[&_svg:not([class*='size-'])]:size-3",
        "sm" => "h-8 gap-1.5 rounded-md px-3 has-[>svg]:px-2.5",
        "lg" => "h-10 rounded-md px-6 has-[>svg]:px-4",
        "icon" => "size-9",
        "icon-xs" => "size-6 rounded-md [&_svg:not([class*='size-'])]:size-3",
        "icon-sm" => "size-8",
        "icon-lg" => "size-10"
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
    values: [nil, "default", "xs", "sm", "lg", "icon", "icon-xs", "icon-sm", "icon-lg"],
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
    variant = assigns.variant || "default"
    size = assigns.size || "default"

    assigns =
      assigns
      |> assign(:variant, variant)
      |> assign(:size, size)
      |> assign(:class, variant(@variants, variant: variant, size: size, class: assigns.class))

    ~H"""
    <.link
      :if={link?(@rest)}
      data-slot="button"
      data-variant={@variant}
      data-size={@size}
      class={@class}
      {@rest}
    >{render_slot(@inner_block)}</.link>
    <button
      :if={not link?(@rest)}
      type={@type}
      data-slot="button"
      data-variant={@variant}
      data-size={@size}
      class={@class}
      {@rest}
    >
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
