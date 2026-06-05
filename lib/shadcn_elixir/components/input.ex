defmodule ShadcnElixir.Components.Input do
  @moduledoc """
  Input — a port of shadcn/ui's [Input](https://ui.shadcn.com/docs/components/input).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a text input.

  ## Examples

      <.input type="email" placeholder="you@example.com" />
  """
  attr(:type, :string, default: "text")
  attr(:name, :string, default: nil)
  attr(:value, :any, default: nil)
  attr(:class, :any, default: nil)

  attr(:rest, :global,
    include: ~w(autocomplete disabled form max maxlength min minlength pattern placeholder
                readonly required step inputmode list multiple accept)
  )

  def input(assigns) do
    ~H"""
    <input
      type={@type}
      name={@name}
      value={@value}
      data-slot="input"
      class={
        cn([
          "file:text-foreground placeholder:text-muted-foreground selection:bg-primary",
          "selection:text-primary-foreground dark:bg-input/30 border-input flex h-9 w-full",
          "min-w-0 rounded-md border bg-transparent px-3 py-1 text-base shadow-xs",
          "transition-[color,box-shadow] outline-none file:inline-flex file:h-7 file:border-0",
          "file:bg-transparent file:text-sm file:font-medium disabled:pointer-events-none",
          "disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
          "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]",
          "aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40",
          "aria-invalid:border-destructive",
          @class
        ])
      }
      {@rest}
    />
    """
  end
end
