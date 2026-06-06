defmodule DemoWeb.HomeLive do
  @moduledoc """
  Landing page (`/`) — a clone of the shadcn/ui landing (hero + bento dashboard),
  built from the library's own components. Only the footer attribution differs.
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
            <span>Introducing GitHub Registries</span>
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
            The Foundation for your Design System
          </h1>

          <p class="max-w-2xl text-lg text-balance text-muted-foreground">
            A set of beautifully designed components that you can customize, extend, and build on.
            Start here then make it your own. Open Source. Open Code.
          </p>

          <div>
            <.button navigate="/docs/introduction" size="lg">
              Build Your Own
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
          </div>
        </section>

        <section class="overflow-hidden">
          <div
            data-slot="demo"
            class="relative flex w-full flex-col gap-(--gap) overflow-hidden bg-muted p-12 pb-0! [--gap:--spacing(8)] lg:p-6 lg:[--gap:--spacing(6)] dark:bg-background"
          >
            <div class="relative z-10 mx-auto grid gap-(--gap) **:data-[slot=card]:w-full md:max-w-3xl md:grid-cols-2 lg:max-w-none lg:grid-cols-3 xl:max-w-[1600px] min-[1400px]:grid-cols-4 min-[1900px]:grid-cols-5 2xl:max-w-[1900px]">
              <div class="flex flex-col items-start gap-(--gap)">
                <.kit_card />
                <.nav_card />
                <.savings_card />
              </div>
              <div class="hidden flex-col gap-(--gap) lg:flex">
                <.contribution_card />
                <.balance_card />
                <.dividends_card />
              </div>
              <div class="hidden flex-col gap-(--gap) min-[1900px]:flex">
                <.account_nav_card />
              </div>
              <div class="hidden flex-col gap-(--gap) md:flex">
                <.connect_card />
                <.transfer_card />
                <.payments_card />
              </div>
              <div class="hidden flex-col gap-(--gap) min-[1400px]:flex">
                <.distribute_card />
                <.analytics_card />
                <.notifications_card />
                <.power_card />
              </div>
            </div>
            <div class="from-background via-muted pointer-events-none absolute inset-x-0 top-0 z-[1] h-120 bg-linear-to-b to-transparent dark:hidden">
            </div>
            <div class="from-background via-muted pointer-events-none absolute inset-x-0 bottom-0 z-[1] h-120 bg-linear-to-t to-transparent dark:hidden">
            </div>
            <div class="from-background pointer-events-none absolute inset-x-0 bottom-0 z-[1] hidden h-120 bg-linear-to-t to-transparent dark:block">
            </div>
          </div>
        </section>
      </main>

      <.docs_footer />
    </div>
    """
  end

  defp kit_card(assigns) do
    ~H"""
    <.card class="w-full">
      <.card_content class="flex flex-col gap-6">
        <div class="flex gap-2">
          <.button>
            Button
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              data-icon="inline-end"
            >
              <path d="M5 12h14" /><path d="m12 5 7 7-7 7" />
            </svg>
          </.button>
          <.button variant="secondary">Secondary</.button>
          <.button variant="outline">Outline</.button>
        </div>

        <.field_group>
          <.field>
            <.input_group>
              <.input_group_input placeholder="Name" />
              <.input_group_addon align="inline-end">
                <.input_group_text>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  >
                    <circle cx="11" cy="11" r="8" /><path d="m21 21-4.3-4.3" />
                  </svg>
                </.input_group_text>
              </.input_group_addon>
            </.input_group>
          </.field>
          <.field class="flex-1">
            <.textarea placeholder="Message" class="resize-none" />
          </.field>
        </.field_group>

        <div class="flex items-center gap-2">
          <div class="flex gap-2">
            <.badge>Badge</.badge>
            <.badge variant="secondary">Secondary</.badge>
            <.badge variant="outline" class="4xl:flex hidden">Outline</.badge>
          </div>
          <.radio_group class="ml-auto flex w-fit gap-3" aria-label="Plan">
            <.radio_group_item name="kit-plan" value="monthly" checked aria-label="Monthly" />
            <.radio_group_item name="kit-plan" value="yearly" aria-label="Yearly" />
          </.radio_group>
          <div class="flex gap-3">
            <.checkbox checked aria-label="Enable email alerts" />
            <.checkbox class="4xl:flex hidden" aria-label="Enable push alerts" />
          </div>
          <.switch checked class="4xl:hidden flex" aria-label="Compact mode" />
        </div>

        <div class="flex items-center gap-4">
          <.alert_dialog id="ui-alert">
            <.alert_dialog_trigger dialog="ui-alert">
              <.button variant="outline">Alert Dialog</.button>
            </.alert_dialog_trigger>
            <.alert_dialog_content dialog="ui-alert" size="sm">
              <.alert_dialog_header>
                <.alert_dialog_title>Update notification settings?</.alert_dialog_title>
                <.alert_dialog_description>
                  This changes how alerts are delivered across your connected devices.
                </.alert_dialog_description>
              </.alert_dialog_header>
              <.alert_dialog_footer>
                <.alert_dialog_cancel dialog="ui-alert">Cancel</.alert_dialog_cancel>
                <.alert_dialog_action dialog="ui-alert">Update</.alert_dialog_action>
              </.alert_dialog_footer>
            </.alert_dialog_content>
          </.alert_dialog>
          <.button_group class="ml-auto">
            <.button variant="outline">Button Group</.button>
            <.dropdown_menu id="ui-menu">
              <.dropdown_menu_trigger menu="ui-menu">
                <.button variant="outline" size="icon" aria-label="Open actions">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  >
                    <path d="m5 12 7-7 7 7" /><path d="M12 19V5" />
                  </svg>
                </.button>
              </.dropdown_menu_trigger>
              <.dropdown_menu_content menu="ui-menu" align="end" class="w-40">
                <.dropdown_menu_group>
                  <.dropdown_menu_label>Actions</.dropdown_menu_label>
                  <.dropdown_menu_item menu="ui-menu">Edit</.dropdown_menu_item>
                  <.dropdown_menu_item menu="ui-menu">Duplicate</.dropdown_menu_item>
                  <.dropdown_menu_item menu="ui-menu">Archive</.dropdown_menu_item>
                </.dropdown_menu_group>
                <.dropdown_menu_separator />
                <.dropdown_menu_group>
                  <.dropdown_menu_item menu="ui-menu" variant="destructive">
                    Delete
                  </.dropdown_menu_item>
                </.dropdown_menu_group>
              </.dropdown_menu_content>
            </.dropdown_menu>
          </.button_group>
          <.switch checked class="4xl:flex hidden" aria-label="Advanced setting" />
        </div>
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
    <.card class="grid grid-cols-2 gap-x-6 gap-y-4 p-6">
      <.nav_section title="Planning" items={@planning} />
      <.nav_section title="Support" items={@support} />
    </.card>
    """
  end

  defp account_nav_card(assigns) do
    overview = [
      {"Analytics", "M3 3v18h18 M7 16l4-4 3 3 5-5", true},
      {"Transactions", "M7 7h14 M3 7l4-4 M17 17H3 M21 17l-4 4", false},
      {"Investments", "M3 17l6-6 4 4 8-8 M21 7v6", false},
      {"Accounts", "M3 21h18 M5 21V7l8-4v18 M19 21V11l-6-4", false},
      {"Spending", "M21.21 15.89A10 10 0 1 1 8 2.83 M22 12A10 10 0 0 0 12 2v10z", false}
    ]

    account = [
      {"Profile", "M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2 M12 7a4 4 0 1 0 0 8 4 4 0 0 0 0-8z",
       false},
      {"Billing", "M2 5h20v14H2z M2 10h20", true},
      {"Notifications",
       "M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9 M10.3 21a1.94 1.94 0 0 0 3.4 0", false},
      {"Security", "M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z", false},
      {"Appearance",
       "M12 2a10 10 0 1 0 0 20 2 2 0 0 0 2-2 2 2 0 0 1 2-2h2a4 4 0 0 0 4-4 10 10 0 0 0-10-10z",
       false}
    ]

    assigns = assign(assigns, overview: overview, account: account)

    ~H"""
    <.card class="grid grid-cols-2 gap-x-6 gap-y-4 p-6">
      <.nav_section title="Overview" items={@overview} />
      <.nav_section title="Account" items={@account} />
    </.card>
    """
  end

  attr :title, :string, required: true
  attr :items, :list, required: true

  defp nav_section(assigns) do
    ~H"""
    <div>
      <p class="mb-2 text-sm font-medium text-muted-foreground">{@title}</p>
      <ul class="space-y-1 text-sm">
        <li :for={item <- @items}>
          <a
            href="#"
            class={[
              "flex items-center gap-2 rounded-md px-2 py-1.5",
              active_item?(item) && "bg-accent font-medium text-accent-foreground",
              !active_item?(item) && "text-foreground/80 hover:bg-accent hover:text-accent-foreground"
            ]}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="size-4 opacity-70"
            >
              <path d={item_icon(item)} />
            </svg>
            {item_label(item)}
          </a>
        </li>
      </ul>
    </div>
    """
  end

  defp item_label({label, _}), do: label
  defp item_label({label, _, _}), do: label
  defp item_icon({_, d}), do: d
  defp item_icon({_, d, _}), do: d
  defp active_item?({_, _, active}), do: active
  defp active_item?(_), do: false

  defp savings_card(assigns) do
    targets = [
      {"Retirement", "$420,000", 65, "$273,000"},
      {"Real Estate", "$85,000", 32, "$27,200"}
    ]

    assigns = assign(assigns, :targets, targets)

    ~H"""
    <.card>
      <.card_header>
        <.card_title>Savings Targets</.card_title>
        <.card_description>
          Active milestones for 2024 across your portfolio. Monitor how close you are to each
          savings goal.
        </.card_description>
      </.card_header>
      <.card_content class="space-y-5">
        <div :for={{label, amount, pct, saved} <- @targets} class="space-y-2">
          <p class="text-xs tracking-wide text-muted-foreground uppercase">{label}</p>
          <p class="text-2xl font-bold tracking-tight">{amount}</p>
          <div class="h-2 w-full overflow-hidden rounded-full bg-muted">
            <div class="h-full rounded-full bg-primary" style={"width: #{pct}%"}></div>
          </div>
          <div class="flex items-center justify-between text-xs text-muted-foreground">
            <span>{pct}% achieved</span>
            <span>{saved}</span>
          </div>
        </div>
      </.card_content>
      <.card_footer>
        <p class="text-xs text-muted-foreground">You have not met your targets for this year.</p>
      </.card_footer>
    </.card>
    """
  end

  defp contribution_card(assigns) do
    bars = [{"Dec", 45}, {"Jan", 80}, {"Feb", 60}, {"Mar", 95}, {"Apr", 35}, {"May", 100}]
    assigns = assign(assigns, :bars, bars)

    ~H"""
    <.card>
      <.card_header>
        <.card_title>Contribution History</.card_title>
        <.card_description>Last 6 months of activity</.card_description>
      </.card_header>
      <.card_content>
        <div class="flex h-40 items-stretch justify-between gap-2">
          <div :for={{label, h} <- @bars} class="flex h-full flex-1 flex-col justify-end gap-2">
            <div class="w-full rounded-t-sm bg-muted-foreground/70" style={"height: #{h}%"}></div>
            <span class="text-center text-xs text-muted-foreground">{label}</span>
          </div>
        </div>
        <div class="mt-4 grid grid-cols-2 gap-3">
          <div class="rounded-lg border p-3">
            <p class="text-xs tracking-wide text-muted-foreground uppercase">Upcoming</p>
            <p class="font-semibold">May 2024</p>
            <p class="text-xs text-muted-foreground">Scheduled</p>
          </div>
          <div class="rounded-lg border p-3">
            <p class="text-xs tracking-wide text-muted-foreground uppercase">Savings Plan</p>
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

  defp balance_card(assigns) do
    ~H"""
    <.card>
      <.card_header>
        <.card_description>Claimable Balance</.card_description>
        <.card_title class="text-4xl font-bold tracking-tight">1,211.29</.card_title>
        <.card_action>
          <.badge variant="secondary" class="gap-1.5">
            <span class="size-1.5 rounded-full bg-amber-500"></span> Pending Setup
          </.badge>
        </.card_action>
      </.card_header>
      <.card_content class="space-y-3">
        <div class="space-y-2 text-sm">
          <div class="flex items-center justify-between">
            <span class="text-muted-foreground">Net Royalties</span>
            <span class="font-medium">1,248.75</span>
          </div>
          <div class="flex items-center justify-between">
            <span class="text-muted-foreground">Processing Fee</span>
            <span class="font-medium">-37.46</span>
          </div>
          <.separator />
          <div class="flex items-center justify-between">
            <span class="text-muted-foreground">Total Ready to Claim</span>
            <span class="font-semibold">1,211.29 USD</span>
          </div>
        </div>
        <p class="text-xs leading-relaxed text-muted-foreground">
          Once your bank is connected, balances over $10.00 are automatically eligible for monthly
          distribution on the 15th of each month.
        </p>
      </.card_content>
    </.card>
    """
  end

  defp dividends_card(assigns) do
    holdings = [
      {"Vanguard", "450 Shares", [50, 60, 70, 100]},
      {"S&amp;P 500 VOO", "112 Shares", [40, 55, 90, 70]},
      {"Apple AAPL", "85 Shares", [60, 70, 100, 80]},
      {"Realty Income", "320 Shares", [30, 45, 60, 90]}
    ]

    assigns = assign(assigns, :holdings, holdings)

    ~H"""
    <.card>
      <.card_header>
        <div class="flex items-start justify-between">
          <.card_title>Q2 Dividend Income</.card_title>
          <.close_x />
        </div>
        <.card_description>
          Quarterly dividend payouts across your portfolio holdings.
        </.card_description>
      </.card_header>
      <.card_content class="space-y-3">
        <div
          :for={{name, shares, bars} <- @holdings}
          class="flex items-center justify-between rounded-lg border p-3"
        >
          <div>
            <p class="text-sm font-medium">{Phoenix.HTML.raw(name)}</p>
            <p class="text-xs text-muted-foreground">{shares}</p>
          </div>
          <div class="flex h-8 items-end gap-1">
            <div
              :for={b <- bars}
              class="w-2 rounded-sm bg-muted-foreground/60"
              style={"height: #{b}%"}
            >
            </div>
          </div>
        </div>
      </.card_content>
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
          <p class="font-semibold">Scan to connect your mobile device</p>
          <p class="mt-1 text-sm text-muted-foreground">
            Open the Ledger mobile app and scan this code to link your device.
          </p>
        </div>
      </.card_content>
    </.card>
    """
  end

  defp transfer_card(assigns) do
    ~H"""
    <.card>
      <.card_header>
        <div class="flex items-start justify-between">
          <.card_title>Transfer Funds</.card_title>
          <.close_x />
        </div>
        <.card_description>Move money between your connected accounts.</.card_description>
      </.card_header>
      <.card_content class="grid gap-4">
        <div class="grid gap-2">
          <.label for="transfer-amount">Amount to Transfer</.label>
          <.input id="transfer-amount" value="$ 1,200.00" />
        </div>
        <div class="grid gap-2">
          <.label for="transfer-from">From Account</.label>
          <.native_select id="transfer-from" class="w-full">
            <option>Main Checking (··8402) — $12,450.00</option>
          </.native_select>
        </div>
        <div class="grid gap-2">
          <.label for="transfer-to">To Account</.label>
          <.native_select id="transfer-to" class="w-full">
            <option>High Yield Savings (··1192) — $42,100.00</option>
          </.native_select>
        </div>
        <div class="space-y-2 rounded-lg border p-3 text-sm">
          <div class="flex items-center justify-between">
            <span class="text-muted-foreground">Estimated arrival</span>
            <span class="font-medium">Today, Apr 14</span>
          </div>
          <div class="flex items-center justify-between">
            <span class="text-muted-foreground">Transaction fee</span>
            <span class="font-medium">$0.00</span>
          </div>
          <.separator />
          <div class="flex items-center justify-between">
            <span class="text-muted-foreground">Total amount</span>
            <span class="font-semibold">$1,200.00</span>
          </div>
        </div>
      </.card_content>
      <.card_footer>
        <.button class="w-full">Confirm Transfer</.button>
      </.card_footer>
    </.card>
    """
  end

  defp payments_card(assigns) do
    rows = [
      {"Change transfer limit", "Adjust how much you can send from your balance.",
       "M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z M15 12a3 3 0 1 1-6 0 3 3 0 0 1 6 0z",
       false},
      {"Scheduled transfers", "Set up a transfer to send at a later date.",
       "M8 2v4 M16 2v4 M3 10h18 M3 4h18v18H3z", false},
      {"Recurring card payments", "Manage your repeated card transactions.",
       "M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8 M21 3v5h-5 M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16 M8 16H3v5",
       true}
    ]

    assigns = assign(assigns, :rows, rows)

    ~H"""
    <.card class="p-6">
      <.breadcrumb class="mb-4">
        <.breadcrumb_list>
          <.breadcrumb_item><.breadcrumb_link href="#">Home</.breadcrumb_link></.breadcrumb_item>
          <.breadcrumb_separator />
          <.breadcrumb_item><.breadcrumb_ellipsis /></.breadcrumb_item>
          <.breadcrumb_separator />
          <.breadcrumb_item>
            <.breadcrumb_page>Payments</.breadcrumb_page>
          </.breadcrumb_item>
        </.breadcrumb_list>
      </.breadcrumb>
      <div class="space-y-2">
        <a
          :for={{title, desc, icon, muted} <- @rows}
          href="#"
          class={["flex items-center gap-3 rounded-lg border p-3", muted && "opacity-50"]}
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="size-4 shrink-0 text-muted-foreground"
          >
            <path d={icon} />
          </svg>
          <div class="min-w-0 flex-1">
            <p class="text-sm font-medium">{title}</p>
            <p class="text-xs text-muted-foreground">{desc}</p>
          </div>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
            class="size-4 shrink-0 text-muted-foreground"
          >
            <path d="m9 18 6-6-6-6" />
          </svg>
        </a>
      </div>
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
        <p class="font-semibold">Distribute Track</p>
        <p class="text-sm text-muted-foreground">
          Upload your first master to start reaching listeners on Spotify, Apple Music, and more.
        </p>
        <.button variant="outline" size="sm">Create Release</.button>
      </.card_content>
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
          <span class="text-sm text-muted-foreground">Visitors</span>
          <.badge variant="secondary">+10%</.badge>
        </div>
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
      {"Transaction alerts", "Deposits, withdrawals, and transfers.", true},
      {"Security alerts", "Login attempts and account changes.", true},
      {"Goal milestones", "Updates at 25%, 50%, 75%, and 100%.", false},
      {"Market updates", "Daily portfolio summary and price alerts.", false}
    ]

    assigns = assign(assigns, :rows, rows)

    ~H"""
    <.card>
      <.card_header>
        <.card_title>Notifications</.card_title>
        <.card_description>Choose which email and push alerts you want to receive.</.card_description>
      </.card_header>
      <.card_content class="space-y-4">
        <div :for={{title, desc, on} <- @rows} class="flex items-start gap-3">
          <.checkbox checked={on} class="mt-0.5" />
          <div>
            <p class="text-sm font-medium">{title}</p>
            <p class="text-xs text-muted-foreground">{desc}</p>
          </div>
        </div>
      </.card_content>
      <.card_footer>
        <.button class="w-full">Save Preferences</.button>
      </.card_footer>
    </.card>
    """
  end

  defp power_card(assigns) do
    bars = [
      {"6a", 35},
      {"8a", 55},
      {"10a", 45},
      {"12p", 70},
      {"2p", 85},
      {"4p", 60},
      {"6p", 75},
      {"8p", 65}
    ]

    assigns = assign(assigns, :bars, bars)

    ~H"""
    <.card>
      <.card_header>
        <.card_title>Power Usage</.card_title>
        <.card_description>Whole Home</.card_description>
      </.card_header>
      <.card_content>
        <div class="flex h-28 items-stretch justify-between gap-1.5">
          <div :for={{label, h} <- @bars} class="flex h-full flex-1 flex-col justify-end gap-1.5">
            <div class="w-full rounded-t-sm bg-muted-foreground/70" style={"height: #{h}%"}></div>
            <span class="text-center text-[10px] text-muted-foreground">{label}</span>
          </div>
        </div>
        <div class="mt-4 grid grid-cols-2 gap-3">
          <div>
            <p class="text-xs text-muted-foreground">Currently Using</p>
            <p class="text-lg font-semibold">3.4 kW</p>
          </div>
          <div>
            <p class="text-xs text-muted-foreground">Solar Gen</p>
            <p class="text-lg font-semibold">+1.2 kW</p>
          </div>
        </div>
      </.card_content>
    </.card>
    """
  end

  defp close_x(assigns) do
    ~H"""
    <button type="button" aria-label="Close" class="text-muted-foreground hover:text-foreground">
      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
        class="size-4"
      >
        <path d="M18 6 6 18" /><path d="m6 6 12 12" />
      </svg>
    </button>
    """
  end
end
