defmodule ShadcnElixir.Components.Chart do
  @moduledoc """
  Chart — a port of shadcn/ui's [Chart](https://ui.shadcn.com/docs/components/chart).

  shadcn charts wrap Recharts; this is a lightweight, dependency-free equivalent: the
  `ShadcnChart` JS hook (see `assets/js/shadcn_elixir.js`) renders an SVG chart from the
  provided data, themed via the `--chart-1..5` CSS variables. Supported `type`s are
  `bar`, `line`, `area`, `pie`, `donut`, `radar`, and `radial`.

  Each datum is a map with a `:label` and one numeric key per series. `keys` names the
  series to plot (defaulting to `["value"]`); `variant` selects a style (e.g. `"linear"`,
  `"step"`, `"stacked"`, `"horizontal"`, `"dots"`, `"donut-text"`, `"lines-only"`).

  ## Examples

      <.chart
        id="visitors"
        type="bar"
        class="h-[250px] w-full"
        data={[%{label: "Jan", value: 186}, %{label: "Feb", value: 305}, %{label: "Mar", value: 237}]}
      />

      <.chart
        id="multi"
        type="line"
        variant="multiple"
        keys={["desktop", "mobile"]}
        data={[%{label: "Jan", desktop: 186, mobile: 80}, %{label: "Feb", desktop: 305, mobile: 200}]}
      />
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  attr(:id, :string, required: true)

  attr(:type, :string,
    default: "bar",
    values: ["bar", "line", "area", "pie", "donut", "radar", "radial"]
  )

  attr(:data, :list, required: true, doc: "List of maps with a :label and one key per series.")

  attr(:keys, :list,
    default: ["value"],
    doc: "Series keys to plot, in order. Each maps to a `--chart-N` color."
  )

  attr(:variant, :string,
    default: nil,
    doc: "Style variant for the chosen type (e.g. \"linear\", \"step\", \"stacked\", \"dots\")."
  )

  attr(:legend, :boolean, default: false, doc: "Render a legend of the series below the chart.")

  attr(:colors, :list,
    default: nil,
    doc:
      "Override the series colors with a list of CSS custom-property names (e.g. `[\"--foreground\"]`)."
  )

  attr(:theme, :string,
    default: nil,
    doc: "An opaque theme key — when it changes, the chart re-resolves its colors and re-renders."
  )

  attr(:label, :string,
    default: nil,
    doc: "Accessible name for the chart. Defaults to a generated summary of the data."
  )

  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def chart(assigns) do
    keys = Enum.map(assigns.keys, &to_string/1)
    normalized = normalize(assigns.data, keys)

    assigns =
      assigns
      |> assign(:keys, keys)
      |> assign(:payload, Jason.encode!(normalized))
      |> assign(:keys_json, Jason.encode!(keys))
      |> assign(:colors_json, assigns.colors && Jason.encode!(assigns.colors))
      |> assign(:chart_label, assigns.label || summarize(assigns.type, normalized, keys))

    ~H"""
    <div
      id={@id}
      phx-hook="ShadcnChart"
      phx-update="ignore"
      role="img"
      aria-label={@chart_label}
      data-slot="chart"
      data-chart-type={@type}
      data-chart-variant={@variant}
      data-chart-keys={@keys_json}
      data-chart-legend={to_string(@legend)}
      data-chart-colors={@colors_json}
      data-chart-theme={@theme}
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
  defp summarize(type, normalized, [key | _]) do
    points =
      Enum.map_join(normalized, ", ", fn row -> "#{row["label"]}: #{row[key]}" end)

    "#{String.capitalize(type)} chart. #{points}"
  end

  defp normalize(data, keys) do
    Enum.map(data, fn row ->
      base = %{"label" => to_string(get(row, :label) || "")}

      Enum.reduce(keys, base, fn key, acc ->
        Map.put(acc, key, num(get(row, key)))
      end)
    end)
  end

  defp get(row, key) when is_atom(key), do: get(row, Atom.to_string(key))

  defp get(row, key) when is_binary(key) do
    Map.get(row, key) || Map.get(row, String.to_atom(key))
  end

  defp num(v) when is_number(v), do: v
  defp num(_), do: 0
end
