defmodule DemoWeb.Themes do
  @moduledoc """
  Base-color theme definitions (Neutral, Stone, Zinc, Gray, Slate), shared by the Theming
  docs page and the Charts page theme selector.

  Each base re-declares the shadcn color tokens for light (`:root`) and dark (`.dark`); the
  chart (`--chart-1..5`) and radius tokens are identical across every base, so they live
  here once. `base_theme/1` emits the full `:root {…} .dark {…}` CSS (for the docs page);
  `scoped_css/0` emits `[data-base="…"]` overrides so a subtree can be re-themed at runtime
  (for the charts selector). Neutral is the default `:root`, so it needs no scoped override.
  """

  @bases [
    {"neutral", "Neutral"},
    {"stone", "Stone"},
    {"zinc", "Zinc"},
    {"gray", "Gray"},
    {"slate", "Slate"}
  ]

  @doc "All bases as `{slug, title}`."
  def bases, do: @bases

  @doc "True when `slug` is a known base color."
  def base?(slug), do: Enum.any?(@bases, fn {s, _t} -> s == slug end)

  @doc "Display title for a base slug."
  def base_title(slug) do
    case Enum.find(@bases, fn {s, _t} -> s == slug end) do
      {_s, title} -> title
      nil -> slug
    end
  end

  # Chart + radius tokens are identical across every base color.
  @light_charts """
    --chart-1: oklch(0.646 0.222 41.116);
    --chart-2: oklch(0.6 0.118 184.704);
    --chart-3: oklch(0.398 0.07 227.392);
    --chart-4: oklch(0.828 0.189 84.429);
    --chart-5: oklch(0.769 0.188 70.08);
  """

  @dark_charts """
    --chart-1: oklch(0.488 0.243 264.376);
    --chart-2: oklch(0.696 0.17 162.48);
    --chart-3: oklch(0.769 0.188 70.08);
    --chart-4: oklch(0.627 0.265 303.9);
    --chart-5: oklch(0.645 0.246 16.439);
  """

  @doc "The `:root {…} .dark {…}` CSS for a base color (used by the Theming docs page)."
  def base_theme(base) do
    ":root {\n  --radius: 0.625rem;\n" <>
      light(base) <> @light_charts <> "}\n\n.dark {\n" <> dark(base) <> @dark_charts <> "}"
  end

  @doc """
  Scoped `[data-base="…"]` overrides for every non-default base, so a subtree carrying
  `data-base="stone"` re-themes its descendants (cards, text, charts) at runtime.
  """
  def scoped_css do
    @bases
    |> Enum.reject(fn {s, _t} -> s == "neutral" end)
    |> Enum.map_join("\n", fn {s, _t} ->
      ~s([data-base="#{s}"] {\n#{light(s)}}\n) <>
        ~s(.dark [data-base="#{s}"] {\n#{dark(s)}}\n)
    end)
  end

  # ---- Per-base color tokens ------------------------------------------------

  defp light("neutral"), do: neutral_light()
  defp light("stone"), do: stone_light()
  defp light("zinc"), do: zinc_light()
  defp light("gray"), do: gray_light()
  defp light("slate"), do: slate_light()

  defp dark("neutral"), do: neutral_dark()
  defp dark("stone"), do: stone_dark()
  defp dark("zinc"), do: zinc_dark()
  defp dark("gray"), do: gray_dark()
  defp dark("slate"), do: slate_dark()

  defp neutral_light do
    """
      --background: oklch(1 0 0);
      --foreground: oklch(0.145 0 0);
      --card: oklch(1 0 0);
      --card-foreground: oklch(0.145 0 0);
      --popover: oklch(1 0 0);
      --popover-foreground: oklch(0.145 0 0);
      --primary: oklch(0.205 0 0);
      --primary-foreground: oklch(0.985 0 0);
      --secondary: oklch(0.97 0 0);
      --secondary-foreground: oklch(0.205 0 0);
      --muted: oklch(0.97 0 0);
      --muted-foreground: oklch(0.556 0 0);
      --accent: oklch(0.97 0 0);
      --accent-foreground: oklch(0.205 0 0);
      --destructive: oklch(0.577 0.245 27.325);
      --border: oklch(0.922 0 0);
      --input: oklch(0.922 0 0);
      --ring: oklch(0.708 0 0);
      --sidebar: oklch(0.985 0 0);
      --sidebar-foreground: oklch(0.145 0 0);
      --sidebar-primary: oklch(0.205 0 0);
      --sidebar-primary-foreground: oklch(0.985 0 0);
      --sidebar-accent: oklch(0.97 0 0);
      --sidebar-accent-foreground: oklch(0.205 0 0);
      --sidebar-border: oklch(0.922 0 0);
      --sidebar-ring: oklch(0.708 0 0);
    """
  end

  defp neutral_dark do
    """
      --background: oklch(0.145 0 0);
      --foreground: oklch(0.985 0 0);
      --card: oklch(0.205 0 0);
      --card-foreground: oklch(0.985 0 0);
      --popover: oklch(0.205 0 0);
      --popover-foreground: oklch(0.985 0 0);
      --primary: oklch(0.922 0 0);
      --primary-foreground: oklch(0.205 0 0);
      --secondary: oklch(0.269 0 0);
      --secondary-foreground: oklch(0.985 0 0);
      --muted: oklch(0.269 0 0);
      --muted-foreground: oklch(0.708 0 0);
      --accent: oklch(0.269 0 0);
      --accent-foreground: oklch(0.985 0 0);
      --destructive: oklch(0.704 0.191 22.216);
      --border: oklch(1 0 0 / 10%);
      --input: oklch(1 0 0 / 15%);
      --ring: oklch(0.556 0 0);
      --sidebar: oklch(0.205 0 0);
      --sidebar-foreground: oklch(0.985 0 0);
      --sidebar-primary: oklch(0.488 0.243 264.376);
      --sidebar-primary-foreground: oklch(0.985 0 0);
      --sidebar-accent: oklch(0.269 0 0);
      --sidebar-accent-foreground: oklch(0.985 0 0);
      --sidebar-border: oklch(1 0 0 / 10%);
      --sidebar-ring: oklch(0.556 0 0);
    """
  end

  defp stone_light do
    """
      --background: oklch(1 0 0);
      --foreground: oklch(0.147 0.004 49.25);
      --card: oklch(1 0 0);
      --card-foreground: oklch(0.147 0.004 49.25);
      --popover: oklch(1 0 0);
      --popover-foreground: oklch(0.147 0.004 49.25);
      --primary: oklch(0.216 0.006 56.043);
      --primary-foreground: oklch(0.985 0.001 106.423);
      --secondary: oklch(0.97 0.001 106.424);
      --secondary-foreground: oklch(0.216 0.006 56.043);
      --muted: oklch(0.97 0.001 106.424);
      --muted-foreground: oklch(0.553 0.013 58.071);
      --accent: oklch(0.97 0.001 106.424);
      --accent-foreground: oklch(0.216 0.006 56.043);
      --destructive: oklch(0.577 0.245 27.325);
      --border: oklch(0.923 0.003 48.717);
      --input: oklch(0.923 0.003 48.717);
      --ring: oklch(0.709 0.01 56.259);
      --sidebar: oklch(0.985 0.001 106.423);
      --sidebar-foreground: oklch(0.147 0.004 49.25);
      --sidebar-primary: oklch(0.216 0.006 56.043);
      --sidebar-primary-foreground: oklch(0.985 0.001 106.423);
      --sidebar-accent: oklch(0.97 0.001 106.424);
      --sidebar-accent-foreground: oklch(0.216 0.006 56.043);
      --sidebar-border: oklch(0.923 0.003 48.717);
      --sidebar-ring: oklch(0.709 0.01 56.259);
    """
  end

  defp stone_dark do
    """
      --background: oklch(0.147 0.004 49.25);
      --foreground: oklch(0.985 0.001 106.423);
      --card: oklch(0.216 0.006 56.043);
      --card-foreground: oklch(0.985 0.001 106.423);
      --popover: oklch(0.216 0.006 56.043);
      --popover-foreground: oklch(0.985 0.001 106.423);
      --primary: oklch(0.923 0.003 48.717);
      --primary-foreground: oklch(0.216 0.006 56.043);
      --secondary: oklch(0.268 0.007 34.298);
      --secondary-foreground: oklch(0.985 0.001 106.423);
      --muted: oklch(0.268 0.007 34.298);
      --muted-foreground: oklch(0.709 0.01 56.259);
      --accent: oklch(0.268 0.007 34.298);
      --accent-foreground: oklch(0.985 0.001 106.423);
      --destructive: oklch(0.704 0.191 22.216);
      --border: oklch(1 0 0 / 10%);
      --input: oklch(1 0 0 / 15%);
      --ring: oklch(0.553 0.013 58.071);
      --sidebar: oklch(0.216 0.006 56.043);
      --sidebar-foreground: oklch(0.985 0.001 106.423);
      --sidebar-primary: oklch(0.488 0.243 264.376);
      --sidebar-primary-foreground: oklch(0.985 0.001 106.423);
      --sidebar-accent: oklch(0.268 0.007 34.298);
      --sidebar-accent-foreground: oklch(0.985 0.001 106.423);
      --sidebar-border: oklch(1 0 0 / 10%);
      --sidebar-ring: oklch(0.553 0.013 58.071);
    """
  end

  defp zinc_light do
    """
      --background: oklch(1 0 0);
      --foreground: oklch(0.141 0.005 285.823);
      --card: oklch(1 0 0);
      --card-foreground: oklch(0.141 0.005 285.823);
      --popover: oklch(1 0 0);
      --popover-foreground: oklch(0.141 0.005 285.823);
      --primary: oklch(0.21 0.006 285.885);
      --primary-foreground: oklch(0.985 0 0);
      --secondary: oklch(0.967 0.001 286.375);
      --secondary-foreground: oklch(0.21 0.006 285.885);
      --muted: oklch(0.967 0.001 286.375);
      --muted-foreground: oklch(0.552 0.016 285.938);
      --accent: oklch(0.967 0.001 286.375);
      --accent-foreground: oklch(0.21 0.006 285.885);
      --destructive: oklch(0.577 0.245 27.325);
      --border: oklch(0.92 0.004 286.32);
      --input: oklch(0.92 0.004 286.32);
      --ring: oklch(0.705 0.015 286.067);
      --sidebar: oklch(0.985 0 0);
      --sidebar-foreground: oklch(0.141 0.005 285.823);
      --sidebar-primary: oklch(0.21 0.006 285.885);
      --sidebar-primary-foreground: oklch(0.985 0 0);
      --sidebar-accent: oklch(0.967 0.001 286.375);
      --sidebar-accent-foreground: oklch(0.21 0.006 285.885);
      --sidebar-border: oklch(0.92 0.004 286.32);
      --sidebar-ring: oklch(0.705 0.015 286.067);
    """
  end

  defp zinc_dark do
    """
      --background: oklch(0.141 0.005 285.823);
      --foreground: oklch(0.985 0 0);
      --card: oklch(0.21 0.006 285.885);
      --card-foreground: oklch(0.985 0 0);
      --popover: oklch(0.21 0.006 285.885);
      --popover-foreground: oklch(0.985 0 0);
      --primary: oklch(0.92 0.004 286.32);
      --primary-foreground: oklch(0.21 0.006 285.885);
      --secondary: oklch(0.274 0.006 286.033);
      --secondary-foreground: oklch(0.985 0 0);
      --muted: oklch(0.274 0.006 286.033);
      --muted-foreground: oklch(0.705 0.015 286.067);
      --accent: oklch(0.274 0.006 286.033);
      --accent-foreground: oklch(0.985 0 0);
      --destructive: oklch(0.704 0.191 22.216);
      --border: oklch(1 0 0 / 10%);
      --input: oklch(1 0 0 / 15%);
      --ring: oklch(0.552 0.016 285.938);
      --sidebar: oklch(0.21 0.006 285.885);
      --sidebar-foreground: oklch(0.985 0 0);
      --sidebar-primary: oklch(0.488 0.243 264.376);
      --sidebar-primary-foreground: oklch(0.985 0 0);
      --sidebar-accent: oklch(0.274 0.006 286.033);
      --sidebar-accent-foreground: oklch(0.985 0 0);
      --sidebar-border: oklch(1 0 0 / 10%);
      --sidebar-ring: oklch(0.552 0.016 285.938);
    """
  end

  defp gray_light do
    """
      --background: oklch(1 0 0);
      --foreground: oklch(0.13 0.028 261.692);
      --card: oklch(1 0 0);
      --card-foreground: oklch(0.13 0.028 261.692);
      --popover: oklch(1 0 0);
      --popover-foreground: oklch(0.13 0.028 261.692);
      --primary: oklch(0.21 0.034 264.665);
      --primary-foreground: oklch(0.985 0.002 247.839);
      --secondary: oklch(0.967 0.003 264.542);
      --secondary-foreground: oklch(0.21 0.034 264.665);
      --muted: oklch(0.967 0.003 264.542);
      --muted-foreground: oklch(0.551 0.027 264.364);
      --accent: oklch(0.967 0.003 264.542);
      --accent-foreground: oklch(0.21 0.034 264.665);
      --destructive: oklch(0.577 0.245 27.325);
      --border: oklch(0.928 0.006 264.531);
      --input: oklch(0.928 0.006 264.531);
      --ring: oklch(0.707 0.022 261.325);
      --sidebar: oklch(0.985 0.002 247.839);
      --sidebar-foreground: oklch(0.13 0.028 261.692);
      --sidebar-primary: oklch(0.21 0.034 264.665);
      --sidebar-primary-foreground: oklch(0.985 0.002 247.839);
      --sidebar-accent: oklch(0.967 0.003 264.542);
      --sidebar-accent-foreground: oklch(0.21 0.034 264.665);
      --sidebar-border: oklch(0.928 0.006 264.531);
      --sidebar-ring: oklch(0.707 0.022 261.325);
    """
  end

  defp gray_dark do
    """
      --background: oklch(0.13 0.028 261.692);
      --foreground: oklch(0.985 0.002 247.839);
      --card: oklch(0.21 0.034 264.665);
      --card-foreground: oklch(0.985 0.002 247.839);
      --popover: oklch(0.21 0.034 264.665);
      --popover-foreground: oklch(0.985 0.002 247.839);
      --primary: oklch(0.928 0.006 264.531);
      --primary-foreground: oklch(0.21 0.034 264.665);
      --secondary: oklch(0.278 0.033 256.848);
      --secondary-foreground: oklch(0.985 0.002 247.839);
      --muted: oklch(0.278 0.033 256.848);
      --muted-foreground: oklch(0.707 0.022 261.325);
      --accent: oklch(0.278 0.033 256.848);
      --accent-foreground: oklch(0.985 0.002 247.839);
      --destructive: oklch(0.704 0.191 22.216);
      --border: oklch(1 0 0 / 10%);
      --input: oklch(1 0 0 / 15%);
      --ring: oklch(0.551 0.027 264.364);
      --sidebar: oklch(0.21 0.034 264.665);
      --sidebar-foreground: oklch(0.985 0.002 247.839);
      --sidebar-primary: oklch(0.488 0.243 264.376);
      --sidebar-primary-foreground: oklch(0.985 0.002 247.839);
      --sidebar-accent: oklch(0.278 0.033 256.848);
      --sidebar-accent-foreground: oklch(0.985 0.002 247.839);
      --sidebar-border: oklch(1 0 0 / 10%);
      --sidebar-ring: oklch(0.551 0.027 264.364);
    """
  end

  defp slate_light do
    """
      --background: oklch(1 0 0);
      --foreground: oklch(0.129 0.042 264.695);
      --card: oklch(1 0 0);
      --card-foreground: oklch(0.129 0.042 264.695);
      --popover: oklch(1 0 0);
      --popover-foreground: oklch(0.129 0.042 264.695);
      --primary: oklch(0.208 0.042 265.755);
      --primary-foreground: oklch(0.984 0.003 247.858);
      --secondary: oklch(0.968 0.007 247.896);
      --secondary-foreground: oklch(0.208 0.042 265.755);
      --muted: oklch(0.968 0.007 247.896);
      --muted-foreground: oklch(0.554 0.046 257.417);
      --accent: oklch(0.968 0.007 247.896);
      --accent-foreground: oklch(0.208 0.042 265.755);
      --destructive: oklch(0.577 0.245 27.325);
      --border: oklch(0.929 0.013 255.508);
      --input: oklch(0.929 0.013 255.508);
      --ring: oklch(0.704 0.04 256.788);
      --sidebar: oklch(0.984 0.003 247.858);
      --sidebar-foreground: oklch(0.129 0.042 264.695);
      --sidebar-primary: oklch(0.208 0.042 265.755);
      --sidebar-primary-foreground: oklch(0.984 0.003 247.858);
      --sidebar-accent: oklch(0.968 0.007 247.896);
      --sidebar-accent-foreground: oklch(0.208 0.042 265.755);
      --sidebar-border: oklch(0.929 0.013 255.508);
      --sidebar-ring: oklch(0.704 0.04 256.788);
    """
  end

  defp slate_dark do
    """
      --background: oklch(0.129 0.042 264.695);
      --foreground: oklch(0.984 0.003 247.858);
      --card: oklch(0.208 0.042 265.755);
      --card-foreground: oklch(0.984 0.003 247.858);
      --popover: oklch(0.208 0.042 265.755);
      --popover-foreground: oklch(0.984 0.003 247.858);
      --primary: oklch(0.929 0.013 255.508);
      --primary-foreground: oklch(0.208 0.042 265.755);
      --secondary: oklch(0.279 0.041 260.031);
      --secondary-foreground: oklch(0.984 0.003 247.858);
      --muted: oklch(0.279 0.041 260.031);
      --muted-foreground: oklch(0.704 0.04 256.788);
      --accent: oklch(0.279 0.041 260.031);
      --accent-foreground: oklch(0.984 0.003 247.858);
      --destructive: oklch(0.704 0.191 22.216);
      --border: oklch(1 0 0 / 10%);
      --input: oklch(1 0 0 / 15%);
      --ring: oklch(0.551 0.027 264.364);
      --sidebar: oklch(0.208 0.042 265.755);
      --sidebar-foreground: oklch(0.984 0.003 247.858);
      --sidebar-primary: oklch(0.488 0.243 264.376);
      --sidebar-primary-foreground: oklch(0.984 0.003 247.858);
      --sidebar-accent: oklch(0.279 0.041 260.031);
      --sidebar-accent-foreground: oklch(0.984 0.003 247.858);
      --sidebar-border: oklch(1 0 0 / 10%);
      --sidebar-ring: oklch(0.551 0.027 264.364);
    """
  end
end
