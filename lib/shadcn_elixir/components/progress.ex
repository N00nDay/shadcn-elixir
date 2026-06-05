defmodule ShadcnElixir.Components.Progress do
  @moduledoc """
  Progress — a port of shadcn/ui's
  [Progress](https://ui.shadcn.com/docs/components/progress).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a progress bar.

  ## Examples

      <.progress value={60} />
  """
  attr :value, :integer, default: 0, doc: "Completion percentage, 0..100."
  attr :class, :any, default: nil
  attr :rest, :global

  def progress(assigns) do
    ~H"""
    <div
      role="progressbar"
      aria-valuemin="0"
      aria-valuemax="100"
      aria-valuenow={@value}
      data-slot="progress"
      class={
        cn(["bg-primary/20 relative h-2 w-full overflow-hidden rounded-full", @class])
      }
      {@rest}
    >
      <div
        data-slot="progress-indicator"
        class="bg-primary h-full w-full flex-1 transition-all"
        style={"transform: translateX(-#{100 - (@value || 0)}%);"}
      >
      </div>
    </div>
    """
  end
end
