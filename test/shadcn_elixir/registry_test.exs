defmodule ShadcnElixir.RegistryTest do
  use ExUnit.Case, async: true

  alias ShadcnElixir.Registry

  test "list/0 returns all components including known ones" do
    list = Registry.list()
    assert "button" in list
    assert "dialog" in list
    assert "date_picker" in list
    assert length(list) >= 55
  end

  test "exists?/1" do
    assert Registry.exists?("button")
    refute Registry.exists?("nope")
  end

  test "deps/1 discovers sibling-component dependencies from source" do
    assert "button" in Registry.deps("pagination")
    assert "table" in Registry.deps("data_table")
    assert "toggle" in Registry.deps("toggle_group")
    assert Registry.deps("separator") == []
  end

  test "resolve/1 pulls in transitive dependencies" do
    resolved = Registry.resolve(["date_picker"])
    assert "date_picker" in resolved
    assert "popover" in resolved
    assert "calendar" in resolved
    assert "button" in resolved
  end

  test "resolve/1 accepts kebab-case and de-dupes" do
    resolved = Registry.resolve(["alert-dialog", "alert_dialog"])
    assert "alert_dialog" in resolved
    assert "button" in resolved
    assert Enum.uniq(resolved) == resolved
  end

  test "hooks/1 reports required JS hooks" do
    assert Registry.hooks("select") == ["ShadcnSelect"]
    assert Registry.hooks("command") == ["ShadcnCommand"]
    assert Registry.hooks("input_otp") == ["ShadcnInputOTP"]
    assert Registry.hooks("button") == []
  end
end
