defmodule DemoWeb.Charts do
  @moduledoc """
  Registry for the Charts showcase (`/charts/:category`), modeled on
  shadcn-svelte.com/charts. Single source of truth for the category navigation and the
  per-category list of chart cards.

  Each card is a map `%{title, description, type, data, footer, keys, variant, legend}`.
  `keys`/`variant`/`legend` drive the SVG engine's style (e.g. linear vs. step vs. stacked
  lines, grouped vs. horizontal vs. negative bars, donut-with-text, lines-only radar) so the
  cards within a category render the distinct styles shown in the reference. Datasets mirror
  the canonical shadcn chart data (desktop/mobile visitors; browser share).
  """

  @categories [
    {"area", "Area Charts"},
    {"bar", "Bar Charts"},
    {"line", "Line Charts"},
    {"pie", "Pie Charts"},
    {"radar", "Radar Charts"},
    {"radial", "Radial Charts"},
    {"tooltip", "Tooltips"}
  ]

  @six "Showing total visitors for the last 6 months"
  @three "Showing total visitors for the last 3 months"
  @trend "Trending up by 5.2% this month"
  @range "January - June 2024"
  @desktop_mobile ["desktop", "mobile"]
  # Monochrome, theme-matched series colors (CSS var names resolved by the chart hook).
  @mono ["--foreground"]
  @mono2 ["--foreground", "--muted-foreground"]

  @doc "All categories as `{slug, title}`, in nav order."
  def categories, do: @categories

  @doc "True when `slug` is a known chart category."
  def category?(slug), do: Enum.any?(@categories, fn {s, _t} -> s == slug end)

  @doc "Display title for a category slug (or the slug itself if unknown)."
  def category_title(slug) do
    case Enum.find(@categories, fn {s, _t} -> s == slug end) do
      {_s, title} -> title
      nil -> slug
    end
  end

  # ---- Datasets -------------------------------------------------------------

  defp months do
    [
      %{label: "Jan", value: 186},
      %{label: "Feb", value: 305},
      %{label: "Mar", value: 237},
      %{label: "Apr", value: 73},
      %{label: "May", value: 209},
      %{label: "Jun", value: 214}
    ]
  end

  defp months2 do
    [
      %{label: "Jan", desktop: 186, mobile: 80},
      %{label: "Feb", desktop: 305, mobile: 200},
      %{label: "Mar", desktop: 237, mobile: 120},
      %{label: "Apr", desktop: 73, mobile: 190},
      %{label: "May", desktop: 209, mobile: 130},
      %{label: "Jun", desktop: 214, mobile: 140}
    ]
  end

  defp months_negative do
    [
      %{label: "Jan", value: 186},
      %{label: "Feb", value: 205},
      %{label: "Mar", value: -207},
      %{label: "Apr", value: 173},
      %{label: "May", value: -209},
      %{label: "Jun", value: 214}
    ]
  end

  # Abbreviated month axes for radar — single-series (`value`) and two-series variants.
  defp axes do
    Enum.map(months(), fn row -> %{row | label: String.slice(row.label, 0, 3)} end)
  end

  defp axes2 do
    Enum.map(months2(), fn row -> %{row | label: String.slice(row.label, 0, 3)} end)
  end

  defp browsers do
    [
      %{label: "Chrome", value: 275},
      %{label: "Safari", value: 200},
      %{label: "Firefox", value: 287},
      %{label: "Edge", value: 173},
      %{label: "Other", value: 190}
    ]
  end

  # ~3 months of daily desktop/mobile visitors (ISO date labels → datetime x-axis).
  # Values are deterministic (phash) so the chart is stable across renders.
  defp daily_3mo do
    start = ~D[2024-03-31]

    for i <- 1..91 do
      date = Date.add(start, i)

      %{
        label: Date.to_iso8601(date),
        desktop: 120 + rem(:erlang.phash2({i, :desktop}), 380),
        mobile: 90 + rem(:erlang.phash2({i, :mobile}), 320)
      }
    end
  end

  # ---- Cards ----------------------------------------------------------------

  @doc "The chart cards for a category, each a map (see the moduledoc for the shape)."
  def cards("area") do
    t = {:trend, @trend, @range}

    [
      card("Area Chart - Interactive", @three, "area", daily_3mo(), nil,
        full_width: true,
        variant: "stacked",
        keys: ["desktop", "mobile"],
        legend: true,
        range_select: true,
        colors: ["--foreground", "--muted-foreground"]
      ),
      card("Area Chart", @six, "area", months(), t, colors: @mono),
      card("Area Chart - Linear", @six, "area", months(), t, variant: "linear", colors: @mono),
      card("Area Chart - Step", @six, "area", months(), t, variant: "step", colors: @mono),
      card("Area Chart - Legend", @six, "area", months2(), t,
        variant: "stacked",
        keys: @desktop_mobile,
        legend: true,
        colors: @mono2
      ),
      card("Area Chart - Stacked", @six, "area", months2(), t,
        variant: "stacked",
        keys: @desktop_mobile,
        colors: @mono2
      ),
      card("Area Chart - Stacked Expanded", @six, "area", months2(), t,
        variant: "expanded",
        keys: @desktop_mobile,
        colors: @mono2
      ),
      card("Area Chart - Icons", @six, "area", months2(), t,
        variant: "stacked",
        keys: @desktop_mobile,
        legend: true,
        colors: @mono2
      ),
      card("Area Chart - Gradient", @six, "area", months(), t,
        variant: "gradient",
        colors: @mono
      ),
      card("Area Chart - Axes", @six, "area", months(), t, colors: @mono)
    ]
  end

  def cards("bar") do
    [
      card("Bar Chart - Interactive", @three, "bar", daily_3mo(), nil,
        full_width: true,
        keys: @desktop_mobile,
        series_toggle: true
      ),
      card("Bar Chart", @six, "bar", months(), nil),
      card("Bar Chart - Horizontal", @six, "bar", months(), nil, variant: "horizontal"),
      card("Bar Chart - Multiple", @six, "bar", months2(), nil,
        variant: "multiple",
        keys: @desktop_mobile
      ),
      card("Bar Chart - Stacked + Legend", @six, "bar", months2(), nil,
        variant: "stacked",
        keys: @desktop_mobile,
        legend: true
      ),
      card("Bar Chart - Label", @six, "bar", months(), nil, variant: "label"),
      card("Bar Chart - Custom Label", @six, "bar", months(), nil, variant: "custom-label"),
      card("Bar Chart - Mixed", @six, "bar", months(), nil, variant: "mixed"),
      card("Bar Chart - Active", @six, "bar", months(), nil, variant: "active"),
      card("Bar Chart - Negative", @six, "bar", months_negative(), nil, variant: "negative")
    ]
  end

  def cards("line") do
    t = {:trend, @trend, @range}

    [
      card("Line Chart - Interactive", @three, "line", daily_3mo(), nil,
        full_width: true,
        keys: @desktop_mobile,
        series_toggle: true
      ),
      card("Line Chart", @six, "line", months(), t),
      card("Line Chart - Linear", @six, "line", months(), t, variant: "linear"),
      card("Line Chart - Step", @six, "line", months(), t, variant: "step"),
      card("Line Chart - Multiple", @six, "line", months2(), t,
        variant: "multiple",
        keys: @desktop_mobile
      ),
      card("Line Chart - Dots", @six, "line", months(), t, variant: "dots"),
      card("Line Chart - Dots Custom", @six, "line", months(), t, variant: "dots-custom"),
      card("Line Chart - Dots Colors", @six, "line", months(), t, variant: "dots-colors"),
      card("Line Chart - Label", @six, "line", months(), t, variant: "label"),
      card("Line Chart - Custom Label", @six, "line", months(), t, variant: "custom-label")
    ]
  end

  def cards("pie") do
    note = {:note, @six}

    [
      card("Pie Chart", @range, "pie", browsers(), note),
      card("Pie Chart - Label", @range, "pie", browsers(), note, variant: "label"),
      card("Pie Chart - Custom Label", @range, "pie", browsers(), note, variant: "custom-label"),
      card("Pie Chart - Label List", @range, "pie", browsers(), note, variant: "label-list"),
      card("Pie Chart - Legend", @range, "pie", browsers(), note, legend: true),
      card("Pie Chart - Donut", @range, "donut", browsers(), note),
      card("Pie Chart - Donut Active", @range, "donut", browsers(), note,
        variant: "donut-active"
      ),
      card("Pie Chart - Donut with Text", @range, "donut", browsers(), note,
        variant: "donut-text"
      ),
      card("Pie Chart - Stacked", @range, "pie", browsers(), note, variant: "stacked"),
      card("Pie Chart - Interactive", @range, "donut", browsers(), note, variant: "donut-active")
    ]
  end

  def cards("radar") do
    t = {:trend, @trend}

    [
      card("Radar Chart", @six, "radar", axes(), t),
      card("Radar Chart - Dots", @six, "radar", axes(), t, variant: "dots"),
      card("Radar Chart - Lines Only", @six, "radar", axes(), t, variant: "lines-only"),
      card("Radar Chart - Custom Label", @six, "radar", axes(), t),
      card("Radar Chart - Grid Custom", @six, "radar", axes(), t, variant: "grid-filled"),
      card("Radar Chart - Grid None", @six, "radar", axes(), t, variant: "grid-none"),
      card("Radar Chart - Grid Circle", @six, "radar", axes(), t, variant: "grid-circle"),
      card("Radar Chart - Grid Circle - No Lines", @six, "radar", axes(), t,
        variant: "grid-circle-no-lines"
      ),
      card("Radar Chart - Grid Circle Filled", @six, "radar", axes(), t,
        variant: "grid-circle-filled"
      ),
      card("Radar Chart - Grid Filled", @six, "radar", axes(), t, variant: "grid-filled"),
      card("Radar Chart - Multiple", @six, "radar", axes2(), t,
        variant: "multiple",
        keys: @desktop_mobile
      ),
      card("Radar Chart - Legend", @six, "radar", axes2(), t,
        variant: "multiple",
        keys: @desktop_mobile,
        legend: true
      )
    ]
  end

  def cards("radial") do
    t = {:trend, @trend, @range}
    single = [%{label: "Visitors", value: 1260}]
    duo = [%{label: "Visitors", desktop: 1260, mobile: 570}]

    [
      card("Radial Chart", @six, "radial", browsers(), t),
      card("Radial Chart - Label", @six, "radial", single, t, variant: "label"),
      card("Radial Chart - Text", @six, "radial", browsers(), t, variant: "text"),
      card("Radial Chart - Shape", @six, "radial", single, t, variant: "shape"),
      card("Radial Chart - Stacked", @six, "radial", duo, t,
        variant: "stacked",
        keys: ["desktop", "mobile"]
      )
    ]
  end

  def cards("tooltip") do
    [
      card("Tooltip - Default", "Default tooltip.", "bar", months(), nil),
      card("Tooltip - Line Indicator", "Tooltip with line indicator.", "bar", months(), nil,
        variant: "tip-line"
      ),
      card("Tooltip - No Indicator", "Tooltip with no indicator.", "bar", months(), nil,
        variant: "tip-none"
      ),
      card("Tooltip - Custom Label", "Tooltip with custom label.", "bar", months(), nil,
        variant: "tip-custom-label"
      ),
      card("Tooltip - Label Formatter", "Tooltip with label formatter.", "bar", months(), nil,
        variant: "tip-label-formatter"
      ),
      card("Tooltip - No Label", "Tooltip with no label.", "bar", months(), nil,
        variant: "tip-no-label"
      ),
      card("Tooltip - Formatter", "Tooltip with custom formatter.", "bar", months(), nil,
        variant: "tip-formatter"
      ),
      card("Tooltip - Icons", "Tooltip with icons.", "bar", months(), nil, variant: "tip-icons"),
      card("Tooltip - Advanced", "Tooltip with custom formatter and total.", "bar", months(), nil,
        variant: "tip-advanced"
      )
    ]
  end

  def cards(_), do: []

  defp card(title, description, type, data, footer, opts \\ []) do
    %{
      title: title,
      description: description,
      type: type,
      data: data,
      footer: footer,
      keys: Keyword.get(opts, :keys, ["value"]),
      variant: Keyword.get(opts, :variant),
      legend: Keyword.get(opts, :legend, false),
      full_width: Keyword.get(opts, :full_width, false),
      range_select: Keyword.get(opts, :range_select, false),
      series_toggle: Keyword.get(opts, :series_toggle, false),
      # Default every chart to monochrome, theme-matched colors (the hook expands a single
      # color into shades for multi-slice charts). An explicit `colors:` overrides this.
      colors: Keyword.get(opts, :colors) || default_colors(Keyword.get(opts, :keys, ["value"]))
    }
  end

  defp default_colors(keys) when length(keys) > 1, do: @mono2
  defp default_colors(_keys), do: @mono
end
