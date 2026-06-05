defmodule ShadcnElixir.Components.Separator do
  @moduledoc """
  Separator — a port of shadcn/ui's
  [Separator](https://ui.shadcn.com/docs/components/separator).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a visual or semantic separator.

  ## Examples

      <.separator />
      <.separator orientation="vertical" />
  """
  attr :orientation, :string, default: "horizontal", values: ["horizontal", "vertical"]
  attr :decorative, :boolean, default: true
  attr :class, :any, default: nil
  attr :rest, :global

  def separator(assigns) do
    ~H"""
    <div
      role={if @decorative, do: "none", else: "separator"}
      aria-orientation={if @decorative, do: nil, else: @orientation}
      data-orientation={@orientation}
      data-slot="separator"
      class={
        cn([
          "bg-border shrink-0 data-[orientation=horizontal]:h-px data-[orientation=horizontal]:w-full",
          "data-[orientation=vertical]:h-full data-[orientation=vertical]:w-px",
          @class
        ])
      }
      {@rest}
    />
    """
  end
end
