defmodule ShadcnElixir.Variants do
  @moduledoc """
  The Elixir equivalent of [`class-variance-authority`](https://cva.style/) (CVA),
  the variant engine shadcn/ui is built on.

  A variant `config` declares a `base` class string plus named `variants`
  (e.g. `variant`, `size`), an optional set of `default_variants`, and optional
  `compound_variants`. `variant/2` resolves the selected options against that config
  and returns a merged class string (conflicts resolved by `ShadcnElixir.cn/1`).

  This lets component source read almost 1:1 with the original shadcn `cva(...)` call.

  ## Example

      @button %{
        base: "inline-flex items-center justify-center rounded-md text-sm font-medium",
        variants: %{
          variant: %{
            "default" => "bg-primary text-primary-foreground hover:bg-primary/90",
            "outline" => "border bg-background hover:bg-accent"
          },
          size: %{
            "default" => "h-9 px-4 py-2",
            "sm" => "h-8 px-3"
          }
        },
        default_variants: %{variant: "default", size: "default"}
      }

      ShadcnElixir.Variants.variant(@button, variant: "outline", size: "sm", class: "w-full")

  ## Compound variants

  `compound_variants` is a list of maps; each maps a set of variant values to extra
  classes that apply only when *all* of those values match the resolved selection:

      compound_variants: [
        %{variant: "outline", size: "sm", class: "border-dashed"}
      ]
  """

  import ShadcnElixir, only: [cn: 1]

  @type config :: %{
          optional(:base) => binary(),
          optional(:variants) => %{atom() => %{binary() => binary()}},
          optional(:default_variants) => %{atom() => binary() | atom()},
          optional(:compound_variants) => [map()]
        }

  @doc """
  Resolve a variant `config` against the selected `opts` and return a merged class string.

  `opts` is a keyword list or map of variant selections. The reserved key `:class`
  (and `:className`) is appended last as a per-call override, exactly like passing
  `className` to a CVA function in shadcn.

  A selection of `nil` falls back to the matching `default_variants` value.
  """
  @spec variant(config(), keyword() | map()) :: binary()
  def variant(config, opts \\ []) do
    opts = Map.new(opts)
    {class_override, selected} = pop_class(opts)

    base = Map.get(config, :base, "")
    variants = Map.get(config, :variants, %{})
    defaults = config |> Map.get(:default_variants, %{}) |> Map.new()
    compounds = Map.get(config, :compound_variants, [])

    resolved =
      Map.new(variants, fn {name, _values} ->
        {name, selected[name] || defaults[name]}
      end)

    variant_classes =
      for {name, value} <- resolved, value != nil do
        variants |> Map.fetch!(name) |> Map.get(to_string(value))
      end

    compound_classes =
      for compound <- compounds, compound_matches?(compound, resolved) do
        compound[:class] || compound["class"]
      end

    cn([base, variant_classes, compound_classes, class_override])
  end

  defp pop_class(opts) do
    {class, opts} = Map.pop(opts, :class)
    {class_alias, opts} = Map.pop(opts, :className)
    {class || class_alias, opts}
  end

  defp compound_matches?(compound, resolved) do
    compound
    |> Map.drop([:class, "class"])
    |> Enum.all?(fn {name, value} ->
      to_string(resolved[name]) == to_string(value)
    end)
  end
end
