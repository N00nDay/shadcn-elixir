defmodule ShadcnElixir.Components.Switch do
  @moduledoc """
  Switch — a port of shadcn/ui's [Switch](https://ui.shadcn.com/docs/components/switch).

  Renders a real checkbox (`peer sr-only`) wrapped in a styled track + thumb, so it
  submits with forms and toggles with zero JavaScript.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a switch.

  ## Examples

      <.switch name="airplane_mode" />
      <.switch name="wifi" checked />
  """
  attr(:name, :string, default: nil)
  attr(:value, :string, default: "true")
  attr(:checked, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(disabled required form id))

  def switch(assigns) do
    ~H"""
    <label class={cn(["inline-flex items-center", @class])} data-slot="switch">
      <input type="checkbox" name={@name} value={@value} checked={@checked} class="peer sr-only" {@rest} />
      <span class={
        "bg-input peer-checked:bg-primary dark:peer-checked:bg-primary " <>
          "dark:bg-input/80 inline-flex h-[1.15rem] w-8 shrink-0 items-center rounded-full " <>
          "border border-transparent shadow-xs transition-all outline-none " <>
          "peer-focus-visible:border-ring peer-focus-visible:ring-ring/50 peer-focus-visible:ring-[3px] " <>
          "peer-disabled:cursor-not-allowed peer-disabled:opacity-50 " <>
          "peer-checked:[&>[data-slot=switch-thumb]]:translate-x-[calc(100%-2px)]"
      }>
        <span
          data-slot="switch-thumb"
          class={
            "bg-background dark:bg-foreground pointer-events-none block size-4 rounded-full " <>
              "ring-0 transition-transform translate-x-0"
          }
        >
        </span>
      </span>
    </label>
    """
  end
end
