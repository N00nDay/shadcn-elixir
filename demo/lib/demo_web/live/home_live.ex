defmodule DemoWeb.HomeLive do
  @moduledoc """
  Landing page (`/`) — a short hero linking into the documentation.
  """
  use Phoenix.LiveView
  use ShadcnElixir

  def mount(_params, _session, socket), do: {:ok, assign(socket, page_title: "shadcn-elixir")}

  def render(assigns) do
    ~H"""
    <div class="flex min-h-svh flex-col">
      <header class="flex h-14 items-center justify-between border-b px-6">
        <span class="font-semibold">shadcn-elixir</span>
        <div class="flex items-center gap-2">
          <.button variant="ghost" navigate="/docs/introduction">Docs</.button>
          <.button variant="ghost" navigate="/docs/components/button">Components</.button>
          <button
            type="button"
            onclick="toggleTheme()"
            aria-label="Toggle theme"
            class="inline-flex size-9 items-center justify-center rounded-md hover:bg-accent hover:text-accent-foreground"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="size-4 dark:hidden"
            >
              <circle cx="12" cy="12" r="4" /><path d="M12 2v2" /><path d="M12 20v2" /><path d="m4.93 4.93 1.41 1.41" /><path d="m17.66 17.66 1.41 1.41" /><path d="M2 12h2" /><path d="M20 12h2" /><path d="m6.34 17.66-1.41 1.41" /><path d="m19.07 4.93-1.41 1.41" />
            </svg>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="hidden size-4 dark:block"
            >
              <path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z" />
            </svg>
          </button>
        </div>
      </header>

      <main class="mx-auto flex w-full max-w-3xl flex-1 flex-col items-center justify-center gap-6 px-6 py-20 text-center">
        <.badge variant="secondary">58 components · Phoenix · Tailwind v4</.badge>
        <h1 class="text-4xl font-bold tracking-tight sm:text-5xl">
          Build your Phoenix UI with shadcn-elixir
        </h1>
        <p class="max-w-xl text-lg text-muted-foreground">
          A faithful port of shadcn/ui for Phoenix — beautifully designed components with
          CSS-variable theming and copy-paste ownership. This whole site is built from the library.
        </p>
        <div class="flex flex-wrap items-center justify-center gap-3">
          <.button navigate="/docs/introduction">Get started</.button>
          <.button variant="outline" navigate="/docs/components/button">Browse components</.button>
        </div>
      </main>

      <footer class="border-t py-8">
        <p class="mx-auto max-w-3xl px-6 text-center text-sm text-muted-foreground">
          A port of
          <.link
            href="https://ui.shadcn.com"
            target="_blank"
            rel="noreferrer"
            class="font-medium underline underline-offset-4"
          >
            shadcn/ui
          </.link>
          by <.link
            href="https://twitter.com/shadcn"
            target="_blank"
            rel="noreferrer"
            class="font-medium underline underline-offset-4"
          >
            shadcn
          </.link>. Built for Phoenix by <.link
            href="https://github.com/N00nDay"
            target="_blank"
            rel="noreferrer"
            class="font-medium underline underline-offset-4"
          >
            Craig Howell
          </.link>. The source code is available on <.link
            href="https://github.com/N00nDay/shadcn-elixir"
            target="_blank"
            rel="noreferrer"
            class="font-medium underline underline-offset-4"
          >
            GitHub
          </.link>.
        </p>
      </footer>
    </div>
    """
  end
end
