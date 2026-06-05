defmodule ShadcnElixir.Components.Sonner do
  @moduledoc """
  Sonner — a port of shadcn/ui's [Sonner](https://ui.shadcn.com/docs/components/sonner)
  toaster.

  Render `toaster/1` once near the root of your layout. Trigger toasts from JS:

      import { toast } from "../../deps/shadcn_elixir/assets/js/shadcn_elixir";
      toast("Event created", { description: "Sunday at 9:00 AM", variant: "default" });

  or from anywhere by dispatching the event the `ShadcnToaster` hook listens for:

      window.dispatchEvent(new CustomEvent("shadcn:toast", { detail: { title: "Saved" } }));

  From LiveView you can `push_event(socket, "shadcn:toast", %{title: "Saved"})` after
  configuring the hook to forward server events (see the assets file).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  attr(:position, :string,
    default: "bottom-right",
    values: [
      "top-left",
      "top-right",
      "bottom-left",
      "bottom-right",
      "top-center",
      "bottom-center"
    ]
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def toaster(assigns) do
    ~H"""
    <div
      id="shadcn-toaster"
      phx-hook="ShadcnToaster"
      data-slot="toaster"
      data-position={@position}
      class={cn(["fixed z-[100] flex max-h-screen w-full flex-col gap-2 p-4 sm:max-w-[420px]", position_class(@position), @class])}
      {@rest}
    >
    </div>
    """
  end

  defp position_class("top-left"), do: "top-0 left-0"
  defp position_class("top-right"), do: "top-0 right-0"
  defp position_class("top-center"), do: "top-0 left-1/2 -translate-x-1/2"
  defp position_class("bottom-left"), do: "bottom-0 left-0"
  defp position_class("bottom-center"), do: "bottom-0 left-1/2 -translate-x-1/2"
  defp position_class(_), do: "bottom-0 right-0"
end
