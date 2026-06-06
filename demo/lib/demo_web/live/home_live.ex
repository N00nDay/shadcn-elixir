defmodule DemoWeb.HomeLive do
  @moduledoc """
  Landing page (`/`). Mirrors the shadcn/ui landing: the shared site header, a centered
  hero, and a bento-grid dashboard mockup assembled entirely from real library components,
  followed by the attribution footer.
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
        <section class="mx-auto flex max-w-3xl flex-col items-center gap-6 px-6 pt-20 pb-12 text-center sm:pt-28">
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

        <section class="mx-auto max-w-7xl px-6 pb-24">
          <.bento />
        </section>
      </main>

      <.docs_footer />
    </div>
    """
  end

  # A bento-grid dashboard mockup — the landing showcase, assembled from real library
  # components (analogous to shadcn's hero preview). Masonry via CSS multi-columns.
  defp bento(assigns) do
    ~H"""
    <div class="gap-6 [column-fill:_balance] sm:columns-2 lg:columns-4 [&>*]:mb-6 [&>*]:break-inside-avoid">
      <.kit_card />
      <.activity_card />
      <.connect_card />
      <.distribute_card />
      <.nav_card />
      <.balance_card />
      <.transfer_card />
      <.analytics_card />
      <.notifications_card />
    </div>
    """
  end

  defp kit_card(assigns) do
    ~H"""
    <.card class="p-6">
      <div class="flex flex-wrap items-center gap-2">
        <.button size="sm">
          Button
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          >
            <path d="M5 12h14" /><path d="m12 5 7 7-7 7" />
          </svg>
        </.button>
        <.button size="sm" variant="secondary">Secondary</.button>
        <.button size="sm" variant="outline">Outline</.button>
      </div>

      <div class="relative mt-4">
        <.input placeholder="Name" class="pr-9" />
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="pointer-events-none absolute top-1/2 right-3 size-4 -translate-y-1/2 text-muted-foreground"
        >
          <circle cx="11" cy="11" r="8" /><path d="m21 21-4.3-4.3" />
        </svg>
      </div>

      <.textarea placeholder="Message" class="mt-3 min-h-20" />

      <div class="mt-4 flex items-center justify-between gap-2">
        <div class="flex items-center gap-2">
          <.badge>Badge</.badge>
          <.badge variant="secondary">Secondary</.badge>
        </div>
        <div class="flex items-center gap-3">
          <.radio_group_item name="kit" value="a" />
          <.radio_group_item name="kit" value="b" checked />
          <.checkbox checked />
          <.switch checked />
        </div>
      </div>

      <div class="mt-4 flex items-center justify-between gap-2">
        <.button variant="outline" size="sm">Alert Dialog</.button>
        <.button_group>
          <.button variant="outline" size="sm">Button Group</.button>
          <.button variant="outline" size="icon-sm" aria-label="More">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
            >
              <path d="m18 15-6-6-6 6" />
            </svg>
          </.button>
        </.button_group>
      </div>
    </.card>
    """
  end

  defp activity_card(assigns) do
    bars = [
      {"Dec", 45},
      {"Jan", 80},
      {"Feb", 60},
      {"Mar", 95},
      {"Apr", 35},
      {"May", 100}
    ]

    assigns = assign(assigns, :bars, bars)

    ~H"""
    <.card>
      <.card_header>
        <.card_title>Monthly Activity</.card_title>
        <.card_description>Last 6 months of activity</.card_description>
      </.card_header>
      <.card_content>
        <div class="flex h-40 items-end justify-between gap-2">
          <div :for={{label, h} <- @bars} class="flex flex-1 flex-col items-center gap-2">
            <div class="w-full rounded-t-sm bg-muted-foreground/70" style={"height: #{h}%"}></div>
            <span class="text-xs text-muted-foreground">{label}</span>
          </div>
        </div>
        <div class="mt-4 grid grid-cols-2 gap-3">
          <div class="rounded-lg border p-3">
            <p class="text-xs tracking-wide text-muted-foreground uppercase">Upcoming</p>
            <p class="font-semibold">May 2024</p>
            <p class="text-xs text-muted-foreground">Scheduled</p>
          </div>
          <div class="rounded-lg border p-3">
            <p class="text-xs tracking-wide text-muted-foreground uppercase">Plan</p>
            <p class="font-semibold">Accelerated</p>
            <p class="text-xs text-muted-foreground">Recurring</p>
          </div>
        </div>
      </.card_content>
      <.card_footer>
        <.button variant="secondary" class="w-full">View Full Report</.button>
      </.card_footer>
    </.card>
    """
  end

  defp connect_card(assigns) do
    ~H"""
    <.card class="items-center text-center">
      <.card_content class="flex flex-col items-center gap-4 pt-2">
        <div class="rounded-xl bg-white p-4 text-black">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="1.5"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="size-32"
          >
            <rect width="5" height="5" x="3" y="3" rx="1" /><rect
              width="5"
              height="5"
              x="16"
              y="3"
              rx="1"
            /><rect width="5" height="5" x="3" y="16" rx="1" /><path d="M21 16h-3a2 2 0 0 0-2 2v3" /><path d="M21 21v.01" /><path d="M12 7v3a2 2 0 0 1-2 2H7" /><path d="M3 12h.01" /><path d="M12 3h.01" /><path d="M12 16v.01" /><path d="M16 12h1" /><path d="M21 12v.01" /><path d="M12 21v-1" />
          </svg>
        </div>
        <div>
          <p class="font-semibold">Scan to connect your device</p>
          <p class="mt-1 text-sm text-muted-foreground">
            Open the app and scan this code to pair your device.
          </p>
        </div>
      </.card_content>
    </.card>
    """
  end

  defp distribute_card(assigns) do
    ~H"""
    <.card class="items-center text-center">
      <.card_content class="flex flex-col items-center gap-3 pt-2">
        <div class="flex size-12 items-center justify-center rounded-full bg-muted">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="size-5"
          >
            <path d="M5 12h14" /><path d="M12 5v14" />
          </svg>
        </div>
        <p class="font-semibold">Publish a release</p>
        <p class="text-sm text-muted-foreground">
          Ship your first build and start reaching users across every platform.
        </p>
        <.button variant="outline" size="sm">Create Release</.button>
      </.card_content>
    </.card>
    """
  end

  defp nav_card(assigns) do
    planning = [
      {"Documents", "M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z M14 2v5h5"},
      {"Budget",
       "M3 7V5a2 2 0 0 1 2-2h2 M17 3h2a2 2 0 0 1 2 2v2 M21 17v2a2 2 0 0 1-2 2h-2 M7 21H5a2 2 0 0 1-2-2v-2"},
      {"Reports", "M3 3v18h18 M18 17V9 M13 17V5 M8 17v-3"},
      {"Goals", "M22 12h-4 M6 12H2 M12 6V2 M12 22v-4"},
      {"Calendar", "M8 2v4 M16 2v4 M3 10h18 M3 4h18v18H3z"}
    ]

    support = [
      {"Help Center", "M12 17h.01 M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"},
      {"Docs",
       "M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"},
      {"Contact Us", "M22 6 12 13 2 6 M2 6h20v12H2z"},
      {"Status", "M22 12h-4l-3 9L9 3l-3 9H2"},
      {"Community", "M2 12h20 M12 2a15 15 0 0 1 0 20 15 15 0 0 1 0-20z"}
    ]

    assigns = assign(assigns, planning: planning, support: support)

    ~H"""
    <.card class="p-6">
      <p class="mb-2 text-sm font-medium text-muted-foreground">Planning</p>
      <ul class="space-y-1 text-sm">
        <li :for={{label, d} <- @planning}>
          <a
            href="#"
            class="flex items-center gap-2 rounded-md px-2 py-1.5 hover:bg-accent hover:text-accent-foreground"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="size-4 text-muted-foreground"
            >
              <path d={d} />
            </svg>
            {label}
          </a>
        </li>
      </ul>
      <.separator class="my-4" />
      <p class="mb-2 text-sm font-medium text-muted-foreground">Support</p>
      <ul class="space-y-1 text-sm">
        <li :for={{label, d} <- @support}>
          <a
            href="#"
            class="flex items-center gap-2 rounded-md px-2 py-1.5 hover:bg-accent hover:text-accent-foreground"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="size-4 text-muted-foreground"
            >
              <path d={d} />
            </svg>
            {label}
          </a>
        </li>
      </ul>
    </.card>
    """
  end

  defp balance_card(assigns) do
    ~H"""
    <.card>
      <.card_header>
        <.card_description>Available balance</.card_description>
        <.card_title class="text-3xl font-bold tracking-tight">$1,248.00</.card_title>
      </.card_header>
      <.card_content>
        <.badge variant="secondary" class="gap-1.5">
          <span class="size-1.5 rounded-full bg-amber-500"></span> Pending setup
        </.badge>
      </.card_content>
    </.card>
    """
  end

  defp transfer_card(assigns) do
    ~H"""
    <.card>
      <.card_header>
        <.card_title>Transfer funds</.card_title>
        <.card_description>Move money between your connected accounts.</.card_description>
      </.card_header>
      <.card_content class="grid gap-4">
        <div class="grid gap-2">
          <.label for="transfer-amount">Amount</.label>
          <.input id="transfer-amount" value="$ 1,200.00" />
        </div>
        <div class="grid gap-2">
          <.label for="transfer-from">From account</.label>
          <.native_select id="transfer-from" class="w-full">
            <option>Main checking — $12,450.00</option>
            <option>Savings — $48,900.00</option>
          </.native_select>
        </div>
      </.card_content>
      <.card_footer>
        <.button class="w-full">Transfer</.button>
      </.card_footer>
    </.card>
    """
  end

  defp analytics_card(assigns) do
    ~H"""
    <.card>
      <.card_header>
        <div class="flex items-center justify-between">
          <.card_title>Analytics</.card_title>
          <.button variant="ghost" size="sm">View Analytics</.button>
        </div>
        <div class="flex items-center gap-2">
          <span class="text-2xl font-bold">418.2K</span>
          <.badge variant="secondary">+10%</.badge>
        </div>
        <.card_description>Visitors this month</.card_description>
      </.card_header>
      <.card_content>
        <svg viewBox="0 0 300 80" preserveAspectRatio="none" class="h-20 w-full text-muted-foreground">
          <polyline
            points="0,60 50,45 100,55 150,25 200,40 250,15 300,30"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
          />
        </svg>
      </.card_content>
    </.card>
    """
  end

  defp notifications_card(assigns) do
    rows = [
      {"Email", "Product updates and news", true},
      {"Push", "Activity on your account", true},
      {"SMS", "Critical security alerts", false}
    ]

    assigns = assign(assigns, :rows, rows)

    ~H"""
    <.card class="p-6">
      <p class="font-semibold">Notifications</p>
      <p class="mt-1 text-sm text-muted-foreground">Choose what you want to hear about.</p>
      <div class="mt-4 space-y-4">
        <div :for={{title, desc, on} <- @rows} class="flex items-center justify-between gap-4">
          <div>
            <p class="text-sm font-medium">{title}</p>
            <p class="text-xs text-muted-foreground">{desc}</p>
          </div>
          <.switch checked={on} />
        </div>
      </div>
    </.card>
    """
  end
end
