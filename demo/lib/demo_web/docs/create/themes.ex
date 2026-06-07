defmodule DemoWeb.Create.Themes do
  @moduledoc """
  Scoped CSS for the Create page's design-system pickers.

  The token values are ported from shadcn-svelte's `registry/themes.ts` (MIT): the full
  base-color palettes (7) plus the accent-theme and chart-color ramps (17 each). They're
  emitted as `[data-base=…]`, `[data-theme=…]`, and `[data-chart=…]` scoped rules (light + the
  `.dark` variant) so the Create preview re-themes live when a picker changes the wrapper's
  data attributes. Generated CSS lives in `theme_vars.css` (read at compile time).
  """
  @css_file Path.join(__DIR__, "theme_vars.css")
  @external_resource @css_file
  @css File.read!(@css_file)

  @doc "Scoped CSS for every base color / accent theme / chart color."
  def scoped_css, do: @css
end
