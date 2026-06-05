defmodule ShadcnElixir.Components.Textarea do
  @moduledoc """
  Textarea — a port of shadcn/ui's
  [Textarea](https://ui.shadcn.com/docs/components/textarea).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a multi-line text input.

  ## Examples

      <.textarea placeholder="Type your message here." />
  """
  attr(:name, :string, default: nil)
  attr(:value, :any, default: nil)
  attr(:class, :any, default: nil)

  attr(:rest, :global,
    include: ~w(autocomplete disabled form maxlength minlength placeholder readonly
                required rows cols wrap)
  )

  def textarea(assigns) do
    ~H"""
    <textarea
      name={@name}
      data-slot="textarea"
      class={
        cn([
          "border-input placeholder:text-muted-foreground focus-visible:border-ring",
          "focus-visible:ring-ring/50 aria-invalid:ring-destructive/20",
          "dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive",
          "dark:bg-input/30 flex field-sizing-content min-h-16 w-full rounded-md border",
          "bg-transparent px-3 py-2 text-base shadow-xs transition-[color,box-shadow]",
          "outline-none focus-visible:ring-[3px] disabled:cursor-not-allowed",
          "disabled:opacity-50 md:text-sm",
          @class
        ])
      }
      {@rest}
    >{@value}</textarea>
    """
  end
end
