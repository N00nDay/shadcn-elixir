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
  attr :name, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global, include: ~w(disabled form multiple required size)
  slot :inner_block, required: true

  def native_select(assigns) do
    ~H"""
    <div class="relative w-full" data-slot="native-select-wrapper">
      <select
        name={@name}
        data-slot="native-select"
        class={
          cn([
            "border-input dark:bg-input/30 flex h-9 w-full appearance-none items-center",
            "rounded-md border bg-transparent px-3 py-2 pr-8 text-base shadow-xs",
            "transition-[color,box-shadow] outline-none disabled:cursor-not-allowed",
            "disabled:opacity-50 md:text-sm focus-visible:border-ring",
            "focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:border-destructive",
            "aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40",
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
        class="pointer-events-none absolute right-3 top-1/2 size-4 -translate-y-1/2 opacity-50"
      >
        <path d="m6 9 6 6 6-6" />
      </svg>
    </div>
    """
  end
end
