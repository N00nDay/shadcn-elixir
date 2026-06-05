defmodule ShadcnElixir.GeneratorTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  @tmp Path.join(System.tmp_dir!(), "shadcn_gen_test")

  setup do
    File.rm_rf!(@tmp)
    File.mkdir_p!(@tmp)
    on_exit(fn -> File.rm_rf!(@tmp) end)
    :ok
  end

  test "rewrite/2 retargets the component namespace but leaves helpers" do
    src = """
    defmodule ShadcnElixir.Components.Pagination do
      alias ShadcnElixir.Components.Button
      import ShadcnElixir.Variants
      import ShadcnElixir, only: [cn: 1]
    end
    """

    out = Mix.Tasks.Shadcn.Add.rewrite(src, "MyAppWeb.Components.UI")

    assert out =~ "defmodule MyAppWeb.Components.UI.Pagination"
    assert out =~ "alias MyAppWeb.Components.UI.Button"
    # helpers untouched (stay on the dependency)
    assert out =~ "import ShadcnElixir.Variants"
    assert out =~ "import ShadcnElixir, only: [cn: 1]"
  end

  test "shadcn.add writes a component and its dependencies with rewritten modules" do
    capture_io(fn ->
      Mix.Tasks.Shadcn.Add.run(["pagination", "--dir", @tmp, "--namespace", "Demo.UI"])
    end)

    pagination = Path.join(@tmp, "pagination.ex")
    button = Path.join(@tmp, "button.ex")

    assert File.exists?(pagination)
    # dependency was pulled in automatically
    assert File.exists?(button)

    content = File.read!(pagination)
    assert content =~ "defmodule Demo.UI.Pagination"
    assert content =~ "Demo.UI.Button"
    assert File.read!(button) =~ "defmodule Demo.UI.Button"
  end

  test "shadcn.add skips existing files without --force" do
    Path.join(@tmp, "button.ex") |> File.write!("KEEP ME")

    capture_io(fn ->
      Mix.Tasks.Shadcn.Add.run(["button", "--dir", @tmp, "--namespace", "Demo.UI"])
    end)

    assert File.read!(Path.join(@tmp, "button.ex")) == "KEEP ME"
  end

  test "shadcn.add --force overwrites" do
    Path.join(@tmp, "button.ex") |> File.write!("OLD")

    capture_io(fn ->
      Mix.Tasks.Shadcn.Add.run(["button", "--dir", @tmp, "--namespace", "Demo.UI", "--force"])
    end)

    assert File.read!(Path.join(@tmp, "button.ex")) =~ "defmodule Demo.UI.Button"
  end
end
