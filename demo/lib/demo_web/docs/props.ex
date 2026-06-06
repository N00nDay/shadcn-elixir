defmodule DemoWeb.Docs.Props do
  @moduledoc """
  Introspects a library component's declarative `attr`/`slot` metadata so the docs
  site can render a props table that always reflects the real component definition.

  Reads the `__components__/0` map that `Phoenix.Component` injects. Each attr is a
  map `%{name, type, opts, doc, required}` where `opts` carries `:default` and
  `:values`; each slot is `%{name, doc, required, ...}`.
  """

  @doc """
  Returns normalized attr rows for `module.fun`, ordered with the meaningful attrs
  first and `:class` / `:rest` last.

  Each row: `%{name, type, required, default, values, doc}`.
  """
  def attrs(module, fun) do
    case fetch(module, fun) do
      nil ->
        []

      meta ->
        meta.attrs
        |> Enum.map(&normalize_attr/1)
        |> Enum.sort_by(&sort_key/1)
    end
  end

  @doc "Returns normalized slot rows `%{name, required, doc}` for `module.fun`."
  def slots(module, fun) do
    case fetch(module, fun) do
      nil ->
        []

      meta ->
        Enum.map(meta.slots, &%{name: &1.name, required: &1[:required] || false, doc: &1[:doc]})
    end
  end

  defp fetch(module, fun) do
    if function_exported?(module, :__components__, 0) do
      module.__components__()[fun]
    end
  end

  defp normalize_attr(attr) do
    opts = attr[:opts] || []

    %{
      name: attr.name,
      type: type_string(attr.type),
      required: attr[:required] || false,
      default: format_default(Keyword.get(opts, :default, :__none__)),
      values: opts[:values],
      doc: attr[:doc]
    }
  end

  defp type_string(:global), do: "global"
  defp type_string(type) when is_atom(type), do: to_string(type)
  defp type_string({:struct, mod}), do: inspect(mod)
  defp type_string(other), do: inspect(other)

  defp format_default(:__none__), do: nil
  defp format_default(nil), do: "nil"
  defp format_default(value) when is_binary(value), do: inspect(value)
  defp format_default(value), do: inspect(value)

  # class/rest sort after the meaningful attrs; everything else alphabetical.
  defp sort_key(%{name: :rest}), do: {2, ""}
  defp sort_key(%{name: :class}), do: {1, ""}
  defp sort_key(%{name: name}), do: {0, to_string(name)}
end
