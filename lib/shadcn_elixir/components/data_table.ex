defmodule ShadcnElixir.Components.DataTable do
  @moduledoc """
  DataTable — a port of shadcn/ui's
  [Data Table](https://ui.shadcn.com/docs/components/data-table) recipe.

  shadcn's data table is a composition of `Table` + TanStack Table. This is the Phoenix
  equivalent: a column-slot driven table where sorting/filtering/pagination are wired in
  your LiveView (use the `sort` event hooks on column headers). Built on the `Table`
  primitives.

  ## Examples

      <.data_table rows={@users}>
        <:col :let={u} label="Name">{u.name}</:col>
        <:col :let={u} label="Email">{u.email}</:col>
        <:col :let={u} label="" class="text-right">
          <.button size="sm" variant="ghost">Edit</.button>
        </:col>
      </.data_table>
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Components.Table

  attr(:rows, :list, required: true)
  attr(:empty_message, :string, default: "No results.")
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  slot :col, required: true do
    attr(:label, :string)
    attr(:class, :any)
    attr(:sort_click, :any, doc: "A phx-click value to make this header sortable.")
  end

  def data_table(assigns) do
    ~H"""
    <div data-slot="data-table" class={cn(["rounded-md border", @class])} {@rest}>
      <.table>
        <.table_header>
          <.table_row>
            <.table_head :for={col <- @col} class={col[:class]}>
              <button :if={col[:sort_click]} type="button" phx-click={col[:sort_click]} class="inline-flex items-center gap-1 hover:text-foreground">
                {col[:label]}
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-3.5 opacity-60">
                  <path d="m7 15 5 5 5-5" /><path d="m7 9 5-5 5 5" />
                </svg>
              </button>
              <span :if={!col[:sort_click]}>{col[:label]}</span>
            </.table_head>
          </.table_row>
        </.table_header>
        <.table_body>
          <.table_row :for={row <- @rows}>
            <.table_cell :for={col <- @col} class={col[:class]}>
              {render_slot(col, row)}
            </.table_cell>
          </.table_row>
          <.table_row :if={@rows == []}>
            <.table_cell class="h-24 text-center text-muted-foreground" colspan={length(@col)}>
              {@empty_message}
            </.table_cell>
          </.table_row>
        </.table_body>
      </.table>
    </div>
    """
  end
end
