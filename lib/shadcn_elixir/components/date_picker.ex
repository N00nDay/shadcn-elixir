defmodule ShadcnElixir.Components.DatePicker do
  @moduledoc """
  DatePicker — a port of shadcn/ui's
  [Date Picker](https://ui.shadcn.com/docs/components/date-picker) (Popover + Calendar).

  A convenience component: a button trigger showing the selected date, opening a popover
  with a `Calendar`. Wire `on_select`/`on_previous_month`/`on_next_month` in your LiveView.

  ## Examples

      <.date_picker
        id="dob"
        selected={@date}
        month={@month}
        on_select="pick_date"
        on_previous_month="prev_month"
        on_next_month="next_month"
      />
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Components.Popover
  import ShadcnElixir.Components.Calendar
  import ShadcnElixir.Components.Button, only: [button_variants: 1]

  attr :id, :string, required: true
  attr :selected, :any, default: nil
  attr :month, :any, default: nil
  attr :placeholder, :string, default: "Pick a date"
  attr :format, :string, default: "%B %-d, %Y"
  attr :on_select, :string, default: nil
  attr :on_previous_month, :string, default: nil
  attr :on_next_month, :string, default: nil
  attr :class, :any, default: nil
  attr :rest, :global

  def date_picker(assigns) do
    label =
      case assigns.selected do
        %Date{} = d -> Calendar.strftime(d, assigns.format)
        _ -> assigns.placeholder
      end

    assigns = assign(assigns, :label, label)

    ~H"""
    <.popover id={@id} class={@class} {@rest}>
      <.popover_trigger popover={@id}>
        <button
          type="button"
          class={
            button_variants(
              variant: "outline",
              class:
                cn(["w-[240px] justify-start text-left font-normal", is_nil(@selected) && "text-muted-foreground"])
            )
          }
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mr-2 size-4">
            <path d="M8 2v4" /><path d="M16 2v4" /><rect width="18" height="18" x="3" y="4" rx="2" /><path d="M3 10h18" />
          </svg>
          {@label}
        </button>
      </.popover_trigger>
      <.popover_content popover={@id} align="start" class="w-auto p-0">
        <.calendar
          selected={@selected}
          month={@month}
          on_select={@on_select}
          on_previous_month={@on_previous_month}
          on_next_month={@on_next_month}
        />
      </.popover_content>
    </.popover>
    """
  end
end
