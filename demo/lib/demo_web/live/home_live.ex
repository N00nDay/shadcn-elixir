defmodule DemoWeb.HomeLive do
  @moduledoc """
  Landing page (`/`). Mirrors the shadcn/ui landing layout: the shared site header,
  a centered hero (announcement pill, headline, subheading, CTAs), a live component
  showcase, and the attribution footer.
  """
  use Phoenix.LiveView
  use ShadcnElixir

  import DemoWeb.DocsComponents
  alias DemoWeb.Docs

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "shadcn-elixir", components: Docs.components())}
  end

  def render(assigns) do
    ~H"""
    <.search_dialog components={@components} />
    <div class="min-h-svh bg-background text-foreground">
      <.site_header components={@components} />

      <main>
        <section class="mx-auto flex max-w-3xl flex-col items-center gap-6 px-6 py-20 text-center sm:py-28">
          <.link
            href="https://github.com/N00nDay/shadcn-elixir"
            target="_blank"
            rel="noreferrer"
            class="inline-flex items-center gap-2 rounded-full border bg-muted/40 px-4 py-1.5 text-sm font-medium transition-colors hover:bg-muted"
          >
            <span class="text-muted-foreground">New</span>
            <.separator orientation="vertical" class="h-4" />
            <span>58 components for Phoenix</span>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="size-3.5"
            >
              <path d="M5 12h14" /><path d="m12 5 7 7-7 7" />
            </svg>
          </.link>

          <h1 class="text-4xl font-bold tracking-tight text-balance sm:text-5xl md:text-6xl">
            Beautifully designed components for Phoenix
          </h1>

          <p class="max-w-2xl text-lg text-balance text-muted-foreground">
            A faithful port of shadcn/ui for Phoenix LiveView. Accessible, customizable, open
            source — and yours to own. Copy, paste, and ship.
          </p>

          <div class="flex flex-wrap items-center justify-center gap-3">
            <.button navigate="/docs/introduction" size="lg">Get Started</.button>
            <.button variant="outline" size="lg" navigate="/docs/components/button">
              Browse Components
            </.button>
          </div>
        </section>

        <section class="mx-auto max-w-5xl px-6 pb-24">
          <.showcase />
        </section>
      </main>

      <.docs_footer />
    </div>
    """
  end

  # A polished, live arrangement of real library components — the landing-page
  # showcase (analogous to shadcn's hero preview).
  defp showcase(assigns) do
    ~H"""
    <div class="grid gap-6 md:grid-cols-2">
      <.card class="w-full">
        <.card_header>
          <.card_title>Create an account</.card_title>
          <.card_description>Enter your email below to create your account.</.card_description>
        </.card_header>
        <.card_content class="grid gap-4">
          <div class="grid gap-2">
            <.label for="demo-email">Email</.label>
            <.input id="demo-email" type="email" placeholder="you@example.com" />
          </div>
          <div class="grid gap-2">
            <.label for="demo-password">Password</.label>
            <.input id="demo-password" type="password" value="" />
          </div>
        </.card_content>
        <.card_footer>
          <.button class="w-full">Create account</.button>
        </.card_footer>
      </.card>

      <div class="flex flex-col gap-6">
        <.card>
          <.card_header>
            <.card_title>Components</.card_title>
            <.card_description>Every shadcn/ui primitive, ported to HEEx.</.card_description>
          </.card_header>
          <.card_content class="flex flex-col gap-4">
            <div class="flex flex-wrap items-center gap-2">
              <.button size="sm">Primary</.button>
              <.button size="sm" variant="secondary">Secondary</.button>
              <.button size="sm" variant="outline">Outline</.button>
              <.button size="sm" variant="ghost">Ghost</.button>
            </div>
            <div class="flex flex-wrap items-center gap-2">
              <.badge>Default</.badge>
              <.badge variant="secondary">Secondary</.badge>
              <.badge variant="outline">Outline</.badge>
              <.badge variant="destructive">Destructive</.badge>
            </div>
            <.separator />
            <div class="flex items-center gap-6">
              <div class="flex items-center gap-2">
                <.checkbox id="demo-terms" checked />
                <.label for="demo-terms">Accept terms</.label>
              </div>
              <div class="flex items-center gap-2">
                <.switch id="demo-notifications" checked />
                <.label for="demo-notifications">Notifications</.label>
              </div>
            </div>
          </.card_content>
        </.card>

        <.alert>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z" /><line
              x1="4"
              x2="4"
              y1="22"
              y2="15"
            />
          </svg>
          <.alert_title>Copy, paste, own it.</.alert_title>
          <.alert_description>
            Run <code class="text-xs">mix shadcn.add</code> to generate any component into your app.
          </.alert_description>
        </.alert>
      </div>
    </div>
    """
  end
end
