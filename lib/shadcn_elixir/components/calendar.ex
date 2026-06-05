defmodule ShadcnElixir.Components.Calendar do
  @moduledoc """
  Calendar — a port of shadcn/ui's
  [Calendar](https://ui.shadcn.com/docs/components/calendar).

  Renders a month grid. Wire interactivity in your LiveView via the `on_select`,
  `on_previous_month`, and `on_next_month` event names — day and navigation buttons emit
  those events with `phx-value-date` / `phx-value-month` (ISO 8601).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Components.Button, only: [button_variants: 1]

  @weekdays ~w(Su Mo Tu We Th Fr Sa)

  attr(:month, :any, default: nil, doc: "A Date within the month to display (defaults to today).")
  attr(:selected, :any, default: nil, doc: "The selected Date, or nil.")
  attr(:today, :any, default: nil, doc: "Override for 'today' (defaults to Date.utc_today/0).")
  attr(:on_select, :string, default: nil)
  attr(:on_previous_month, :string, default: nil)
  attr(:on_next_month, :string, default: nil)
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def calendar(assigns) do
    today = assigns.today || Date.utc_today()
    month = assigns.month || today
    first = Date.beginning_of_month(month)

    assigns =
      assigns
      |> assign(:today, today)
      |> assign(:first, first)
      |> assign(:weeks, weeks(first))
      |> assign(:weekdays, @weekdays)
      |> assign(:prev_month, first |> Date.add(-1) |> Date.beginning_of_month())
      |> assign(:next_month, first |> Date.end_of_month() |> Date.add(1))

    ~H"""
    <div data-slot="calendar" class={cn(["w-fit p-3", @class])} {@rest}>
      <div class="flex items-center justify-between pb-4">
        <button
          type="button"
          aria-label="Previous month"
          disabled={is_nil(@on_previous_month)}
          phx-click={@on_previous_month}
          phx-value-month={Date.to_iso8601(@prev_month)}
          class={button_variants(variant: "outline", size: "icon", class: "size-7")}
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4">
            <path d="m15 18-6-6 6-6" />
          </svg>
        </button>
        <div class="text-sm font-medium" aria-live="polite">
          {Calendar.strftime(@first, "%B %Y")}
        </div>
        <button
          type="button"
          aria-label="Next month"
          disabled={is_nil(@on_next_month)}
          phx-click={@on_next_month}
          phx-value-month={Date.to_iso8601(@next_month)}
          class={button_variants(variant: "outline", size: "icon", class: "size-7")}
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4">
            <path d="m9 18 6-6-6-6" />
          </svg>
        </button>
      </div>

      <table class="w-full border-collapse">
        <thead>
          <tr class="flex">
            <th
              :for={wd <- @weekdays}
              class="text-muted-foreground w-8 rounded-md text-[0.8rem] font-normal"
            >
              {wd}
            </th>
          </tr>
        </thead>
        <tbody>
          <tr :for={week <- @weeks} class="mt-2 flex w-full">
            <td :for={day <- week} class="p-0 text-center text-sm">
              <button
                type="button"
                disabled={is_nil(@on_select)}
                phx-click={@on_select}
                phx-value-date={Date.to_iso8601(day)}
                aria-selected={to_string(day == @selected)}
                data-today={day == @today}
                data-outside={day.month != @first.month}
                class={day_class(day, @first, @today, @selected)}
              >
                {day.day}
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  defp weeks(first) do
    start = Date.beginning_of_week(first, :sunday)
    last = Date.end_of_month(first)
    last_cell = Date.end_of_week(last, :sunday)

    start
    |> Date.range(last_cell)
    |> Enum.to_list()
    |> Enum.chunk_every(7)
  end

  defp day_class(day, first, today, selected) do
    cn([
      "size-8 p-0 font-normal rounded-md inline-flex items-center justify-center text-sm",
      "hover:bg-accent hover:text-accent-foreground disabled:pointer-events-none",
      day.month != first.month && "text-muted-foreground opacity-50",
      day == today && day != selected && "bg-accent text-accent-foreground",
      day == selected &&
        "bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground"
    ])
  end
end
