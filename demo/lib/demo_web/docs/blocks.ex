defmodule DemoWeb.Blocks do
  @moduledoc """
  Registry for the Blocks showcase (`/blocks/:category`), modeled on shadcn-svelte.com/blocks.

  A single source of truth for the category nav and the ordered list of blocks shown on each
  category page. Each block spec is `%{name, description, height}` where `name` is also the
  preview key looked up in `DemoWeb.Blocks.Previews` (the live preview + its View Code source).

  Mirrors the structure of `DemoWeb.Charts`.
  """

  # {slug, title}. "featured" is the index page; the rest match shadcn-svelte's
  # registry-categories (Dashboard + Authentication are hidden there, so omitted here).
  @categories [
    {"featured", "Featured"},
    {"sidebar", "Sidebar"},
    {"login", "Login"},
    {"sign-up", "Signup"},
    {"otp", "OTP"},
    {"calendar", "Calendar"}
  ]

  @doc "The category nav entries, in order."
  def categories, do: @categories

  @doc "True when `slug` is a known category."
  def category?(slug), do: Enum.any?(@categories, fn {s, _t} -> s == slug end)

  @doc "Human title for a category slug (falls back to the slug)."
  def category_title(slug) do
    case Enum.find(@categories, fn {s, _t} -> s == slug end) do
      {_s, title} -> title
      nil -> slug
    end
  end

  # --- Block specs -----------------------------------------------------------
  # Descriptions are the literal strings shadcn-svelte shows in the block toolbar; blocks
  # that show no description there (the newer signup/otp/login-05 blocks) carry `nil`.

  @blocks %{
    "dashboard-01" => "A dashboard with sidebar, charts and data table.",
    "sidebar-07" => "A sidebar that collapses to icons.",
    "sidebar-03" => "A sidebar with submenus.",
    "sidebar-01" => "A simple sidebar with navigation grouped by section.",
    "login-01" => "A simple login form.",
    "login-02" => "A login page with a muted background color.",
    "login-03" => "A login page with a background image.",
    "login-04" => "A login page with form and image.",
    "login-05" => nil,
    "signup-01" => nil,
    "signup-02" => nil,
    "signup-03" => nil,
    "signup-04" => nil,
    "signup-05" => nil,
    "otp-01" => nil,
    "otp-02" => nil,
    "otp-03" => nil,
    "otp-04" => nil,
    "otp-05" => nil,
    "calendar-01" => "A simple calendar.",
    "calendar-02" => "Multiple months with single selection.",
    "calendar-04" => "Single month with range selection.",
    "calendar-05" => "Multiple months with range selection."
  }

  # Per-block preview-frame height (shadcn default iframeHeight is 930px; calendars 600px).
  @heights %{
    "dashboard-01" => "998px",
    "login-02" => "760px",
    "signup-01" => "820px",
    "signup-02" => "880px",
    "otp-02" => "640px",
    "login-04" => "600px",
    "signup-04" => "800px",
    "otp-04" => "560px",
    "calendar-01" => "600px",
    "calendar-02" => "600px",
    "calendar-04" => "600px",
    "calendar-05" => "600px"
  }

  @featured ~w(dashboard-01 sidebar-07 sidebar-03 login-03 login-04)
  @sidebars ~w(sidebar-07 sidebar-03 sidebar-01)
  @logins ~w(login-01 login-02 login-03 login-04 login-05)
  @signups ~w(signup-01 signup-02 signup-03 signup-04 signup-05)
  @otps ~w(otp-01 otp-02 otp-03 otp-04 otp-05)
  @calendars ~w(calendar-01 calendar-02 calendar-04 calendar-05)

  @doc "Ordered block specs for a category."
  def blocks("featured"), do: specs(@featured)
  def blocks("sidebar"), do: specs(@sidebars)
  def blocks("login"), do: specs(@logins)
  def blocks("sign-up"), do: specs(@signups)
  def blocks("otp"), do: specs(@otps)
  def blocks("calendar"), do: specs(@calendars)
  def blocks(_), do: specs(@featured)

  defp specs(names) do
    Enum.map(names, fn name ->
      %{
        name: name,
        description: Map.get(@blocks, name),
        height: Map.get(@heights, name, "720px")
      }
    end)
  end
end
