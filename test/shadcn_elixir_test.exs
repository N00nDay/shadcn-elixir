defmodule ShadcnElixirTest do
  use ExUnit.Case, async: true
  doctest ShadcnElixir

  describe "cn/1" do
    test "merges conflicting tailwind utilities last-wins" do
      assert ShadcnElixir.cn("px-2 px-4") == "px-4"
      assert ShadcnElixir.cn(["p-2", "p-4"]) == "p-4"
    end

    test "keeps non-conflicting classes" do
      assert ShadcnElixir.cn(["text-sm", "font-medium"]) == "text-sm font-medium"
    end

    test "drops nil and false entries" do
      assert ShadcnElixir.cn(["text-sm", nil, false, "font-medium"]) == "text-sm font-medium"
    end

    test "supports {class, condition} tuples" do
      assert ShadcnElixir.cn(["p-2", {"hidden", false}, {"block", true}]) == "p-2 block"
    end

    test "supports maps of class => condition" do
      assert ShadcnElixir.cn([%{"font-bold" => true, "italic" => false}]) == "font-bold"
    end

    test "flattens nested lists" do
      assert ShadcnElixir.cn(["a", ["b", ["c", nil]]]) == "a b c"
    end
  end
end
