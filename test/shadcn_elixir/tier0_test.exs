defmodule ShadcnElixir.Tier0Test do
  @moduledoc """
  Smoke + class-parity tests for all Tier 0 (static) components, rendered through the
  `use ShadcnElixir` aggregate import (which also proves there are no name clashes).
  """
  use ExUnit.Case, async: true

  use ShadcnElixir
  import Phoenix.Component
  import Phoenix.LiveViewTest

  test "separator renders with orientation data" do
    assigns = %{}
    html = rendered_to_string(~H|<.separator orientation="vertical" />|)
    assert html =~ ~s(data-orientation="vertical")
    assert html =~ "bg-border"
  end

  test "skeleton renders pulse classes" do
    assigns = %{}
    html = rendered_to_string(~H|<.skeleton class="h-4 w-10" />|)
    assert html =~ "animate-pulse"
    assert html =~ "h-4"
  end

  test "label renders for attribute" do
    assigns = %{}
    html = rendered_to_string(~H|<.label for="email">Email</.label>|)
    assert html =~ ~s(for="email")
    assert html =~ "Email"
  end

  test "spinner renders an animated status svg" do
    assigns = %{}
    html = rendered_to_string(~H|<.spinner />|)
    assert html =~ "animate-spin"
    assert html =~ ~s(role="status")
  end

  test "kbd and kbd_group render" do
    assigns = %{}
    html = rendered_to_string(~H|<.kbd_group><.kbd>Ctrl</.kbd></.kbd_group>|)
    assert html =~ "Ctrl"
    assert html =~ "<kbd"
  end

  test "aspect_ratio sets inline aspect-ratio" do
    assigns = %{}
    html = rendered_to_string(~H|<.aspect_ratio ratio="16/9">x</.aspect_ratio>|)
    assert html =~ "aspect-ratio: 16/9"
  end

  test "badge variants" do
    assigns = %{}
    assert rendered_to_string(~H|<.badge>New</.badge>|) =~ "bg-primary"
    assert rendered_to_string(~H|<.badge variant="destructive">x</.badge>|) =~ "bg-destructive"
  end

  test "card composition renders all parts" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.card>
        <.card_header>
          <.card_title>Title</.card_title>
          <.card_description>Desc</.card_description>
          <.card_action>A</.card_action>
        </.card_header>
        <.card_content>Body</.card_content>
        <.card_footer>Footer</.card_footer>
      </.card>
      """)

    for part <-
          ~w(card card-header card-title card-description card-action card-content card-footer) do
      assert html =~ ~s(data-slot="#{part}")
    end

    assert html =~ "Title"
    assert html =~ "Footer"
  end

  test "alert default and destructive" do
    assigns = %{}
    html = rendered_to_string(~H|<.alert><.alert_title>Hi</.alert_title></.alert>|)
    assert html =~ ~s(role="alert")
    assert rendered_to_string(~H|<.alert variant="destructive">x</.alert>|) =~ "text-destructive"
  end

  test "avatar with image and fallback" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.avatar>
        <.avatar_image src="/x.png" alt="x" />
        <.avatar_fallback>CN</.avatar_fallback>
      </.avatar>
      """)

    assert html =~ ~s(src="/x.png")
    assert html =~ "onerror"
    assert html =~ "CN"
  end

  test "input and textarea" do
    assigns = %{}
    assert rendered_to_string(~H|<.input type="email" />|) =~ ~s(type="email")
    assert rendered_to_string(~H|<.textarea value="hi" />|) =~ "hi"
  end

  test "native_select wraps a select with a chevron" do
    assigns = %{}
    html = rendered_to_string(~H|<.native_select name="f"><option>A</option></.native_select>|)
    assert html =~ "<select"
    assert html =~ "appearance-none"
    assert html =~ "<svg"
  end

  test "table composition" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.table>
        <.table_header><.table_row><.table_head>H</.table_head></.table_row></.table_header>
        <.table_body><.table_row><.table_cell>C</.table_cell></.table_row></.table_body>
      </.table>
      """)

    assert html =~ "<table"
    assert html =~ "<thead"
    assert html =~ "caption-bottom"
    assert html =~ "H"
    assert html =~ "C"
  end

  test "progress sets aria + transform" do
    assigns = %{}
    html = rendered_to_string(~H|<.progress value={60} />|)
    assert html =~ ~s(aria-valuenow="60")
    assert html =~ "translateX(-40%)"
  end

  test "breadcrumb composition" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.breadcrumb>
        <.breadcrumb_list>
          <.breadcrumb_item><.breadcrumb_link href="/">Home</.breadcrumb_link></.breadcrumb_item>
          <.breadcrumb_separator />
          <.breadcrumb_item><.breadcrumb_page>Now</.breadcrumb_page></.breadcrumb_item>
        </.breadcrumb_list>
      </.breadcrumb>
      """)

    assert html =~ ~s(aria-label="breadcrumb")
    assert html =~ ~s(aria-current="page")
    assert html =~ "Home"
  end

  test "pagination composition reuses button variants" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.pagination>
        <.pagination_content>
          <.pagination_item><.pagination_previous href="#" /></.pagination_item>
          <.pagination_item><.pagination_link href="#" is_active>1</.pagination_link></.pagination_item>
          <.pagination_item><.pagination_next href="#" /></.pagination_item>
        </.pagination_content>
      </.pagination>
      """)

    assert html =~ ~s(aria-label="pagination")
    assert html =~ ~s(aria-current="page")
    assert html =~ "Previous"
    assert html =~ "Next"
  end

  test "button_group, empty, field, input_group, item, typography render" do
    assigns = %{}

    assert rendered_to_string(~H|<.button_group><.button>A</.button></.button_group>|) =~
             ~s(role="group")

    assert rendered_to_string(~H|<.empty><.empty_title>None</.empty_title></.empty>|) =~ "None"

    assert rendered_to_string(~H|<.field><.field_label>L</.field_label></.field>|) =~
             ~s(data-slot="field")

    assert rendered_to_string(~H|<.input_group><.input_group_input /></.input_group>|) =~
             "input-group"

    assert rendered_to_string(~H|<.item><.item_title>T</.item_title></.item>|) =~
             ~s(data-slot="item")

    assert rendered_to_string(~H|<.typography_h1>Hi</.typography_h1>|) =~ "font-extrabold"
  end
end
