defmodule ShadcnElixir.Components.Label do
  @moduledoc """
  Label — a port of shadcn/ui's
  [Label](https://ui.shadcn.com/docs/components/label).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a form label.

  ## Examples

      <.label for="email">Email</.label>
  """
  attr :for, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label
      for={@for}
      data-slot="label"
      class={
        cn([
          "flex items-center gap-2 text-sm leading-none font-medium select-none",
          "group-data-[disabled=true]:pointer-events-none group-data-[disabled=true]:opacity-50",
          "peer-disabled:cursor-not-allowed peer-disabled:opacity-50",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </label>
    """
  end
end
