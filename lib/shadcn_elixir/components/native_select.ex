defmodule ShadcnElixir.Components.NativeSelect do
  @moduledoc """
  NativeSelect — a port of shadcn/ui's
  [Native Select](https://ui.shadcn.com/docs/components/native-select).

  A styled native `<select>` with a chevron, for cases where a real form control is
  preferable to the JS-driven `Select`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders a native select.

  ## Examples

      <.native_select name="fruit">
        <option value="apple">Apple</option>
        <option value="banana">Banana</option>
      </.native_select>
  """
  attr(:name, :string, default: nil)
  attr(:size, :string, default: "default", values: ["default", "sm"], doc: "Control height.")
  attr(:class, :any, default: nil)
  attr(:rest, :global, include: ~w(disabled form multiple required))
  slot(:inner_block, required: true)

  def native_select(assigns) do
    ~H"""
    <div
      data-slot="native-select-wrapper"
      class="group/native-select relative w-fit has-[select:disabled]:opacity-50"
    >
      <select
        name={@name}
        data-slot="native-select"
        data-size={@size}
        class={
          cn([
            "h-9 w-full min-w-0 appearance-none rounded-md border border-input bg-transparent px-3",
            "py-2 pr-9 text-sm shadow-xs transition-[color,box-shadow] outline-none",
            "selection:bg-primary selection:text-primary-foreground placeholder:text-muted-foreground",
            "disabled:pointer-events-none disabled:cursor-not-allowed",
            "data-[size=sm]:h-8 data-[size=sm]:py-1 dark:bg-input/30 dark:hover:bg-input/50",
            "focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50",
            "aria-invalid:border-destructive aria-invalid:ring-destructive/20",
            "dark:aria-invalid:ring-destructive/40",
            @class
          ])
        }
        {@rest}
      >
        {render_slot(@inner_block)}
      </select>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="24"
        height="24"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
        class="pointer-events-none absolute top-1/2 right-3.5 size-4 -translate-y-1/2 text-muted-foreground opacity-50 select-none"
      >
        <path d="m6 9 6 6 6-6" />
      </svg>
    </div>
    """
  end
end
