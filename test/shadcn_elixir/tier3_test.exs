defmodule ShadcnElixir.Tier3Test do
  @moduledoc "Smoke + markup tests for Tier 3 (complex/stateful) components."
  use ExUnit.Case, async: true

  use ShadcnElixir
  import Phoenix.Component
  import Phoenix.LiveViewTest

  test "scroll_area renders themed scrollbar utilities" do
    assigns = %{}
    html = rendered_to_string(~H|<.scroll_area class="h-20">x</.scroll_area>|)
    assert html =~ ~s(data-slot="scroll-area")
    assert html =~ "overflow-auto"
  end

  test "slider is a native range input" do
    assigns = %{}
    html = rendered_to_string(~H|<.slider name="vol" value={50} />|)
    assert html =~ ~s(type="range")
    assert html =~ ~s(name="vol")
    assert html =~ "slider-thumb"
  end

  test "resizable renders panels and a handle with hook" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.resizable_panel_group id="rg">
        <.resizable_panel>A</.resizable_panel>
        <.resizable_handle with_handle />
        <.resizable_panel>B</.resizable_panel>
      </.resizable_panel_group>
      """)

    assert html =~ ~s(phx-hook="ShadcnResizable")
    assert html =~ ~s(data-part="handle")
    assert html =~ ~s(data-part="panel")
  end

  test "carousel renders track + nav buttons" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.carousel id="c">
        <.carousel_content>
          <.carousel_item>1</.carousel_item>
          <.carousel_item>2</.carousel_item>
        </.carousel_content>
        <.carousel_previous carousel="c" />
        <.carousel_next carousel="c" />
      </.carousel>
      """)

    assert html =~ ~s(aria-roledescription="carousel")
    assert html =~ ~s(data-part="track")
    assert html =~ "scrollBy"
  end

  test "input_otp renders slots + hidden value + hook" do
    assigns = %{}
    html = rendered_to_string(~H|<.input_otp id="otp" name="code" length={4} />|)
    assert html =~ ~s(phx-hook="ShadcnInputOTP")
    assert html =~ ~s(data-length="4")
    assert html =~ ~s(data-part="value")
    # 4 slot inputs
    assert length(String.split(html, ~s(data-part="slot"))) - 1 == 4
  end

  test "sidebar composition with collapsible trigger" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.sidebar_provider id="sb">
        <.sidebar>
          <.sidebar_header><.sidebar_trigger target="sb" /></.sidebar_header>
          <.sidebar_content>
            <.sidebar_group>
              <.sidebar_group_label>Main</.sidebar_group_label>
              <.sidebar_menu>
                <.sidebar_menu_item>
                  <.sidebar_menu_button href="/">Home</.sidebar_menu_button>
                </.sidebar_menu_item>
              </.sidebar_menu>
            </.sidebar_group>
          </.sidebar_content>
        </.sidebar>
        <.sidebar_inset>main</.sidebar_inset>
      </.sidebar_provider>
      """)

    assert html =~ ~s(data-slot="sidebar-provider")
    assert html =~ ~s(data-state="expanded")
    assert html =~ "phx-click"
    assert html =~ "Home"
  end

  test "data_table renders headers and rows from col slots" do
    assigns = %{rows: [%{name: "Ada", email: "ada@x.com"}, %{name: "Lin", email: "lin@x.com"}]}

    html =
      rendered_to_string(~H"""
      <.data_table rows={@rows}>
        <:col :let={r} label="Name">{r.name}</:col>
        <:col :let={r} label="Email">{r.email}</:col>
      </.data_table>
      """)

    assert html =~ "Name"
    assert html =~ "Email"
    assert html =~ "Ada"
    assert html =~ "lin@x.com"
  end

  test "data_table shows empty message when no rows" do
    assigns = %{rows: []}

    html =
      rendered_to_string(~H"""
      <.data_table rows={@rows} empty_message="Nothing here">
        <:col :let={r} label="Name">{r.name}</:col>
      </.data_table>
      """)

    assert html =~ "Nothing here"
  end

  test "calendar renders a month grid with weekday headers" do
    assigns = %{month: ~D[2026-06-15], selected: ~D[2026-06-10], today: ~D[2026-06-15]}

    html =
      rendered_to_string(~H"""
      <.calendar month={@month} selected={@selected} today={@today} on_select="pick" />
      """)

    assert html =~ "June 2026"
    assert html =~ "Su"
    assert html =~ "Sa"
    assert html =~ ~s(phx-value-date="2026-06-10")
    # selected day styling
    assert html =~ "bg-primary"
  end

  test "date_picker composes popover + calendar" do
    assigns = %{date: ~D[2026-06-10]}

    html =
      rendered_to_string(~H"""
      <.date_picker id="dp" selected={@date} month={@date} on_select="pick" />
      """)

    assert html =~ ~s(data-slot="popover")
    assert html =~ "June 10, 2026"
    assert html =~ "data-slot=\"calendar\""
  end

  test "chart embeds JSON data and the hook" do
    assigns = %{data: [%{label: "Jan", value: 10}, %{label: "Feb", value: 20}]}

    html = rendered_to_string(~H|<.chart id="c1" type="bar" data={@data} />|)
    assert html =~ ~s(phx-hook="ShadcnChart")
    assert html =~ ~s(data-chart-type="bar")
    assert html =~ "Jan"
    assert html =~ "&quot;value&quot;:20" or html =~ ~s("value":20)
  end

  test "toaster renders a hooked region" do
    assigns = %{}
    html = rendered_to_string(~H|<.toaster position="top-right" />|)
    assert html =~ ~s(phx-hook="ShadcnToaster")
    assert html =~ ~s(id="shadcn-toaster")
    assert html =~ "top-0 right-0"
  end

  test "toast static markup variants" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.toast variant="destructive">
        <.toast_title>Error</.toast_title>
        <.toast_description>Something failed</.toast_description>
        <.toast_close />
      </.toast>
      """)

    assert html =~ "bg-destructive"
    assert html =~ "Error"
    assert html =~ ~s(data-slot="toast-close")
  end
end
