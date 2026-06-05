defmodule ShadcnElixir.Components.ButtonTest do
  use ExUnit.Case, async: true

  import Phoenix.Component
  import Phoenix.LiveViewTest
  import ShadcnElixir.Components.Button

  test "renders a <button> with default variant and size classes" do
    assigns = %{}
    html = rendered_to_string(~H"<.button>Click me</.button>")

    assert html =~ "<button"
    assert html =~ "Click me"
    # default variant
    assert html =~ "bg-primary"
    assert html =~ "text-primary-foreground"
    # default size
    assert html =~ "h-9"
    # base classes
    assert html =~ "inline-flex"
    assert html =~ "rounded-md"
  end

  test "applies the destructive variant" do
    assigns = %{}
    html = rendered_to_string(~H|<.button variant="destructive">Delete</.button>|)

    assert html =~ "bg-destructive"
    refute html =~ "bg-primary"
  end

  test "applies the sm size" do
    assigns = %{}
    html = rendered_to_string(~H|<.button size="sm">Small</.button>|)

    assert html =~ "h-8"
    refute html =~ "h-9"
  end

  test "merges a custom class over the variant classes (last wins)" do
    assigns = %{}
    html = rendered_to_string(~H|<.button class="bg-red-500">Custom</.button>|)

    classes =
      html
      |> Floki.parse_fragment!()
      |> Floki.attribute("button", "class")
      |> hd()
      |> String.split()

    assert "bg-red-500" in classes
    # the conflicting base color is dropped...
    refute "bg-primary" in classes
    # ...but the unrelated hover utility is preserved (matches tailwind-merge semantics)
    assert "hover:bg-primary/90" in classes
  end

  test "forwards arbitrary attributes and type" do
    assigns = %{}
    html = rendered_to_string(~H|<.button type="submit" disabled>Go</.button>|)

    assert html =~ ~s(type="submit")
    assert html =~ "disabled"
  end

  test "renders an <a> when a link attribute is present" do
    assigns = %{}
    html = rendered_to_string(~H|<.button variant="link" href="/about">About</.button>|)

    assert html =~ "<a"
    assert html =~ ~s(href="/about")
    refute html =~ "<button"
    # still styled with variant classes
    assert html =~ "underline-offset-4"
  end
end
