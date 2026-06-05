defmodule ShadcnElixir.Components.ToggleGroup do
  @moduledoc """
  ToggleGroup — a port of shadcn/ui's
  [Toggle Group](https://ui.shadcn.com/docs/components/toggle-group).

  Composed of `toggle_group/1` and `toggle_group_item/1`. `type="single"` enforces a
  single pressed item (radio-like) client-side; `type="multiple"` allows independent
  toggles.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Components.Toggle, only: [toggle_variants: 1]
  alias Phoenix.LiveView.JS

  @doc """
  Renders a toggle group. Requires an `id` shared by its items.

  ## Examples

      <.toggle_group id="align" type="single">
        <.toggle_group_item group="align" value="left">Left</.toggle_group_item>
        <.toggle_group_item group="align" value="center">Center</.toggle_group_item>
      </.toggle_group>
  """
  attr(:id, :string, required: true)
  attr(:type, :string, default: "single", values: ["single", "multiple"])
  attr(:variant, :string, default: "default")
  attr(:size, :string, default: "default")
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def toggle_group(assigns) do
    ~H"""
    <div
      id={@id}
      role="group"
      data-slot="toggle-group"
      data-type={@type}
      data-variant={@variant}
      data-size={@size}
      class={
        cn([
          "group/toggle-group flex w-fit items-center rounded-md",
          "data-[variant=outline]:shadow-xs",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:group, :string, required: true, doc: "The id of the parent `toggle_group/1`.")
  attr(:value, :string, required: true)
  attr(:type, :string, default: "single", values: ["single", "multiple"])
  attr(:variant, :string, default: nil, values: [nil, "default", "outline"])
  attr(:size, :string, default: nil, values: [nil, "default", "sm", "lg"])
  attr(:pressed, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def toggle_group_item(assigns) do
    assigns =
      assign(
        assigns,
        :class,
        cn([
          toggle_variants(variant: assigns.variant, size: assigns.size),
          "min-w-0 flex-1 shrink-0 rounded-none shadow-none first:rounded-l-md last:rounded-r-md",
          "focus:z-10 focus-visible:z-10 data-[variant=outline]:border-l-0",
          "data-[variant=outline]:first:border-l",
          assigns.class
        ])
      )

    ~H"""
    <button
      type="button"
      data-slot="toggle-group-item"
      data-value={@value}
      aria-pressed={to_string(@pressed)}
      data-state={if @pressed, do: "on", else: "off"}
      phx-click={press(@type, @group)}
      class={@class}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp press("multiple", _group) do
    %JS{}
    |> JS.toggle_attribute({"data-state", "on", "off"})
    |> JS.toggle_attribute({"aria-pressed", "true", "false"})
  end

  defp press("single", group) do
    items = "##{group} [data-slot=toggle-group-item]"

    %JS{}
    |> JS.set_attribute({"data-state", "off"}, to: items)
    |> JS.set_attribute({"aria-pressed", "false"}, to: items)
    |> JS.set_attribute({"data-state", "on"})
    |> JS.set_attribute({"aria-pressed", "true"})
  end
end
