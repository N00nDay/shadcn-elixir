defmodule ShadcnElixir.Components.Calendar do
  @moduledoc """
  Calendar — a port of shadcn/ui's
  [Calendar](https://ui.shadcn.com/docs/components/calendar).

  Renders a month grid. Two ways to drive it:

    * **Interactive (client-side):** pass `interactive` and an `id`. The `ShadcnCalendar` JS hook
      handles day selection and month navigation entirely in the browser — no server wiring.
    * **Server-driven:** wire the `on_select`, `on_previous_month`, and `on_next_month` event
      names in your LiveView — day and navigation buttons emit those with `phx-value-date` /
      `phx-value-month` (ISO 8601).
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Components.Button, only: [button_variants: 1]

  @weekdays ~w(Su Mo Tu We Th Fr Sa)

  attr(:id, :string, default: nil, doc: "Required when `interactive` (the JS hook needs an id).")
  attr(:month, :any, default: nil, doc: "A Date within the month to display (defaults to today).")
  attr(:selected, :any, default: nil, doc: "The selected Date, or nil.")
  attr(:today, :any, default: nil, doc: "Override for 'today' (defaults to Date.utc_today/0).")

  attr(:interactive, :boolean,
    default: false,
    doc: "Enable client-side selection + month navigation via the `ShadcnCalendar` hook."
  )

  attr(:mode, :string,
    default: "single",
    values: ["single", "range"],
    doc: "Interactive selection mode: a single date or a start–end range."
  )

  attr(:months, :integer,
    default: 1,
    doc: "Interactive only: number of linked months shown side by side (one shared nav)."
  )

  attr(:range_start, :any, default: nil, doc: "Interactive range mode: initial start Date.")
  attr(:range_end, :any, default: nil, doc: "Interactive range mode: initial end Date.")

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
    <%!-- Interactive: the ShadcnCalendar hook renders the months (single/range, N linked months). --%>
    <div
      :if={@interactive}
      id={@id}
      data-slot="calendar"
      phx-hook="ShadcnCalendar"
      phx-update="ignore"
      data-mode={@mode}
      data-months={@months}
      data-month={Date.to_iso8601(@first)}
      data-selected={@selected && Date.to_iso8601(@selected)}
      data-range-start={@range_start && Date.to_iso8601(@range_start)}
      data-range-end={@range_end && Date.to_iso8601(@range_end)}
      data-today={Date.to_iso8601(@today)}
      class={cn(["w-fit p-3", @class])}
      {@rest}
    >
    </div>

    <%!-- Server-driven: a single month grid; wire on_select/on_previous_month/on_next_month. --%>
    <div
      :if={not @interactive}
      id={@id}
      data-slot="calendar"
      data-month={Date.to_iso8601(@first)}
      data-today={Date.to_iso8601(@today)}
      class={cn(["w-fit p-3", @class])}
      {@rest}
    >
      <div class="flex items-center justify-between pb-4">
        <button
          type="button"
          aria-label="Previous month"
          data-part="prev"
          disabled={is_nil(@on_previous_month)}
          phx-click={@on_previous_month}
          phx-value-month={Date.to_iso8601(@prev_month)}
          class={button_variants(variant: "outline", size: "icon", class: "size-7")}
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4" aria-hidden="true">
            <path d="m15 18-6-6 6-6" />
          </svg>
        </button>
        <div class="text-sm font-medium" data-part="label" aria-live="polite">
          {Calendar.strftime(@first, "%B %Y")}
        </div>
        <button
          type="button"
          aria-label="Next month"
          data-part="next"
          disabled={is_nil(@on_next_month)}
          phx-click={@on_next_month}
          phx-value-month={Date.to_iso8601(@next_month)}
          class={button_variants(variant: "outline", size: "icon", class: "size-7")}
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4" aria-hidden="true">
            <path d="m9 18 6-6-6-6" />
          </svg>
        </button>
      </div>

      <table class="w-full border-collapse" aria-label={Calendar.strftime(@first, "%B %Y")}>
        <thead>
          <tr class="flex">
            <th
              :for={wd <- @weekdays}
              scope="col"
              class="text-muted-foreground w-8 rounded-md text-[0.8rem] font-normal"
            >
              {wd}
            </th>
          </tr>
        </thead>
        <tbody data-part="grid">
          <tr :for={week <- @weeks} class="mt-2 flex w-full">
            <td :for={day <- week} class="p-0 text-center text-sm">
              <button
                type="button"
                data-part="day"
                disabled={is_nil(@on_select)}
                phx-click={@on_select}
                phx-value-date={Date.to_iso8601(day)}
                data-date={Date.to_iso8601(day)}
                aria-label={day_label(day, @selected)}
                aria-current={if day == @today, do: "date"}
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

  defp day_label(day, selected) do
    label = Calendar.strftime(day, "%A, %B %-d, %Y")
    if day == selected, do: label <> ", selected", else: label
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
