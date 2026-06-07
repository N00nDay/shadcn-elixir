defmodule DemoWeb.Create do
  @moduledoc """
  Registry for the Create page (`/create/:item`), modeled on shadcn-svelte.com/create — the
  "Rhea" design-system generator.

  This is the single source for the Customizer's option lists (styles, base colors, themes,
  chart colors, fonts, icon libraries, radii, menu colors/accents) and the preview switcher
  items. Values mirror shadcn-svelte's `registry/config.ts`. The full interactive generator is
  deferred; this gives the page a faithful structure to build on in future iterations.
  """

  # Preview switcher items (label shown on the pill, value is the route segment).
  @items [{"01", "preview-02"}, {"02", "preview"}]

  @doc "Preview switcher items, in order."
  def items, do: @items

  @doc "True when `slug` is a known preview item."
  def item?(slug), do: Enum.any?(@items, fn {_label, value} -> value == slug end)

  # --- Customizer option lists (mirror registry/config.ts) -------------------

  @styles [
    {"vega", "Vega"},
    {"nova", "Nova"},
    {"maia", "Maia"},
    {"lyra", "Lyra"}
  ]

  # Option lists are {slug, title, swatch_hex}. Values mirror shadcn-svelte's preset
  # (PRESET_BASE_COLORS / PRESET_THEMES); the token palettes they map to live in
  # `DemoWeb.Create.Themes`.
  @base_colors [
    {"neutral", "Neutral", "#737373"},
    {"stone", "Stone", "#79716B"},
    {"zinc", "Zinc", "#71717B"},
    {"mauve", "Mauve", "#79697B"},
    {"olive", "Olive", "#7C7C67"},
    {"mist", "Mist", "#67787C"},
    {"taupe", "Taupe", "#7C6D67"}
  ]

  # Accent themes (and the same set used for chart colors). "neutral" matches the base color.
  @themes [
    {"neutral", "Neutral", "#737373"},
    {"amber", "Amber", "#FD9A00"},
    {"blue", "Blue", "#2B7FFF"},
    {"cyan", "Cyan", "#00B8DB"},
    {"emerald", "Emerald", "#00BC7D"},
    {"fuchsia", "Fuchsia", "#E12AFB"},
    {"green", "Green", "#00C950"},
    {"indigo", "Indigo", "#615FFF"},
    {"lime", "Lime", "#7CCF00"},
    {"orange", "Orange", "#FF6900"},
    {"pink", "Pink", "#F6339A"},
    {"purple", "Purple", "#AD46FF"},
    {"red", "Red", "#FB2C36"},
    {"rose", "Rose", "#FF2056"},
    {"sky", "Sky", "#00A6F4"},
    {"teal", "Teal", "#00BBA7"},
    {"violet", "Violet", "#8E51FF"},
    {"yellow", "Yellow", "#EFB100"}
  ]

  # {slug, title, css_family}. Families resolve to Google Fonts names (loaded in CreateLive).
  @fonts [
    {"inter", "Inter", "'Inter', sans-serif"},
    {"geist", "Geist", "'Geist', sans-serif"},
    {"noto-sans", "Noto Sans", "'Noto Sans', sans-serif"},
    {"nunito-sans", "Nunito Sans", "'Nunito Sans', sans-serif"},
    {"figtree", "Figtree", "'Figtree', sans-serif"},
    {"roboto", "Roboto", "'Roboto', sans-serif"},
    {"raleway", "Raleway", "'Raleway', sans-serif"},
    {"dm-sans", "DM Sans", "'DM Sans', sans-serif"},
    {"public-sans", "Public Sans", "'Public Sans', sans-serif"},
    {"outfit", "Outfit", "'Outfit', sans-serif"},
    {"oxanium", "Oxanium", "'Oxanium', sans-serif"},
    {"manrope", "Manrope", "'Manrope', sans-serif"},
    {"space-grotesk", "Space Grotesk", "'Space Grotesk', sans-serif"},
    {"montserrat", "Montserrat", "'Montserrat', sans-serif"},
    {"ibm-plex-sans", "IBM Plex Sans", "'IBM Plex Sans', sans-serif"},
    {"source-sans-3", "Source Sans 3", "'Source Sans 3', sans-serif"},
    {"instrument-sans", "Instrument Sans", "'Instrument Sans', sans-serif"},
    {"jetbrains-mono", "JetBrains Mono", "'JetBrains Mono', monospace"},
    {"geist-mono", "Geist Mono", "'Geist Mono', monospace"},
    {"noto-serif", "Noto Serif", "'Noto Serif', serif"},
    {"roboto-slab", "Roboto Slab", "'Roboto Slab', serif"},
    {"merriweather", "Merriweather", "'Merriweather', serif"},
    {"lora", "Lora", "'Lora', serif"},
    {"playfair-display", "Playfair Display", "'Playfair Display', serif"},
    {"eb-garamond", "EB Garamond", "'EB Garamond', serif"},
    {"instrument-serif", "Instrument Serif", "'Instrument Serif', serif"}
  ]

  @icon_libraries [
    {"lucide", "Lucide"},
    {"tabler", "Tabler"},
    {"phosphor", "Phosphor"},
    {"remix", "Remix"}
  ]

  @radii [
    {"default", "Default"},
    {"none", "None"},
    {"small", "Small"},
    {"medium", "Medium"},
    {"large", "Large"}
  ]

  @menu_colors [
    {"default", "Default"},
    {"inverted", "Inverted"},
    {"default-translucent", "Default Translucent"},
    {"inverted-translucent", "Inverted Translucent"}
  ]

  @menu_accents [{"subtle", "Subtle"}, {"bold", "Bold"}]

  def styles, do: @styles
  def base_colors, do: @base_colors
  def themes, do: @themes
  def chart_colors, do: @themes
  def fonts, do: @fonts
  # Heading picker adds a "Default" (inherit body font) option at the top.
  def font_headings, do: [{"inherit", "Default"} | @fonts]
  def icon_libraries, do: @icon_libraries
  def radii, do: @radii
  def menu_colors, do: @menu_colors
  def menu_accents, do: @menu_accents

  @doc "CSS `--radius` value for a radius slug (mirrors shadcn's PRESET_RADII)."
  def radius_value("none"), do: "0rem"
  def radius_value("small"), do: "0.45rem"
  def radius_value("medium"), do: "0.625rem"
  def radius_value("large"), do: "0.875rem"
  def radius_value(_), do: "0.5rem"

  @doc "CSS font-family for a font slug (falls back to Inter)."
  def font_family(slug) do
    case Enum.find(@fonts, fn {s, _t, _f} -> s == slug end) do
      {_s, _t, family} -> family
      nil -> "'Inter', sans-serif"
    end
  end

  # Fonts that only ship a single (400) weight — requesting extra weights 400-errors the whole
  # css2 request, so they're loaded without a weight axis.
  @single_weight_fonts ["Instrument Serif"]

  @doc "Google Fonts `css2` URL that loads every selectable font family."
  def google_fonts_url do
    families =
      Enum.map_join(@fonts, "&", fn {_s, title, _f} ->
        name = String.replace(title, " ", "+")

        if title in @single_weight_fonts,
          do: "family=#{name}",
          else: "family=#{name}:wght@400;500;600;700"
      end)

    "https://fonts.googleapis.com/css2?" <> families <> "&display=swap"
  end

  @doc "Human title for a value in an option list (falls back to the slug). Lists may be {slug,
  title} or {slug, title, swatch_hex} tuples."
  def title(list, slug) do
    case Enum.find(list, fn opt -> elem(opt, 0) == slug end) do
      nil -> slug
      opt -> elem(opt, 1)
    end
  end
end
