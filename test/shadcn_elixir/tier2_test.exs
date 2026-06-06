defmodule ShadcnElixir.Tier2Test do
  @moduledoc "Smoke + markup tests for Tier 2 (overlay/floating) components."
  use ExUnit.Case, async: true

  use ShadcnElixir
  import Phoenix.Component
  import Phoenix.LiveViewTest

  test "dialog renders overlay + content with modal semantics, hidden by default" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.dialog id="d">
        <.dialog_trigger dialog="d"><.button>Open</.button></.dialog_trigger>
        <.dialog_content dialog="d">
          <.dialog_header>
            <.dialog_title>T</.dialog_title>
            <.dialog_description>D</.dialog_description>
          </.dialog_header>
          <.dialog_footer><.button>Save</.button></.dialog_footer>
        </.dialog_content>
      </.dialog>
      """)

    assert html =~ ~s(id="d-overlay")
    assert html =~ ~s(id="d-content")
    assert html =~ ~s(role="dialog")
    assert html =~ ~s(aria-modal="true")
    assert html =~ ~s(phx-key="escape")
    assert html =~ "hidden"
  end

  test "alert_dialog renders action and cancel buttons" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.alert_dialog id="a">
        <.alert_dialog_content dialog="a">
          <.alert_dialog_footer>
            <.alert_dialog_cancel dialog="a">Cancel</.alert_dialog_cancel>
            <.alert_dialog_action dialog="a">Continue</.alert_dialog_action>
          </.alert_dialog_footer>
        </.alert_dialog_content>
      </.alert_dialog>
      """)

    assert html =~ ~s(role="alertdialog")
    assert html =~ "Cancel"
    assert html =~ "Continue"
  end

  test "sheet content has a side" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.sheet id="s">
        <.sheet_content dialog="s" side="left">x</.sheet_content>
      </.sheet>
      """)

    assert html =~ ~s(data-side="left")
    # left sheet slides in from the left edge: off-screen when closed, translate-0 when open
    assert html =~ "-translate-x-full"
    assert html =~ "data-[state=open]:translate-x-0"
  end

  test "drawer renders a handle" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.drawer id="dr"><.drawer_content dialog="dr">x</.drawer_content></.drawer>
      """)

    assert html =~ ~s(data-slot="drawer-content")
    assert html =~ "rounded-t-lg"
  end

  test "popover toggles and dismisses on click-away" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.popover id="p">
        <.popover_trigger popover="p"><.button>Open</.button></.popover_trigger>
        <.popover_content popover="p">content</.popover_content>
      </.popover>
      """)

    assert html =~ ~s(id="p-content")
    assert html =~ "phx-click-away"
    assert html =~ "bg-popover"
  end

  test "tooltip is pure-CSS hover reveal" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.tooltip>
        <.tooltip_trigger>?</.tooltip_trigger>
        <.tooltip_content>Help</.tooltip_content>
      </.tooltip>
      """)

    assert html =~ ~s(role="tooltip")
    assert html =~ "group-hover/tooltip:opacity-100"
  end

  test "hover_card reveals content on hover" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.hover_card>
        <.hover_card_trigger>@u</.hover_card_trigger>
        <.hover_card_content>card</.hover_card_content>
      </.hover_card>
      """)

    assert html =~ "group-hover/hover-card:opacity-100"
  end

  test "dropdown_menu with items, label, separator, link item" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.dropdown_menu id="m">
        <.dropdown_menu_trigger menu="m"><.button>Open</.button></.dropdown_menu_trigger>
        <.dropdown_menu_content menu="m">
          <.dropdown_menu_label>Account</.dropdown_menu_label>
          <.dropdown_menu_item menu="m">Profile</.dropdown_menu_item>
          <.dropdown_menu_item menu="m" href="/logout">Logout</.dropdown_menu_item>
          <.dropdown_menu_separator />
          <.dropdown_menu_checkbox_item menu="m" checked>Status</.dropdown_menu_checkbox_item>
        </.dropdown_menu_content>
      </.dropdown_menu>
      """)

    assert html =~ ~s(role="menu")
    assert html =~ ~s(role="menuitem")
    assert html =~ ~s(href="/logout")
    assert html =~ ~s(role="menuitemcheckbox")
    assert html =~ ~s(aria-checked="true")
  end

  test "context_menu opens on contextmenu event" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.context_menu id="cm">
        <.context_menu_trigger>Right click</.context_menu_trigger>
        <.context_menu_content menu="cm">
          <.context_menu_item>Back</.context_menu_item>
        </.context_menu_content>
      </.context_menu>
      """)

    assert html =~ "oncontextmenu"
    assert html =~ "preventDefault"
    assert html =~ ~s(data-slot="context-menu-content")
  end

  test "menubar renders menus" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.menubar>
        <.menubar_menu id="mb1">
          <.menubar_trigger menu="mb1">File</.menubar_trigger>
          <.menubar_content menu="mb1"><.menubar_item>New</.menubar_item></.menubar_content>
        </.menubar_menu>
      </.menubar>
      """)

    assert html =~ ~s(role="menubar")
    assert html =~ "File"
    assert html =~ "New"
  end

  test "navigation_menu hover reveal" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.navigation_menu>
        <.navigation_menu_list>
          <.navigation_menu_item>
            <.navigation_menu_trigger>Products</.navigation_menu_trigger>
            <.navigation_menu_content>
              <.navigation_menu_link href="/a">A</.navigation_menu_link>
            </.navigation_menu_content>
          </.navigation_menu_item>
        </.navigation_menu_list>
      </.navigation_menu>
      """)

    assert html =~ ~s(data-slot="navigation-menu")
    assert html =~ "group-hover/nav-item:visible"
  end

  test "select renders hidden input, hook, trigger, items" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.select id="sel" name="fruit" value="apple">
        <.select_trigger select="sel"><.select_value placeholder="Pick" /></.select_trigger>
        <.select_content select="sel">
          <.select_item select="sel" value="apple">Apple</.select_item>
          <.select_item select="sel" value="banana">Banana</.select_item>
        </.select_content>
      </.select>
      """)

    assert html =~ ~s(phx-hook="ShadcnSelect")
    assert html =~ ~s(type="hidden")
    assert html =~ ~s(name="fruit")
    assert html =~ ~s(role="listbox")
    assert html =~ ~s(role="option")
    assert html =~ ~s(data-value="banana")
  end

  test "command renders input + list + empty + items" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.command id="cmd">
        <.command_input placeholder="Search" />
        <.command_list>
          <.command_empty>None</.command_empty>
          <.command_group heading="Suggestions">
            <.command_item value="calendar">Calendar</.command_item>
          </.command_group>
        </.command_list>
      </.command>
      """)

    assert html =~ ~s(phx-hook="ShadcnCommand")
    assert html =~ ~s(data-part="input")
    assert html =~ ~s(data-part="empty")
    assert html =~ "Calendar"
    assert html =~ "Suggestions"
  end

  test "combobox renders hook, hidden input, options" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.combobox id="cb" name="fw" placeholder="Pick framework">
        <:option value="next">Next.js</:option>
        <:option value="remix">Remix</:option>
      </.combobox>
      """)

    assert html =~ ~s(phx-hook="ShadcnCombobox")
    assert html =~ ~s(name="fw")
    assert html =~ ~s(data-value="next")
    assert html =~ "Next.js"
    assert html =~ ~s(data-part="search")
  end
end
