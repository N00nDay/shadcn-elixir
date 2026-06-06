defmodule DemoWeb.Docs do
  @moduledoc """
  The documentation registry. Single source of truth for the docs site navigation
  (getting-started pages + the full component list) and the per-component page specs
  (description, ordered examples, and which components' props tables to render).

  A component is "built" when `component/1` returns a spec; otherwise its sidebar
  entry links to a "coming soon" placeholder so the navigation is complete from day one.
  """

  alias ShadcnElixir.Components, as: C

  @getting_started [
    %{slug: "introduction", title: "Introduction"},
    %{slug: "installation", title: "Installation"},
    %{slug: "theming", title: "Theming"},
    %{slug: "dark-mode", title: "Dark Mode"}
  ]

  # The full component inventory (slug + display title), in alphabetical order.
  # `:built` is derived from whether `component/1` has a spec.
  @components [
    {"accordion", "Accordion"},
    {"alert", "Alert"},
    {"alert_dialog", "Alert Dialog"},
    {"aspect_ratio", "Aspect Ratio"},
    {"avatar", "Avatar"},
    {"badge", "Badge"},
    {"breadcrumb", "Breadcrumb"},
    {"button", "Button"},
    {"button_group", "Button Group"},
    {"calendar", "Calendar"},
    {"card", "Card"},
    {"carousel", "Carousel"},
    {"chart", "Chart"},
    {"checkbox", "Checkbox"},
    {"collapsible", "Collapsible"},
    {"combobox", "Combobox"},
    {"command", "Command"},
    {"context_menu", "Context Menu"},
    {"data_table", "Data Table"},
    {"date_picker", "Date Picker"},
    {"dialog", "Dialog"},
    {"drawer", "Drawer"},
    {"dropdown_menu", "Dropdown Menu"},
    {"empty", "Empty"},
    {"field", "Field"},
    {"hover_card", "Hover Card"},
    {"input", "Input"},
    {"input_group", "Input Group"},
    {"input_otp", "Input OTP"},
    {"item", "Item"},
    {"kbd", "Kbd"},
    {"label", "Label"},
    {"menubar", "Menubar"},
    {"native_select", "Native Select"},
    {"navigation_menu", "Navigation Menu"},
    {"pagination", "Pagination"},
    {"popover", "Popover"},
    {"progress", "Progress"},
    {"radio_group", "Radio Group"},
    {"resizable", "Resizable"},
    {"scroll_area", "Scroll Area"},
    {"select", "Select"},
    {"separator", "Separator"},
    {"sheet", "Sheet"},
    {"sidebar", "Sidebar"},
    {"skeleton", "Skeleton"},
    {"slider", "Slider"},
    {"sonner", "Sonner"},
    {"spinner", "Spinner"},
    {"switch", "Switch"},
    {"table", "Table"},
    {"tabs", "Tabs"},
    {"textarea", "Textarea"},
    {"toast", "Toast"},
    {"toggle", "Toggle"},
    {"toggle_group", "Toggle Group"},
    {"tooltip", "Tooltip"},
    {"typography", "Typography"}
  ]

  @doc "Getting-started pages, in sidebar order."
  def getting_started, do: @getting_started

  @doc "All components as `%{slug, title, built}` maps, in sidebar order."
  def components do
    Enum.map(@components, fn {slug, title} ->
      %{slug: slug, title: title, built: built?(slug)}
    end)
  end

  @doc "True when a component has a full documentation page."
  def built?(slug), do: component(slug) != nil

  @doc "Display title for a component slug (or the slug itself if unknown)."
  def title_for(slug) do
    case Enum.find(@components, fn {s, _t} -> s == slug end) do
      {_s, title} -> title
      nil -> slug
    end
  end

  @doc "Title for a getting-started page slug."
  def page_title(slug) do
    case Enum.find(@getting_started, &(&1.slug == slug)) do
      %{title: title} -> title
      nil -> slug
    end
  end

  @doc "True when `slug` is a known component (built or not)."
  def known_component?(slug), do: Enum.any?(@components, fn {s, _t} -> s == slug end)

  @doc """
  Returns the full page spec for a built component, or `nil`.

  Spec shape:

      %{
        slug: String.t(),
        title: String.t(),
        description: String.t(),
        examples: [%{key: String.t(), title: String.t(), description: String.t() | nil}],
        props: [%{label: String.t(), module: module(), fun: atom()}]
      }
  """
  def component("button") do
    %{
      slug: "button",
      title: "Button",
      description: "Displays a button or a component that looks like a button.",
      examples: [
        %{key: "button_default", title: "Default", description: nil},
        %{
          key: "button_variants",
          title: "Variants",
          description: "The six visual styles, set with the `variant` attribute."
        },
        %{
          key: "button_sizes",
          title: "Sizes",
          description: "Size presets via the `size` attribute, including icon-only buttons."
        },
        %{key: "button_with_icon", title: "With icon", description: nil},
        %{
          key: "button_link",
          title: "As a link",
          description:
            "Passing `href`, `navigate`, or `patch` renders an `<a>` instead of a `<button>`."
        }
      ],
      props: [%{label: "button", module: C.Button, fun: :button}]
    }
  end

  def component("card") do
    %{
      slug: "card",
      title: "Card",
      description: "Displays a card with header, content, and footer.",
      examples: [
        %{key: "card_default", title: "Default", description: nil},
        %{
          key: "card_with_action",
          title: "With action",
          description: "`card_action` is placed in the header's top-right via container queries."
        }
      ],
      props: [
        %{label: "card", module: C.Card, fun: :card},
        %{label: "card_header", module: C.Card, fun: :card_header},
        %{label: "card_title", module: C.Card, fun: :card_title},
        %{label: "card_description", module: C.Card, fun: :card_description},
        %{label: "card_action", module: C.Card, fun: :card_action},
        %{label: "card_content", module: C.Card, fun: :card_content},
        %{label: "card_footer", module: C.Card, fun: :card_footer}
      ]
    }
  end

  def component("dialog") do
    %{
      slug: "dialog",
      title: "Dialog",
      description:
        "A window overlaid on the primary window, rendering the content underneath inert. " <>
          "Open/close, scroll-lock, focus, escape, and click-outside are handled with " <>
          "`Phoenix.LiveView.JS` — no extra JS runtime.",
      examples: [
        %{key: "dialog_default", title: "Default", description: nil},
        %{
          key: "dialog_form",
          title: "With a form",
          description: "A typical edit dialog with fields and a footer of actions."
        }
      ],
      props: [
        %{label: "dialog", module: C.Dialog, fun: :dialog},
        %{label: "dialog_trigger", module: C.Dialog, fun: :dialog_trigger},
        %{label: "dialog_content", module: C.Dialog, fun: :dialog_content},
        %{label: "dialog_close", module: C.Dialog, fun: :dialog_close}
      ]
    }
  end

  def component(_), do: nil
end
