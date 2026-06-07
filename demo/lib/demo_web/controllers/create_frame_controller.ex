defmodule DemoWeb.CreateFrameController do
  @moduledoc """
  Serves the Create page's preview as a self-contained, iframe-isolated HTML document.

  The body is shadcn-svelte's *actual* rendered `preview-02` markup (its `cn-*` slot classes),
  captured from a local build — one variant per icon library. The vendored compiled CSS
  (`/assets/create-preview.css`) carries every style's `cn-*` rules; base/theme/chart token
  values come from `DemoWeb.Create.Themes` scoped CSS. The customizer drives everything through
  the iframe's query string: changing a picker changes the `<iframe src>`, which re-renders the
  document with the new `style-*`/`base-color-*` classes, `data-base/theme/chart`, `--radius`,
  and font vars. CSS isolation (the iframe) lets us vendor shadcn's full CSS without it leaking
  into the rest of the app.
  """
  use DemoWeb, :controller

  alias DemoWeb.Create
  alias DemoWeb.Create.Themes

  @icon_libs ~w(lucide tabler phosphor remixicon)

  def show(conn, params) do
    style = pick(params["style"], Create.styles(), "vega")
    base = pick(params["base"], Create.base_colors(), "neutral")
    theme = pick(params["theme"], Create.themes(), "neutral")
    chart = pick(params["chart"], Create.chart_colors(), "neutral")
    radius = pick(params["radius"], Create.radii(), "default")
    font = pick(params["font"], Create.fonts(), "inter")
    heading = pick(params["heading"], Create.font_headings(), "inherit")
    menu_color = pick(params["menucolor"], Create.menu_colors(), "default")
    menu_accent = pick(params["menuaccent"], Create.menu_accents(), "subtle")
    icons = if params["icons"] in @icon_libs, do: params["icons"], else: "lucide"
    dark = params["dark"] == "1"

    heading_font = if heading == "inherit", do: font, else: heading

    body_html = File.read!(frame_path(icons))

    doc = """
    <!doctype html>
    <html lang="en" class="#{if dark, do: "dark ", else: ""}style-#{style} base-color-#{base}" \
    style="--radius: #{Create.radius_value(radius)}; --font-sans: #{Create.font_family(font)}; --font-heading: #{Create.font_family(heading_font)};">
    <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link rel="stylesheet" href="#{Create.google_fonts_url()}" />
    <link rel="stylesheet" href="/assets/create-preview.css" />
    <style>#{Themes.scoped_css()}</style>
    <style>
      html, body { margin: 0; font-family: var(--font-sans); }
      :is(h1,h2,h3,h4,h5,[data-slot=card-title],.cn-font-heading) { font-family: var(--font-heading); }
      .ds-scroll { scrollbar-width: thin; }
    </style>
    </head>
    <body class="bg-muted text-foreground dark:bg-background" data-base="#{base}" data-theme="#{theme}" data-chart="#{chart}" data-menu-color="#{menu_color}" data-menu-accent="#{menu_accent}">
    <div class="ds-scroll flex min-h-svh items-center overflow-auto bg-muted dark:bg-background [--gap:--spacing(4)] md:[--gap:--spacing(10)]">
    <div class="flex w-full min-w-max justify-center">
    #{body_html}
    </div>
    </div>
    </body>
    </html>
    """

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, doc)
  end

  defp pick(value, options, default) do
    if value && Enum.any?(options, fn opt -> elem(opt, 0) == value end), do: value, else: default
  end

  defp frame_path(icons),
    do: Application.app_dir(:demo, "priv/create_frames/preview-02-#{icons}.html")
end
