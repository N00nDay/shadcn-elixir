defmodule ShadcnElixir.Components.Chart do
  @moduledoc """
  Chart — a port of shadcn/ui's [Chart](https://ui.shadcn.com/docs/components/chart).

  shadcn charts wrap Recharts; this is a lightweight, dependency-free equivalent: the
  `ShadcnChart` JS hook (see `assets/js/shadcn_elixir.js`) renders an SVG bar or line
  chart from the provided data, themed via the `--chart-1..5` CSS variables.

  ## Examples

      <.chart
        id="visitors"
        type="bar"
        class="h-[250px] w-full"
        data={[%{label: "Jan", value: 186}, %{label: "Feb", value: 305}, %{label: "Mar", value: 237}]}
      />
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  attr(:id, :string, required: true)
  attr(:type, :string, default: "bar", values: ["bar", "line"])
  attr(:data, :list, required: true, doc: "List of maps with :label and :value keys.")

  attr(:label, :string,
    default: nil,
    doc: "Accessible name for the chart. Defaults to a generated summary of the data."
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def chart(assigns) do
    normalized = normalize(assigns.data)

    assigns =
      assigns
      |> assign(:payload, Jason.encode!(normalized))
      |> assign(:chart_label, assigns.label || summarize(assigns.type, normalized))

    ~H"""
    <div
      id={@id}
      phx-hook="ShadcnChart"
      role="img"
      aria-label={@chart_label}
      data-slot="chart"
      data-chart-type={@type}
      data-chart={@payload}
      class={
        cn([
          "flex aspect-video justify-center text-xs [&_svg]:overflow-visible",
          "[&_.chart-grid]:stroke-border/50 [&_.chart-axis]:fill-muted-foreground",
          @class
        ])
      }
      {@rest}
    >
    </div>
    """
  end

  # A concise text alternative so screen-reader users get the data, not a blank image.
  defp summarize(type, normalized) do
    points = Enum.map_join(normalized, ", ", fn %{label: l, value: v} -> "#{l}: #{v}" end)
    "#{String.capitalize(type)} chart. #{points}"
  end

  defp normalize(data) do
    Enum.map(data, fn row ->
      %{
        label: to_string(row[:label] || row["label"] || ""),
        value: row[:value] || row["value"] || 0
      }
    end)
  end
end
