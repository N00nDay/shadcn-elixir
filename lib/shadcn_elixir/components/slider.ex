defmodule ShadcnElixir.Components.Slider do
  @moduledoc """
  Slider — a port of shadcn/ui's [Slider](https://ui.shadcn.com/docs/components/slider).

  Built on a native `<input type="range">` (form-friendly, JS-free) styled to match
  shadcn's track and thumb.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a slider.

  ## Examples

      <.slider name="volume" min={0} max={100} value={50} />
  """
  attr(:name, :string, default: nil)
  attr(:min, :integer, default: 0)
  attr(:max, :integer, default: 100)
  attr(:step, :integer, default: 1)
  attr(:value, :integer, default: nil)
  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(disabled form))

  def slider(assigns) do
    ~H"""
    <input
      type="range"
      name={@name}
      min={@min}
      max={@max}
      step={@step}
      value={@value}
      data-slot="slider"
      class={
        cn([
          "relative flex w-full touch-none items-center cursor-pointer appearance-none bg-transparent",
          "h-4 disabled:opacity-50 disabled:pointer-events-none",
          # track
          "[&::-webkit-slider-runnable-track]:h-1.5 [&::-webkit-slider-runnable-track]:rounded-full",
          "[&::-webkit-slider-runnable-track]:bg-muted",
          "[&::-moz-range-track]:h-1.5 [&::-moz-range-track]:rounded-full [&::-moz-range-track]:bg-muted",
          # range fill (Firefox supports a native progress pseudo-element)
          "[&::-moz-range-progress]:h-1.5 [&::-moz-range-progress]:rounded-full",
          "[&::-moz-range-progress]:bg-primary",
          # thumb
          "[&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:size-4",
          "[&::-webkit-slider-thumb]:-mt-[5px] [&::-webkit-slider-thumb]:rounded-full",
          "[&::-webkit-slider-thumb]:border [&::-webkit-slider-thumb]:border-primary",
          "[&::-webkit-slider-thumb]:bg-white [&::-webkit-slider-thumb]:shadow-sm",
          "[&::-moz-range-thumb]:size-4 [&::-moz-range-thumb]:rounded-full",
          "[&::-moz-range-thumb]:border [&::-moz-range-thumb]:border-primary",
          "[&::-moz-range-thumb]:bg-white [&::-moz-range-thumb]:shadow-sm",
          @class
        ])
      }
      {@rest}
    />
    """
  end
end
