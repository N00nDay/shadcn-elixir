defmodule ShadcnElixir.VariantsTest do
  use ExUnit.Case, async: true

  import ShadcnElixir.Variants

  @config %{
    base: "rounded-md text-sm",
    variants: %{
      variant: %{
        "default" => "bg-primary text-primary-foreground",
        "outline" => "border bg-background"
      },
      size: %{
        "default" => "h-9 px-4",
        "sm" => "h-8 px-3"
      }
    },
    default_variants: %{variant: "default", size: "default"},
    compound_variants: [
      %{variant: "outline", size: "sm", class: "border-dashed"}
    ]
  }

  test "applies default variants when none selected" do
    result = variant(@config)
    assert result =~ "bg-primary"
    assert result =~ "h-9"
    assert result =~ "rounded-md"
  end

  test "selecting a variant overrides the default" do
    result = variant(@config, variant: "outline")
    assert result =~ "border"
    assert result =~ "bg-background"
    refute result =~ "bg-primary"
  end

  test "selecting a size overrides the default" do
    result = variant(@config, size: "sm")
    assert result =~ "h-8"
    refute result =~ "h-9"
  end

  test "nil selection falls back to default" do
    assert variant(@config, variant: nil, size: nil) == variant(@config)
  end

  test ":class is merged as a last-wins override" do
    result = variant(@config, size: "sm", class: "px-8")
    assert result =~ "px-8"
    refute result =~ "px-3"
  end

  test "compound variants apply only when all conditions match" do
    assert variant(@config, variant: "outline", size: "sm") =~ "border-dashed"
    refute variant(@config, variant: "outline", size: "default") =~ "border-dashed"
    refute variant(@config, variant: "default", size: "sm") =~ "border-dashed"
  end
end
