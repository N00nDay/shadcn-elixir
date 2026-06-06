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

  def component("accordion") do
    %{
      slug: "accordion",
      title: "Accordion",
      description:
        "A vertically stacked set of interactive headings that each reveal a section of content. " <>
          "Built on native `<details>`/`<summary>` — no JavaScript.",
      examples: [%{key: "accordion_default", title: "Default", description: nil}],
      props: [
        %{label: "accordion", module: C.Accordion, fun: :accordion},
        %{label: "accordion_item", module: C.Accordion, fun: :accordion_item},
        %{label: "accordion_trigger", module: C.Accordion, fun: :accordion_trigger},
        %{label: "accordion_content", module: C.Accordion, fun: :accordion_content}
      ]
    }
  end

  def component("alert") do
    %{
      slug: "alert",
      title: "Alert",
      description: "Displays a callout for user attention.",
      examples: [
        %{key: "alert_default", title: "Default", description: nil},
        %{key: "alert_destructive", title: "Destructive", description: nil}
      ],
      props: [
        %{label: "alert", module: C.Alert, fun: :alert},
        %{label: "alert_title", module: C.Alert, fun: :alert_title},
        %{label: "alert_description", module: C.Alert, fun: :alert_description}
      ]
    }
  end

  def component("aspect_ratio") do
    %{
      slug: "aspect_ratio",
      title: "Aspect Ratio",
      description: "Displays content within a desired ratio.",
      examples: [%{key: "aspect_ratio_default", title: "Default", description: nil}],
      props: [%{label: "aspect_ratio", module: C.AspectRatio, fun: :aspect_ratio}]
    }
  end

  def component("avatar") do
    %{
      slug: "avatar",
      title: "Avatar",
      description: "An image element with a fallback for representing the user.",
      examples: [
        %{key: "avatar_default", title: "Default", description: nil},
        %{
          key: "avatar_overlap",
          title: "Group",
          description: "Overlap several avatars with an overflow count."
        }
      ],
      props: [
        %{label: "avatar", module: C.Avatar, fun: :avatar},
        %{label: "avatar_image", module: C.Avatar, fun: :avatar_image},
        %{label: "avatar_fallback", module: C.Avatar, fun: :avatar_fallback}
      ]
    }
  end

  def component("badge") do
    %{
      slug: "badge",
      title: "Badge",
      description: "Displays a badge or a component that looks like a badge.",
      examples: [
        %{key: "badge_default", title: "Default", description: nil},
        %{
          key: "badge_variants",
          title: "Variants",
          description: "Set the visual style with the `variant` attribute."
        }
      ],
      props: [%{label: "badge", module: C.Badge, fun: :badge}]
    }
  end

  def component("checkbox") do
    %{
      slug: "checkbox",
      title: "Checkbox",
      description:
        "A control that allows the user to toggle between checked and not checked. " <>
          "Renders a real `<input type=\"checkbox\">`, so it submits with forms — no JavaScript.",
      examples: [%{key: "checkbox_default", title: "Default", description: nil}],
      props: [%{label: "checkbox", module: C.Checkbox, fun: :checkbox}]
    }
  end

  def component("kbd") do
    %{
      slug: "kbd",
      title: "Kbd",
      description: "Displays a keyboard key or a combination of keys.",
      examples: [%{key: "kbd_default", title: "Default", description: nil}],
      props: [
        %{label: "kbd", module: C.Kbd, fun: :kbd},
        %{label: "kbd_group", module: C.Kbd, fun: :kbd_group}
      ]
    }
  end

  def component("separator") do
    %{
      slug: "separator",
      title: "Separator",
      description: "Visually or semantically separates content.",
      examples: [%{key: "separator_default", title: "Default", description: nil}],
      props: [%{label: "separator", module: C.Separator, fun: :separator}]
    }
  end

  def component("skeleton") do
    %{
      slug: "skeleton",
      title: "Skeleton",
      description: "Use to show a placeholder while content is loading.",
      examples: [%{key: "skeleton_default", title: "Default", description: nil}],
      props: [%{label: "skeleton", module: C.Skeleton, fun: :skeleton}]
    }
  end

  def component("switch") do
    %{
      slug: "switch",
      title: "Switch",
      description:
        "A control that toggles between on and off. Renders a real checkbox, so it " <>
          "submits with forms — no JavaScript.",
      examples: [%{key: "switch_default", title: "Default", description: nil}],
      props: [%{label: "switch", module: C.Switch, fun: :switch}]
    }
  end

  def component("textarea") do
    %{
      slug: "textarea",
      title: "Textarea",
      description: "Displays a form textarea or a component that looks like a textarea.",
      examples: [
        %{key: "textarea_default", title: "Default", description: nil},
        %{key: "textarea_with_label", title: "With label", description: nil}
      ],
      props: [%{label: "textarea", module: C.Textarea, fun: :textarea}]
    }
  end

  def component("tooltip") do
    %{
      slug: "tooltip",
      title: "Tooltip",
      description:
        "A popup that displays information related to an element when it receives " <>
          "keyboard focus or the mouse hovers over it. Pure CSS — no JavaScript.",
      examples: [%{key: "tooltip_default", title: "Default", description: nil}],
      props: [
        %{label: "tooltip", module: C.Tooltip, fun: :tooltip},
        %{label: "tooltip_trigger", module: C.Tooltip, fun: :tooltip_trigger},
        %{label: "tooltip_content", module: C.Tooltip, fun: :tooltip_content}
      ]
    }
  end

  def component("input") do
    %{
      slug: "input",
      title: "Input",
      description: "Displays a form input field or a component that looks like an input field.",
      examples: [%{key: "input_default", title: "Default", description: nil}],
      props: [%{label: "input", module: C.Input, fun: :input}]
    }
  end

  def component("label") do
    %{
      slug: "label",
      title: "Label",
      description: "Renders an accessible label associated with controls.",
      examples: [%{key: "label_default", title: "Default", description: nil}],
      props: [%{label: "label", module: C.Label, fun: :label}]
    }
  end

  def component("radio_group") do
    %{
      slug: "radio_group",
      title: "Radio Group",
      description:
        "A set of checkable buttons where no more than one can be checked at a time. " <>
          "Renders real radio inputs — no JavaScript.",
      examples: [%{key: "radio_group_default", title: "Default", description: nil}],
      props: [
        %{label: "radio_group", module: C.RadioGroup, fun: :radio_group},
        %{label: "radio_group_item", module: C.RadioGroup, fun: :radio_group_item}
      ]
    }
  end

  def component("progress") do
    %{
      slug: "progress",
      title: "Progress",
      description: "Displays an indicator showing the completion progress of a task.",
      examples: [%{key: "progress_default", title: "Default", description: nil}],
      props: [%{label: "progress", module: C.Progress, fun: :progress}]
    }
  end

  def component("native_select") do
    %{
      slug: "native_select",
      title: "Native Select",
      description: "A styled native select for when a real form control is preferable.",
      examples: [%{key: "native_select_default", title: "Default", description: nil}],
      props: [%{label: "native_select", module: C.NativeSelect, fun: :native_select}]
    }
  end

  def component("table") do
    %{
      slug: "table",
      title: "Table",
      description: "A responsive table component.",
      examples: [%{key: "table_default", title: "Default", description: nil}],
      props: [
        %{label: "table", module: C.Table, fun: :table},
        %{label: "table_header", module: C.Table, fun: :table_header},
        %{label: "table_body", module: C.Table, fun: :table_body},
        %{label: "table_row", module: C.Table, fun: :table_row},
        %{label: "table_head", module: C.Table, fun: :table_head},
        %{label: "table_cell", module: C.Table, fun: :table_cell},
        %{label: "table_caption", module: C.Table, fun: :table_caption}
      ]
    }
  end

  def component("breadcrumb") do
    %{
      slug: "breadcrumb",
      title: "Breadcrumb",
      description: "Displays the path to the current resource using a hierarchy of links.",
      examples: [%{key: "breadcrumb_default", title: "Default", description: nil}],
      props: [
        %{label: "breadcrumb", module: C.Breadcrumb, fun: :breadcrumb},
        %{label: "breadcrumb_list", module: C.Breadcrumb, fun: :breadcrumb_list},
        %{label: "breadcrumb_item", module: C.Breadcrumb, fun: :breadcrumb_item},
        %{label: "breadcrumb_link", module: C.Breadcrumb, fun: :breadcrumb_link},
        %{label: "breadcrumb_page", module: C.Breadcrumb, fun: :breadcrumb_page},
        %{label: "breadcrumb_separator", module: C.Breadcrumb, fun: :breadcrumb_separator}
      ]
    }
  end

  def component("alert_dialog") do
    %{
      slug: "alert_dialog",
      title: "Alert Dialog",
      description:
        "A modal dialog that interrupts the user with important content and expects a response.",
      examples: [%{key: "alert_dialog_default", title: "Default", description: nil}],
      props: [
        %{label: "alert_dialog", module: C.AlertDialog, fun: :alert_dialog},
        %{label: "alert_dialog_content", module: C.AlertDialog, fun: :alert_dialog_content},
        %{label: "alert_dialog_action", module: C.AlertDialog, fun: :alert_dialog_action},
        %{label: "alert_dialog_cancel", module: C.AlertDialog, fun: :alert_dialog_cancel}
      ]
    }
  end

  def component("dropdown_menu") do
    %{
      slug: "dropdown_menu",
      title: "Dropdown Menu",
      description:
        "Displays a menu to the user — such as a set of actions or functions — triggered by a button.",
      examples: [%{key: "dropdown_menu_default", title: "Default", description: nil}],
      props: [
        %{label: "dropdown_menu", module: C.DropdownMenu, fun: :dropdown_menu},
        %{label: "dropdown_menu_content", module: C.DropdownMenu, fun: :dropdown_menu_content},
        %{label: "dropdown_menu_item", module: C.DropdownMenu, fun: :dropdown_menu_item}
      ]
    }
  end

  def component("tabs") do
    %{
      slug: "tabs",
      title: "Tabs",
      description: "A set of layered sections of content displayed one panel at a time.",
      examples: [%{key: "tabs_default", title: "Default", description: nil}],
      props: [
        %{label: "tabs", module: C.Tabs, fun: :tabs},
        %{label: "tabs_list", module: C.Tabs, fun: :tabs_list},
        %{label: "tabs_trigger", module: C.Tabs, fun: :tabs_trigger},
        %{label: "tabs_content", module: C.Tabs, fun: :tabs_content}
      ]
    }
  end

  def component(_), do: nil
end
