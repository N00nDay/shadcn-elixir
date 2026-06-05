defmodule ShadcnElixir.Components.Combobox do
  @moduledoc """
  Combobox — a port of shadcn/ui's
  [Combobox](https://ui.shadcn.com/docs/components/combobox) (Popover + Command).

  A searchable single-select that writes to a hidden input (form-friendly). Provided as a
  convenience component driven by the `ShadcnCombobox` JS hook
  (see `assets/js/shadcn_elixir.js`).

  ## Examples

      <.combobox id="fw" name="framework" placeholder="Select framework...">
        <:option value="next">Next.js</:option>
        <:option value="svelte">SvelteKit</:option>
        <:option value="remix">Remix</:option>
      </.combobox>
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  attr(:id, :string, required: true)
  attr(:name, :string, default: nil)
  attr(:value, :string, default: nil)
  attr(:placeholder, :string, default: "Select an option...")
  attr(:search_placeholder, :string, default: "Search...")
  attr(:empty, :string, default: "No results found.")
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  slot :option do
    attr(:value, :string, required: true)
  end

  def combobox(assigns) do
    ~H"""
    <div
      id={@id}
      phx-hook="ShadcnCombobox"
      data-slot="combobox"
      data-state="closed"
      class={cn(["relative inline-block", @class])}
      {@rest}
    >
      <input type="hidden" name={@name} value={@value} data-part="input" />
      <button
        type="button"
        role="combobox"
        aria-haspopup="listbox"
        aria-expanded="false"
        data-part="trigger"
        class={
          "border-input dark:bg-input/30 flex h-9 w-full items-center justify-between gap-2 " <>
            "rounded-md border bg-transparent px-3 py-2 text-sm shadow-xs outline-none " <>
            "focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px]"
        }
      >
        <span data-part="value" data-placeholder={@placeholder} class="truncate text-muted-foreground">
          {@placeholder}
        </span>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="size-4 shrink-0 opacity-50"
          aria-hidden="true"
        >
          <path d="m7 15 5 5 5-5" /><path d="m7 9 5-5 5 5" />
        </svg>
      </button>

      <div
        id={"#{@id}-content"}
        data-part="content"
        hidden
        class="bg-popover text-popover-foreground absolute top-full left-0 z-50 mt-1 w-full min-w-[12rem] overflow-hidden rounded-md border p-0 shadow-md"
      >
        <div class="flex h-9 items-center gap-2 border-b px-3">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="size-4 shrink-0 opacity-50"
            aria-hidden="true"
          >
            <circle cx="11" cy="11" r="8" /><path d="m21 21-4.3-4.3" />
          </svg>
          <input
            type="text"
            data-part="search"
            placeholder={@search_placeholder}
            class="placeholder:text-muted-foreground flex h-9 w-full bg-transparent text-sm outline-hidden"
          />
        </div>
        <div role="listbox" data-part="list" class="max-h-[300px] overflow-y-auto p-1">
          <div data-part="empty" hidden class="py-6 text-center text-sm">{@empty}</div>
          <div
            :for={opt <- @option}
            role="option"
            data-part="item"
            data-value={opt.value}
            aria-selected="false"
            class="hover:bg-accent hover:text-accent-foreground relative flex cursor-default items-center justify-between gap-2 rounded-sm px-2 py-1.5 text-sm outline-hidden select-none"
          >
            <span>{render_slot(opt)}</span>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="size-4 hidden"
              data-part="check"
            >
              <path d="M20 6 9 17l-5-5" />
            </svg>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
