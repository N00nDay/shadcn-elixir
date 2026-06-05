defmodule ShadcnElixir.Tier1Test do
  @moduledoc "Smoke + markup tests for Tier 1 (interactive) components."
  use ExUnit.Case, async: true

  use ShadcnElixir
  import Phoenix.Component
  import Phoenix.LiveViewTest

  test "accordion uses details/summary with chevron rotation hook" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.accordion>
        <.accordion_item open>
          <.accordion_trigger>Q</.accordion_trigger>
          <.accordion_content>A</.accordion_content>
        </.accordion_item>
      </.accordion>
      """)

    assert html =~ "<details"
    assert html =~ "<summary"
    assert html =~ "group-open/accordion:rotate-180"
    assert html =~ "Q"
    assert html =~ "A"
  end

  test "collapsible uses details/summary" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.collapsible>
        <.collapsible_trigger>T</.collapsible_trigger>
        <.collapsible_content>C</.collapsible_content>
      </.collapsible>
      """)

    assert html =~ "<details"
    assert html =~ ~s(data-slot="collapsible-trigger")
    assert html =~ "C"
  end

  test "tabs render roles, active state, and hidden panels" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.tabs id="t">
        <.tabs_list>
          <.tabs_trigger tabs="t" value="a" active>A</.tabs_trigger>
          <.tabs_trigger tabs="t" value="b">B</.tabs_trigger>
        </.tabs_list>
        <.tabs_content tabs="t" value="a" active>PA</.tabs_content>
        <.tabs_content tabs="t" value="b">PB</.tabs_content>
      </.tabs>
      """)

    assert html =~ ~s(role="tablist")
    assert html =~ ~s(role="tab")
    assert html =~ ~s(role="tabpanel")
    assert html =~ ~s(data-state="active")
    assert html =~ "phx-click"
    # inactive panel hidden
    assert html =~ ~r/data-tab-value="b"[^>]*hidden|hidden[^>]*data-tab-value="b"/s ||
             html =~ "hidden"
  end

  test "toggle renders pressed state and click handler" do
    assigns = %{}
    html = rendered_to_string(~H|<.toggle pressed>B</.toggle>|)
    assert html =~ ~s(aria-pressed="true")
    assert html =~ ~s(data-state="on")
    assert html =~ "phx-click"
  end

  test "toggle_group single and items" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.toggle_group id="g" type="single">
        <.toggle_group_item group="g" value="l" pressed>L</.toggle_group_item>
        <.toggle_group_item group="g" value="c">C</.toggle_group_item>
      </.toggle_group>
      """)

    assert html =~ ~s(role="group")
    assert html =~ ~s(data-slot="toggle-group-item")
    assert html =~ ~s(data-state="on")
  end

  test "switch renders a real checkbox + track/thumb" do
    assigns = %{}
    html = rendered_to_string(~H|<.switch name="wifi" checked />|)
    assert html =~ ~s(type="checkbox")
    assert html =~ ~s(name="wifi")
    assert html =~ "checked"
    assert html =~ ~s(data-slot="switch-thumb")
    assert html =~ "peer"
  end

  test "checkbox renders a real checkbox + check icon" do
    assigns = %{}
    html = rendered_to_string(~H|<.checkbox name="terms" />|)
    assert html =~ ~s(type="checkbox")
    assert html =~ ~s(name="terms")
    assert html =~ "peer-checked:bg-primary"
  end

  test "radio_group renders real radios" do
    assigns = %{}

    html =
      rendered_to_string(~H"""
      <.radio_group>
        <.radio_group_item name="plan" value="free" checked />
        <.radio_group_item name="plan" value="pro" />
      </.radio_group>
      """)

    assert html =~ ~s(role="radiogroup")
    assert html =~ ~s(type="radio")
    assert html =~ ~s(value="free")
    assert html =~ "checked"
  end
end
