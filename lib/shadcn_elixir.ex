defmodule ShadcnElixir do
  @moduledoc """
  ShadcnElixir — a portable Phoenix/Elixir component library, a faithful port of
  [shadcn/ui](https://ui.shadcn.com/).

  ## Usage

  Import every component into a module (e.g. your `MyAppWeb` `html_helpers`):

      use ShadcnElixir

  Or import a single component module directly:

      import ShadcnElixir.Components.Button

  ## Theming

  Components are styled entirely through CSS variables (see `priv/static/theme.css`),
  mirroring shadcn's `background`/`foreground` semantic token pairs. Dark mode is a
  `.dark` class override of the same tokens.

  ## `cn/1`

  `cn/1` is the Elixir equivalent of shadcn's `cn()` helper — it conditionally joins
  class names and resolves conflicting Tailwind utilities (via `TwMerge`), so a later
  `px-4` wins over an earlier `px-2`.

  > #### Cache {: .info}
  >
  > `cn/1` depends on `TwMerge`, which requires the `TwMerge.Cache` process. Add it to
  > your application's supervision tree:
  >
  >     children = [
  >       # ...
  >       TwMerge.Cache
  >     ]
  """

  @doc """
  Conditionally joins and merges Tailwind CSS class names.

  Accepts a string, or an (arbitrarily nested) list whose elements may be:

    * a binary class string — included as-is
    * `nil` / `false` — skipped (lets you write `condition && "class"`)
    * a `{class, condition}` tuple — `class` included only when `condition` is truthy
    * a map of `%{class => condition}` — each key included when its value is truthy

  Conflicting Tailwind utilities are resolved last-wins via `TwMerge.merge/1`.

  ## Examples

      iex> ShadcnElixir.cn("px-2 px-4")
      "px-4"

      iex> ShadcnElixir.cn(["text-sm", nil, false, "font-medium"])
      "text-sm font-medium"

      iex> ShadcnElixir.cn(["p-2", {"hidden", false}, {"block", true}])
      "p-2 block"
  """
  @spec cn(term()) :: binary()
  def cn(classes) do
    classes
    |> List.wrap()
    |> Enum.flat_map(&normalize/1)
    |> TwMerge.merge()
  end

  defp normalize(nil), do: []
  defp normalize(false), do: []
  defp normalize(value) when is_binary(value), do: [value]
  defp normalize(value) when is_atom(value), do: [to_string(value)]
  defp normalize(list) when is_list(list), do: Enum.flat_map(list, &normalize/1)

  defp normalize(%{} = map) do
    for {class, truthy} <- map, truthy, do: to_string(class)
  end

  defp normalize({class, truthy}) when truthy not in [nil, false], do: [to_string(class)]
  defp normalize({_class, _falsy}), do: []

  @doc false
  defmacro __using__(_opts) do
    quote do
      import ShadcnElixir.Components.Button
    end
  end
end
