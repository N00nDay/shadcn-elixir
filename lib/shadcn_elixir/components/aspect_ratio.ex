defmodule ShadcnElixir.Components.AspectRatio do
  @moduledoc """
  AspectRatio — a port of shadcn/ui's
  [Aspect Ratio](https://ui.shadcn.com/docs/components/aspect-ratio).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Constrains its content to a given aspect ratio.

  ## Examples

      <.aspect_ratio ratio="16/9">
        <img src="..." class="h-full w-full object-cover" />
      </.aspect_ratio>
  """
  attr(:ratio, :string, default: "1/1", doc: "CSS aspect-ratio value, e.g. \"16/9\".")
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def aspect_ratio(assigns) do
    ~H"""
    <div
      data-slot="aspect-ratio"
      style={"aspect-ratio: #{@ratio};"}
      class={cn(@class)}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
