defmodule DemoWeb.ComponentLive do
  @moduledoc """
  A per-component documentation page (`/docs/components/:component`). Renders the
  component's description, live Preview/Code examples, and an auto-generated props
  table. Unbuilt-but-known components show a "coming soon" placeholder so the sidebar
  stays complete.

  Uses plain `Phoenix.LiveView` + `use ShadcnElixir` (rather than `DemoWeb, :live_view`)
  to avoid name clashes with Phoenix core_components.
  """
  use Phoenix.LiveView
  use ShadcnElixir

  import DemoWeb.DocsComponents
  alias DemoWeb.Docs

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(%{"component" => slug}, _uri, socket) do
    {:noreply,
     assign(socket,
       slug: slug,
       spec: Docs.component(slug),
       title: Docs.title_for(slug),
       page_title: Docs.title_for(slug)
     )}
  end

  def render(assigns) do
    ~H"""
    <.docs_shell
      active={{:component, @slug}}
      breadcrumb={[
        %{label: "Docs", href: "/docs/introduction"},
        %{label: "Components", href: nil},
        %{label: @title, href: nil}
      ]}
    >
      <.built_page :if={@spec} spec={@spec} />
      <.coming_soon :if={is_nil(@spec)} title={@title} />
    </.docs_shell>
    """
  end

  attr :spec, :map, required: true

  defp built_page(assigns) do
    ~H"""
    <.doc_heading title={@spec.title} description={@spec.description} />

    <.doc_section_title>Usage</.doc_section_title>
    <p class="mb-4 text-sm text-muted-foreground">
      Import every component in your web module (or a single module), then use it in HEEx.
    </p>
    <.code_block id={"usage-" <> @spec.slug} language="elixir" source={usage_source()} />

    <.doc_section_title>Examples</.doc_section_title>
    <div class="space-y-8">
      <div :for={ex <- @spec.examples} class="space-y-3">
        <h3 class="text-lg font-medium tracking-tight">{ex.title}</h3>
        <p :if={ex.description} class="text-sm text-muted-foreground">{ex.description}</p>
        <.example name={ex.key} />
      </div>
    </div>

    <.doc_section_title>API Reference</.doc_section_title>
    <p class="mb-4 text-sm text-muted-foreground">
      Generated from the component's declarative
      <code class="rounded bg-muted px-1 py-0.5 text-xs">attr</code>
      definitions — required props are marked with <span class="text-destructive">*</span>.
    </p>
    <div class="space-y-8">
      <.props_table :for={p <- @spec.props} module={p.module} fun={p.fun} label={p.label} />
    </div>
    """
  end

  attr :title, :string, required: true

  defp coming_soon(assigns) do
    ~H"""
    <.doc_heading title={@title} />
    <.card class="mt-6">
      <.card_header>
        <.card_title>Documentation coming soon</.card_title>
        <.card_description>
          The <span class="font-medium">{@title}</span>
          component is implemented in the library — its documentation page is on the way.
          In the meantime, see it in the <.link
            navigate="/gallery"
            class="underline underline-offset-4"
          >kitchen-sink gallery</.link>.
        </.card_description>
      </.card_header>
    </.card>
    """
  end

  defp usage_source do
    """
    defmodule MyAppWeb.SomeLive do
      use MyAppWeb, :live_view
      use ShadcnElixir

      # ...
    end
    """
    |> String.trim_trailing()
  end
end
