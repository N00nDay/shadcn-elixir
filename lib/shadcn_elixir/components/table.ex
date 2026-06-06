defmodule ShadcnElixir.Components.Table do
  @moduledoc """
  Table — a port of shadcn/ui's [Table](https://ui.shadcn.com/docs/components/table).

  Composed of `table/1`, `table_header/1`, `table_body/1`, `table_footer/1`,
  `table_row/1`, `table_head/1`, `table_cell/1`, and `table_caption/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a table (wrapped in a horizontally scrollable container).

  ## Examples

      <.table>
        <.table_header>
          <.table_row><.table_head>Name</.table_head></.table_row>
        </.table_header>
        <.table_body>
          <.table_row><.table_cell>Alice</.table_cell></.table_row>
        </.table_body>
      </.table>
  """
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table(assigns) do
    ~H"""
    <div data-slot="table-container" class="relative w-full overflow-x-auto">
      <table data-slot="table" class={cn(["w-full caption-bottom text-sm", @class])} {@rest}>
        {render_slot(@inner_block)}
      </table>
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_header(assigns) do
    ~H"""
    <thead data-slot="table-header" class={cn(["[&_tr]:border-b", @class])} {@rest}>
      {render_slot(@inner_block)}
    </thead>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_body(assigns) do
    ~H"""
    <tbody data-slot="table-body" class={cn(["[&_tr:last-child]:border-0", @class])} {@rest}>
      {render_slot(@inner_block)}
    </tbody>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_footer(assigns) do
    ~H"""
    <tfoot
      data-slot="table-footer"
      class={cn(["bg-muted/50 border-t font-medium [&>tr]:last:border-b-0", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </tfoot>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_row(assigns) do
    ~H"""
    <tr
      data-slot="table-row"
      class={
        cn([
          "hover:bg-muted/50 has-aria-expanded:bg-muted/50 data-[state=selected]:bg-muted",
          "border-b transition-colors",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </tr>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(colspan rowspan scope abbr))
  slot(:inner_block, required: true)

  def table_head(assigns) do
    ~H"""
    <th
      data-slot="table-head"
      class={
        cn([
          "text-foreground h-10 px-2 text-left align-middle font-medium whitespace-nowrap",
          "[&:has([role=checkbox])]:pr-0 [&>[role=checkbox]]:translate-y-[2px]",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </th>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(colspan rowspan headers))
  slot(:inner_block, required: true)

  def table_cell(assigns) do
    ~H"""
    <td
      data-slot="table-cell"
      class={
        cn([
          "p-2 align-middle whitespace-nowrap [&:has([role=checkbox])]:pr-0",
          "[&>[role=checkbox]]:translate-y-[2px]",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </td>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def table_caption(assigns) do
    ~H"""
    <caption data-slot="table-caption" class={cn(["text-muted-foreground mt-4 text-sm", @class])} {@rest}>
      {render_slot(@inner_block)}
    </caption>
    """
  end
end
