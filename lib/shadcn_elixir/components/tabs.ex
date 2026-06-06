defmodule ShadcnElixir.Components.Tabs do
  @moduledoc """
  Tabs — a port of shadcn/ui's [Tabs](https://ui.shadcn.com/docs/components/tabs).

  Tab switching is handled client-side with `Phoenix.LiveView.JS` (works in both live
  and dead views). Mark the initially-selected trigger/content with `active`.

  Composed of `tabs/1`, `tabs_list/1`, `tabs_trigger/1`, and `tabs_content/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  alias Phoenix.LiveView.JS

  @doc """
  Renders a tabs container. Requires an `id` shared by its triggers and contents.

  ## Examples

      <.tabs id="demo">
        <.tabs_list>
          <.tabs_trigger tabs="demo" value="a" active>Account</.tabs_trigger>
          <.tabs_trigger tabs="demo" value="b">Password</.tabs_trigger>
        </.tabs_list>
        <.tabs_content tabs="demo" value="a" active>Account panel</.tabs_content>
        <.tabs_content tabs="demo" value="b">Password panel</.tabs_content>
      </.tabs>
  """
  attr(:id, :string, required: true)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs(assigns) do
    ~H"""
    <div id={@id} data-slot="tabs" class={cn(["flex flex-col gap-2", @class])} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs_list(assigns) do
    ~H"""
    <div
      role="tablist"
      data-slot="tabs-list"
      class={
        cn([
          "bg-muted text-muted-foreground inline-flex h-9 w-fit items-center justify-center",
          "rounded-lg p-[3px]",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:tabs, :string, required: true, doc: "The id of the parent `tabs/1`.")
  attr(:value, :string, required: true)
  attr(:active, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs_trigger(assigns) do
    ~H"""
    <button
      type="button"
      role="tab"
      aria-selected={to_string(@active)}
      data-state={if @active, do: "active", else: "inactive"}
      data-tab-value={@value}
      phx-click={select_tab(@tabs, @value)}
      data-slot="tabs-trigger"
      class={
        cn([
          "data-[state=active]:bg-background dark:data-[state=active]:text-foreground",
          "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:outline-ring",
          "dark:data-[state=active]:border-input dark:data-[state=active]:bg-input/30",
          "text-foreground dark:text-muted-foreground inline-flex h-[calc(100%-1px)] flex-1",
          "items-center justify-center gap-1.5 rounded-md border border-transparent px-2 py-1",
          "text-sm font-medium whitespace-nowrap transition-[color,box-shadow]",
          "focus-visible:ring-[3px] focus-visible:outline-1 disabled:pointer-events-none",
          "disabled:opacity-50 data-[state=active]:shadow-sm [&_svg]:pointer-events-none",
          "[&_svg]:shrink-0 [&_svg:not([class*='size-'])]:size-4",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  attr(:tabs, :string, required: true, doc: "The id of the parent `tabs/1`.")
  attr(:value, :string, required: true)
  attr(:active, :boolean, default: false)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def tabs_content(assigns) do
    ~H"""
    <div
      role="tabpanel"
      data-tab-value={@value}
      data-slot="tabs-content"
      data-state={if @active, do: "active", else: "inactive"}
      class={cn(["data-[state=inactive]:hidden flex-1 outline-none", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc false
  def select_tab(tabs, value) do
    panel = "##{tabs} [role=tabpanel]"
    tab = "##{tabs} [role=tab]"

    %JS{}
    |> JS.set_attribute({"data-state", "inactive"}, to: tab)
    |> JS.set_attribute({"aria-selected", "false"}, to: tab)
    |> JS.set_attribute({"data-state", "inactive"}, to: panel)
    |> JS.set_attribute({"data-state", "active"})
    |> JS.set_attribute({"aria-selected", "true"})
    |> JS.set_attribute({"data-state", "active"},
      to: "##{tabs} [role=tabpanel][data-tab-value='#{value}']"
    )
  end
end
