defmodule ShadcnElixir.Components.Spinner do
  @moduledoc """
  Spinner — a port of shadcn/ui's
  [Spinner](https://ui.shadcn.com/docs/components/spinner). Renders a spinning
  Lucide `loader-circle` icon.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a loading spinner.

  ## Examples

      <.spinner />
      <.spinner class="size-6" />
  """
  attr :class, :any, default: nil
  attr :rest, :global

  def spinner(assigns) do
    ~H"""
    <svg
      role="status"
      aria-label="Loading"
      data-slot="spinner"
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linecap="round"
      stroke-linejoin="round"
      class={cn(["size-4 animate-spin", @class])}
      {@rest}
    >
      <path d="M21 12a9 9 0 1 1-6.219-8.56" />
    </svg>
    """
  end
end
