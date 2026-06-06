defmodule DemoWeb.GalleryLive do
  @moduledoc """
  A showcase of shadcn-elixir components. Uses plain `Phoenix.LiveView` + `use ShadcnElixir`
  (rather than `DemoWeb, :live_view`) to avoid name clashes with Phoenix core_components.
  """
  use Phoenix.LiveView
  use ShadcnElixir

  @rows [
    %{name: "Ada Lovelace", email: "ada@example.com", role: "Admin"},
    %{name: "Alan Turing", email: "alan@example.com", role: "Owner"},
    %{name: "Grace Hopper", email: "grace@example.com", role: "Member"}
  ]

  def mount(_params, _session, socket) do
    today = Date.utc_today()

    {:ok,
     assign(socket,
       page_title: "Components",
       today: today,
       month: today,
       selected: nil,
       dp_month: today,
       dp_selected: nil,
       rows: @rows
     )}
  end

  def handle_event("select_date", %{"date" => date}, socket) do
    {:noreply, assign(socket, selected: Date.from_iso8601!(date))}
  end

  def handle_event("change_month", %{"month" => month}, socket) do
    {:noreply, assign(socket, month: Date.from_iso8601!(month))}
  end

  def handle_event("dp_select", %{"date" => date}, socket) do
    {:noreply, assign(socket, dp_selected: Date.from_iso8601!(date))}
  end

  def handle_event("dp_change_month", %{"month" => month}, socket) do
    {:noreply, assign(socket, dp_month: Date.from_iso8601!(month))}
  end

  def render(assigns) do
    ~H"""
    <main class="mx-auto max-w-5xl px-6 py-10">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-3xl font-bold tracking-tight">shadcn-elixir</h1>
          <p class="text-muted-foreground mt-1">A faithful port of shadcn/ui for Phoenix.</p>
        </div>
        <.button variant="outline" onclick="toggleTheme()">
          Toggle theme
        </.button>
      </div>

      <.toaster />

      <.section title="Buttons">
        <div class="flex flex-wrap items-center gap-3">
          <.button>Default</.button>
          <.button variant="secondary">Secondary</.button>
          <.button variant="destructive">Destructive</.button>
          <.button variant="outline">Outline</.button>
          <.button variant="ghost">Ghost</.button>
          <.button variant="link">Link</.button>
          <.button size="sm">Small</.button>
          <.button size="lg">Large</.button>
        </div>
      </.section>

      <.section title="Badges">
        <div class="flex flex-wrap items-center gap-3">
          <.badge>Default</.badge>
          <.badge variant="secondary">Secondary</.badge>
          <.badge variant="destructive">Destructive</.badge>
          <.badge variant="outline">Outline</.badge>
        </div>
      </.section>

      <.section title="Card">
        <.card class="max-w-sm">
          <.card_header>
            <.card_title>Create project</.card_title>
            <.card_description>Deploy your new project in one click.</.card_description>
          </.card_header>
          <.card_content>
            <div class="grid gap-2">
              <.label for="proj">Name</.label>
              <.input id="proj" placeholder="Acme Inc." />
            </div>
          </.card_content>
          <.card_footer class="justify-between">
            <.button variant="outline">Cancel</.button>
            <.button>Deploy</.button>
          </.card_footer>
        </.card>
      </.section>

      <.section title="Form controls">
        <div class="grid max-w-sm gap-5">
          <div class="grid gap-2">
            <.label for="email">Email</.label>
            <.input id="email" type="email" placeholder="you@example.com" />
          </div>
          <div class="grid gap-2">
            <.label for="bio">Bio</.label>
            <.textarea id="bio" placeholder="Tell us about yourself" />
          </div>
          <div class="flex items-center gap-2">
            <.checkbox id="terms" name="terms" />
            <.label for="terms" class="text-sm">Accept terms</.label>
          </div>
          <div class="flex items-center gap-2">
            <.switch id="wifi" name="wifi" checked />
            <.label for="wifi" class="text-sm">Wi-Fi</.label>
          </div>
          <.radio_group>
            <div class="flex items-center gap-2">
              <.radio_group_item id="plan-free" name="plan" value="free" checked />
              <.label for="plan-free" class="text-sm">Free</.label>
            </div>
            <div class="flex items-center gap-2">
              <.radio_group_item id="plan-pro" name="plan" value="pro" />
              <.label for="plan-pro" class="text-sm">Pro</.label>
            </div>
          </.radio_group>
          <.slider name="vol" value={50} />
          <.select id="fruit" name="fruit" value="apple">
            <.select_trigger select="fruit" class="w-[200px]">
              <.select_value placeholder="Pick a fruit" />
            </.select_trigger>
            <.select_content select="fruit">
              <.select_item select="fruit" value="apple">Apple</.select_item>
              <.select_item select="fruit" value="banana">Banana</.select_item>
              <.select_item select="fruit" value="cherry">Cherry</.select_item>
            </.select_content>
          </.select>
        </div>
      </.section>

      <.section title="Tabs">
        <.tabs id="t" class="max-w-md">
          <.tabs_list>
            <.tabs_trigger tabs="t" value="account" active>Account</.tabs_trigger>
            <.tabs_trigger tabs="t" value="password">Password</.tabs_trigger>
          </.tabs_list>
          <.tabs_content tabs="t" value="account" active class="pt-3 text-sm text-muted-foreground">
            Make changes to your account here.
          </.tabs_content>
          <.tabs_content tabs="t" value="password" class="pt-3 text-sm text-muted-foreground">
            Change your password here.
          </.tabs_content>
        </.tabs>
      </.section>

      <.section title="Accordion">
        <.accordion class="max-w-md">
          <.accordion_item open>
            <.accordion_trigger>Is it accessible?</.accordion_trigger>
            <.accordion_content>Yes — it uses native details/summary.</.accordion_content>
          </.accordion_item>
          <.accordion_item>
            <.accordion_trigger>Is it styled?</.accordion_trigger>
            <.accordion_content>Yes, matching shadcn/ui.</.accordion_content>
          </.accordion_item>
        </.accordion>
      </.section>

      <.section title="Overlays">
        <div class="flex flex-wrap items-center gap-3">
          <.dialog id="dlg">
            <.dialog_trigger dialog="dlg"><.button>Open dialog</.button></.dialog_trigger>
            <.dialog_content dialog="dlg">
              <.dialog_header>
                <.dialog_title>Edit profile</.dialog_title>
                <.dialog_description>Make changes to your profile here.</.dialog_description>
              </.dialog_header>
              <div class="grid gap-2 py-2">
                <.label for="dn">Name</.label>
                <.input id="dn" value="Ada Lovelace" />
              </div>
              <.dialog_footer>
                <.dialog_close dialog="dlg">
                  <.button variant="outline">Cancel</.button>
                </.dialog_close>
                <.button>Save</.button>
              </.dialog_footer>
            </.dialog_content>
          </.dialog>

          <.dropdown_menu id="dd">
            <.dropdown_menu_trigger menu="dd">
              <.button variant="outline">Menu</.button>
            </.dropdown_menu_trigger>
            <.dropdown_menu_content menu="dd">
              <.dropdown_menu_label>My account</.dropdown_menu_label>
              <.dropdown_menu_separator />
              <.dropdown_menu_item menu="dd">Profile</.dropdown_menu_item>
              <.dropdown_menu_item menu="dd">Settings</.dropdown_menu_item>
              <.dropdown_menu_item menu="dd" variant="destructive">Log out</.dropdown_menu_item>
            </.dropdown_menu_content>
          </.dropdown_menu>

          <.popover id="pop">
            <.popover_trigger popover="pop">
              <.button variant="outline">Popover</.button>
            </.popover_trigger>
            <.popover_content popover="pop">
              <p class="text-sm">Place content for the popover here.</p>
            </.popover_content>
          </.popover>

          <.tooltip>
            <.tooltip_trigger><.button variant="outline">Hover me</.button></.tooltip_trigger>
            <.tooltip_content>Add to library</.tooltip_content>
          </.tooltip>

          <.button
            variant="outline"
            onclick="window.dispatchEvent(new CustomEvent('shadcn:toast',{detail:{title:'Event created',description:'Sunday at 9:00 AM'}}))"
          >
            Show toast
          </.button>
        </div>
      </.section>

      <.section title="Alert">
        <.alert class="max-w-xl">
          <.alert_title>Heads up!</.alert_title>
          <.alert_description>You can add components to your app using the CLI.</.alert_description>
        </.alert>
      </.section>

      <.section title="Data table">
        <.data_table rows={@rows}>
          <:col :let={r} label="Name">{r.name}</:col>
          <:col :let={r} label="Email" class="text-muted-foreground">{r.email}</:col>
          <:col :let={r} label="Role">
            <.badge variant="secondary">{r.role}</.badge>
          </:col>
        </.data_table>
      </.section>

      <.section title="Calendar">
        <.calendar
          month={@month}
          selected={@selected}
          today={@today}
          on_select="select_date"
          on_previous_month="change_month"
          on_next_month="change_month"
          class="rounded-md border"
        />
        <p class="text-muted-foreground mt-2 text-sm">
          Selected: {if @selected, do: Calendar.strftime(@selected, "%B %-d, %Y"), else: "none"}
        </p>
      </.section>

      <.section title="Progress & Skeleton">
        <div class="grid max-w-md gap-4">
          <.progress value={66} />
          <div class="flex items-center gap-3">
            <.skeleton class="size-10 rounded-full" />
            <div class="grid gap-2">
              <.skeleton class="h-4 w-[200px]" />
              <.skeleton class="h-4 w-[160px]" />
            </div>
          </div>
        </div>
      </.section>

      <.section title="Chart">
        <.chart
          id="visitors"
          type="bar"
          class="h-[260px] w-full max-w-xl"
          data={[
            %{label: "Jan", value: 186},
            %{label: "Feb", value: 305},
            %{label: "Mar", value: 237},
            %{label: "Apr", value: 173},
            %{label: "May", value: 209},
            %{label: "Jun", value: 264}
          ]}
        />
      </.section>

      <.section title="Typography">
        <div class="max-w-xl">
          <.typography_h1>The Joke Tax Chronicles</.typography_h1>
          <.typography_lead>A modest levy on humor, retold for posterity.</.typography_lead>
          <.typography_h2>The King's Plan</.typography_h2>
          <.typography_p>
            The king thought long and hard, and finally came up with <.typography_inline_code>a brilliant plan</.typography_inline_code>: he would tax the jokes in the kingdom.
          </.typography_p>
          <.typography_blockquote>
            "After all," he said, "everyone enjoys a good joke, so it's only fair that they should pay for the privilege."
          </.typography_blockquote>
          <.typography_h3>The Joke Tax</.typography_h3>
          <.typography_list>
            <li>1st level of puns: 5 gold coins</li>
            <li>2nd level of jokes: 10 gold coins</li>
            <li>3rd level of one-liners: 20 gold coins</li>
          </.typography_list>
          <.typography_h4>People stopped telling jokes</.typography_h4>
          <.typography_large>Are you sure?</.typography_large>
          <.typography_small>Email address</.typography_small>
          <.typography_muted>Enter your email address.</.typography_muted>
        </div>
      </.section>

      <.section title="Avatar, Spinner & Kbd">
        <div class="flex flex-wrap items-center gap-6">
          <div class="flex items-center gap-3">
            <.avatar>
              <.avatar_image src="https://github.com/shadcn.png" alt="@shadcn" />
              <.avatar_fallback>CN</.avatar_fallback>
            </.avatar>
            <.avatar>
              <.avatar_image src="https://invalid.example/none.png" alt="broken" />
              <.avatar_fallback>AB</.avatar_fallback>
            </.avatar>
          </div>
          <.avatar_group>
            <.avatar>
              <.avatar_image src="https://github.com/shadcn.png" alt="@shadcn" />
              <.avatar_fallback>CN</.avatar_fallback>
            </.avatar>
            <.avatar>
              <.avatar_image src="https://github.com/vercel.png" alt="@vercel" />
              <.avatar_fallback>VC</.avatar_fallback>
            </.avatar>
            <.avatar>
              <.avatar_fallback>AB</.avatar_fallback>
            </.avatar>
            <.avatar_group_count>+3</.avatar_group_count>
          </.avatar_group>
          <div class="flex items-center gap-3">
            <.spinner />
            <.spinner class="size-6 text-primary" />
          </div>
          <div class="flex items-center gap-3">
            <.kbd>⌘</.kbd>
            <.kbd_group>
              <.kbd>Ctrl</.kbd>
              <.kbd>K</.kbd>
            </.kbd_group>
          </div>
        </div>
      </.section>

      <.section title="Separator">
        <div>
          <div class="space-y-1">
            <h4 class="text-sm font-medium leading-none">Radix Primitives</h4>
            <p class="text-muted-foreground text-sm">An open-source UI component library.</p>
          </div>
          <.separator class="my-4" />
          <div class="flex h-5 items-center space-x-4 text-sm">
            <div>Blog</div>
            <.separator orientation="vertical" />
            <div>Docs</div>
            <.separator orientation="vertical" />
            <div>Source</div>
          </div>
        </div>
      </.section>

      <.section title="Toggle & Toggle group">
        <div class="flex flex-wrap items-center gap-6">
          <div class="flex items-center gap-2">
            <.toggle variant="outline" aria-label="Bold">B</.toggle>
            <.toggle variant="outline" pressed aria-label="Italic">I</.toggle>
            <.toggle variant="outline" aria-label="Underline">U</.toggle>
          </div>
          <.toggle_group id="tg-align" type="single" variant="outline">
            <.toggle_group_item group="tg-align" value="left">Left</.toggle_group_item>
            <.toggle_group_item group="tg-align" value="center">Center</.toggle_group_item>
            <.toggle_group_item group="tg-align" value="right">Right</.toggle_group_item>
          </.toggle_group>
        </div>
      </.section>

      <.section title="Button group">
        <div class="flex flex-col gap-4">
          <.button_group>
            <.button variant="outline">Years</.button>
            <.button variant="outline">Months</.button>
            <.button variant="outline">Days</.button>
          </.button_group>
          <.button_group>
            <.button_group_text>https://</.button_group_text>
            <.input placeholder="example.com" />
            <.button variant="outline">Copy</.button>
          </.button_group>
        </div>
      </.section>

      <.section title="Aspect ratio">
        <div class="max-w-sm">
          <.aspect_ratio ratio="16/9" class="rounded-md bg-muted">
            <div class="flex h-full w-full items-center justify-center text-sm text-muted-foreground">
              16 / 9
            </div>
          </.aspect_ratio>
        </div>
      </.section>

      <.section title="Breadcrumb">
        <.breadcrumb>
          <.breadcrumb_list>
            <.breadcrumb_item><.breadcrumb_link href="#">Home</.breadcrumb_link></.breadcrumb_item>
            <.breadcrumb_separator />
            <.breadcrumb_item>
              <.breadcrumb_link href="#">Components</.breadcrumb_link>
            </.breadcrumb_item>
            <.breadcrumb_separator />
            <.breadcrumb_item>
              <.breadcrumb_page>Breadcrumb</.breadcrumb_page>
            </.breadcrumb_item>
          </.breadcrumb_list>
        </.breadcrumb>
      </.section>

      <.section title="Pagination">
        <.pagination>
          <.pagination_content>
            <.pagination_item><.pagination_previous href="#" /></.pagination_item>
            <.pagination_item><.pagination_link href="#">1</.pagination_link></.pagination_item>
            <.pagination_item>
              <.pagination_link href="#" is_active>2</.pagination_link>
            </.pagination_item>
            <.pagination_item><.pagination_link href="#">3</.pagination_link></.pagination_item>
            <.pagination_item><.pagination_ellipsis /></.pagination_item>
            <.pagination_item><.pagination_next href="#" /></.pagination_item>
          </.pagination_content>
        </.pagination>
      </.section>

      <.section title="Navigation menu">
        <.navigation_menu>
          <.navigation_menu_list>
            <.navigation_menu_item>
              <.navigation_menu_trigger>Getting started</.navigation_menu_trigger>
              <.navigation_menu_content>
                <div class="grid w-[300px] gap-1 p-2">
                  <.navigation_menu_link href="#">Introduction</.navigation_menu_link>
                  <.navigation_menu_link href="#">Installation</.navigation_menu_link>
                  <.navigation_menu_link href="#">Typography</.navigation_menu_link>
                </div>
              </.navigation_menu_content>
            </.navigation_menu_item>
            <.navigation_menu_item>
              <.navigation_menu_link href="#" active>Docs</.navigation_menu_link>
            </.navigation_menu_item>
          </.navigation_menu_list>
        </.navigation_menu>
      </.section>

      <.section title="Menubar">
        <.menubar>
          <.menubar_menu id="mb-file">
            <.menubar_trigger menu="mb-file">File</.menubar_trigger>
            <.menubar_content menu="mb-file">
              <.menubar_item>
                New Tab
                <.menubar_shortcut>⌘T</.menubar_shortcut>
              </.menubar_item>
              <.menubar_item>New Window</.menubar_item>
              <.menubar_separator />
              <.menubar_item>
                Print…
                <.menubar_shortcut>⌘P</.menubar_shortcut>
              </.menubar_item>
            </.menubar_content>
          </.menubar_menu>
          <.menubar_menu id="mb-edit">
            <.menubar_trigger menu="mb-edit">Edit</.menubar_trigger>
            <.menubar_content menu="mb-edit">
              <.menubar_item>
                Undo
                <.menubar_shortcut>⌘Z</.menubar_shortcut>
              </.menubar_item>
              <.menubar_item>
                Redo
                <.menubar_shortcut>⇧⌘Z</.menubar_shortcut>
              </.menubar_item>
            </.menubar_content>
          </.menubar_menu>
        </.menubar>
      </.section>

      <.section title="Table">
        <.table class="max-w-xl">
          <.table_caption>A list of your recent invoices.</.table_caption>
          <.table_header>
            <.table_row>
              <.table_head>Invoice</.table_head>
              <.table_head>Status</.table_head>
              <.table_head class="text-right">Amount</.table_head>
            </.table_row>
          </.table_header>
          <.table_body>
            <.table_row>
              <.table_cell class="font-medium">INV001</.table_cell>
              <.table_cell>Paid</.table_cell>
              <.table_cell class="text-right">$250.00</.table_cell>
            </.table_row>
            <.table_row>
              <.table_cell class="font-medium">INV002</.table_cell>
              <.table_cell>Pending</.table_cell>
              <.table_cell class="text-right">$150.00</.table_cell>
            </.table_row>
          </.table_body>
        </.table>
      </.section>

      <.section title="Item">
        <.item_group class="max-w-md">
          <.item variant="outline">
            <.item_media variant="icon">
              <.spinner class="size-4" />
            </.item_media>
            <.item_content>
              <.item_title>Processing payment</.item_title>
              <.item_description>This may take a few seconds.</.item_description>
            </.item_content>
            <.item_actions>
              <.button variant="outline" size="sm">Cancel</.button>
            </.item_actions>
          </.item>
        </.item_group>
      </.section>

      <.section title="Field">
        <.field_set class="max-w-sm">
          <.field_legend>Profile</.field_legend>
          <.field_group>
            <.field>
              <.field_label for="f-name">Name</.field_label>
              <.input id="f-name" placeholder="Ada Lovelace" />
              <.field_description>This is your public display name.</.field_description>
            </.field>
            <.field orientation="horizontal">
              <.checkbox id="f-news" name="f-news" />
              <.field_content>
                <.field_label for="f-news">Subscribe to newsletter</.field_label>
                <.field_description>Get product updates monthly.</.field_description>
              </.field_content>
            </.field>
          </.field_group>
        </.field_set>
      </.section>

      <.section title="Input group">
        <div class="grid max-w-sm gap-4">
          <.input_group>
            <.input_group_addon>@</.input_group_addon>
            <.input_group_input placeholder="username" />
          </.input_group>
          <.input_group>
            <.input_group_input placeholder="Search…" />
            <.input_group_addon align="inline-end">
              <.input_group_button>Go</.input_group_button>
            </.input_group_addon>
          </.input_group>
        </div>
      </.section>

      <.section title="Native select">
        <.native_select name="country" class="max-w-[200px]">
          <option value="us">United States</option>
          <option value="ca">Canada</option>
          <option value="uk">United Kingdom</option>
        </.native_select>
      </.section>

      <.section title="Input OTP">
        <.input_otp id="otp-demo" name="code" length={6} />
      </.section>

      <.section title="Combobox">
        <.combobox id="cb-fw" name="framework" placeholder="Select framework…">
          <:option value="next">Next.js</:option>
          <:option value="svelte">SvelteKit</:option>
          <:option value="nuxt">Nuxt.js</:option>
          <:option value="remix">Remix</:option>
          <:option value="astro">Astro</:option>
        </.combobox>
      </.section>

      <.section title="Command">
        <.command id="cmd-demo" class="max-w-md rounded-lg border shadow-md">
          <.command_input placeholder="Type a command or search…" />
          <.command_list>
            <.command_empty>No results found.</.command_empty>
            <.command_group heading="Suggestions">
              <.command_item value="calendar">Calendar</.command_item>
              <.command_item value="emoji">Search Emoji</.command_item>
              <.command_item value="calc">Calculator</.command_item>
            </.command_group>
            <.command_separator />
            <.command_group heading="Settings">
              <.command_item value="profile">
                Profile
                <.command_shortcut>⌘P</.command_shortcut>
              </.command_item>
              <.command_item value="settings">
                Settings
                <.command_shortcut>⌘S</.command_shortcut>
              </.command_item>
            </.command_group>
          </.command_list>
        </.command>
      </.section>

      <.section title="Collapsible">
        <.collapsible class="max-w-md space-y-2" open>
          <.collapsible_trigger class="flex w-full items-center justify-between gap-4 rounded-md border px-4 py-2 text-sm font-medium hover:bg-accent hover:text-accent-foreground">
            @peduarte starred 3 repositories
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="size-4 shrink-0 transition-transform duration-200 group-open/collapsible:rotate-180"
            >
              <path d="m6 9 6 6 6-6" />
            </svg>
          </.collapsible_trigger>
          <.collapsible_content>
            <div class="rounded-md border px-4 py-2 text-sm">@radix-ui/primitives</div>
            <div class="rounded-md border px-4 py-2 text-sm">@radix-ui/colors</div>
          </.collapsible_content>
        </.collapsible>
      </.section>

      <.section title="Hover card">
        <.hover_card>
          <.hover_card_trigger>
            <.button variant="link">@nextjs</.button>
          </.hover_card_trigger>
          <.hover_card_content>
            <div class="space-y-1">
              <h4 class="text-sm font-semibold">@nextjs</h4>
              <p class="text-sm">The React Framework – created and maintained by @vercel.</p>
            </div>
          </.hover_card_content>
        </.hover_card>
      </.section>

      <.section title="Scroll area">
        <.scroll_area class="h-48 w-64 rounded-md border p-4">
          <div class="space-y-2 text-sm">
            <p :for={n <- 1..20}>Jokester began sneaking into the castle — item {n}.</p>
          </div>
        </.scroll_area>
      </.section>

      <.section title="Carousel">
        <.carousel id="car-demo" class="max-w-xs">
          <.carousel_content>
            <.carousel_item :for={n <- 1..5}>
              <div class="p-1">
                <.card>
                  <.card_content class="flex aspect-square items-center justify-center p-6">
                    <span class="text-4xl font-semibold">{n}</span>
                  </.card_content>
                </.card>
              </div>
            </.carousel_item>
          </.carousel_content>
          <.carousel_previous carousel="car-demo" />
          <.carousel_next carousel="car-demo" />
        </.carousel>
      </.section>

      <.section title="Empty state">
        <.empty class="max-w-md rounded-lg border">
          <.empty_header>
            <.empty_media variant="icon">📦</.empty_media>
            <.empty_title>No projects yet</.empty_title>
            <.empty_description>Create your first project to get started.</.empty_description>
          </.empty_header>
          <.empty_content>
            <.button>Create project</.button>
          </.empty_content>
        </.empty>
      </.section>

      <.section title="Resizable">
        <.resizable_panel_group
          id="rz-demo"
          direction="horizontal"
          class="h-48 max-w-md rounded-lg border"
        >
          <.resizable_panel basis={50}>
            <div class="flex h-full items-center justify-center p-6 text-sm">One</div>
          </.resizable_panel>
          <.resizable_handle with_handle />
          <.resizable_panel basis={50}>
            <div class="flex h-full items-center justify-center p-6 text-sm">Two</div>
          </.resizable_panel>
        </.resizable_panel_group>
      </.section>

      <.section title="More overlays">
        <div class="flex flex-wrap items-center gap-3">
          <.alert_dialog id="ad-demo">
            <.alert_dialog_trigger dialog="ad-demo">
              <.button variant="outline">Delete account</.button>
            </.alert_dialog_trigger>
            <.alert_dialog_content dialog="ad-demo">
              <.alert_dialog_header>
                <.alert_dialog_title>Are you absolutely sure?</.alert_dialog_title>
                <.alert_dialog_description>
                  This action cannot be undone. This will permanently delete your account.
                </.alert_dialog_description>
              </.alert_dialog_header>
              <.alert_dialog_footer>
                <.alert_dialog_cancel dialog="ad-demo">Cancel</.alert_dialog_cancel>
                <.alert_dialog_action dialog="ad-demo">Continue</.alert_dialog_action>
              </.alert_dialog_footer>
            </.alert_dialog_content>
          </.alert_dialog>

          <.sheet id="sheet-demo">
            <.sheet_trigger dialog="sheet-demo">
              <.button variant="outline">Open sheet</.button>
            </.sheet_trigger>
            <.sheet_content dialog="sheet-demo" side="right">
              <.sheet_header>
                <.sheet_title>Edit profile</.sheet_title>
                <.sheet_description>Make changes to your profile here.</.sheet_description>
              </.sheet_header>
              <div class="grid gap-2 px-4 py-2">
                <.label for="sheet-name">Name</.label>
                <.input id="sheet-name" value="Ada Lovelace" />
              </div>
              <.sheet_footer>
                <.sheet_close dialog="sheet-demo"><.button>Save</.button></.sheet_close>
              </.sheet_footer>
            </.sheet_content>
          </.sheet>

          <.drawer id="drawer-demo">
            <.drawer_trigger dialog="drawer-demo">
              <.button variant="outline">Open drawer</.button>
            </.drawer_trigger>
            <.drawer_content dialog="drawer-demo">
              <.drawer_header>
                <.drawer_title>Move goal</.drawer_title>
                <.drawer_description>Set your daily activity goal.</.drawer_description>
              </.drawer_header>
              <.drawer_footer>
                <.button>Submit</.button>
                <.drawer_close dialog="drawer-demo">
                  <.button variant="outline">Cancel</.button>
                </.drawer_close>
              </.drawer_footer>
            </.drawer_content>
          </.drawer>

          <.context_menu id="ctx-demo">
            <.context_menu_trigger>
              <div class="flex h-24 w-64 items-center justify-center rounded-md border border-dashed text-sm">
                Right-click here
              </div>
            </.context_menu_trigger>
            <.context_menu_content menu="ctx-demo">
              <.context_menu_item>Back</.context_menu_item>
              <.context_menu_item>Forward</.context_menu_item>
              <.context_menu_separator />
              <.context_menu_item variant="destructive">Delete</.context_menu_item>
            </.context_menu_content>
          </.context_menu>
        </div>
      </.section>

      <.section title="Date picker">
        <.date_picker
          id="dp-demo"
          selected={@dp_selected}
          month={@dp_month}
          on_select="dp_select"
          on_previous_month="dp_change_month"
          on_next_month="dp_change_month"
        />
      </.section>

      <.section title="Sidebar">
        <div class="relative h-80 overflow-hidden rounded-md border">
          <.sidebar_provider id="demo-sidebar" class="!min-h-0 h-full">
            <.sidebar class="!h-full">
              <.sidebar_header>
                <div class="flex items-center gap-2 overflow-hidden">
                  <div class="bg-primary text-primary-foreground flex aspect-square size-8 shrink-0 items-center justify-center rounded-lg">
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
                      <path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z" /><path d="m3.3 7 8.7 5 8.7-5" /><path d="M12 22V12" />
                    </svg>
                  </div>
                  <span class="text-sm font-semibold whitespace-nowrap">
                    Acme Inc.
                  </span>
                </div>
              </.sidebar_header>
              <.sidebar_content>
                <.sidebar_group>
                  <.sidebar_group_label>Platform</.sidebar_group_label>
                  <.sidebar_group_content>
                    <.sidebar_menu>
                      <.sidebar_menu_item>
                        <.sidebar_menu_button href="#" active>
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                          >
                            <rect width="7" height="9" x="3" y="3" rx="1" /><rect
                              width="7"
                              height="5"
                              x="14"
                              y="3"
                              rx="1"
                            /><rect width="7" height="9" x="14" y="12" rx="1" /><rect
                              width="7"
                              height="5"
                              x="3"
                              y="16"
                              rx="1"
                            />
                          </svg>
                          <span class="whitespace-nowrap">
                            Dashboard
                          </span>
                        </.sidebar_menu_button>
                      </.sidebar_menu_item>
                      <.sidebar_menu_item>
                        <.sidebar_menu_button href="#">
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                          >
                            <path d="M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z" />
                          </svg>
                          <span class="whitespace-nowrap">
                            Projects
                          </span>
                        </.sidebar_menu_button>
                      </.sidebar_menu_item>
                      <.sidebar_menu_item>
                        <.sidebar_menu_button href="#">
                          <svg
                            xmlns="http://www.w3.org/2000/svg"
                            viewBox="0 0 24 24"
                            fill="none"
                            stroke="currentColor"
                            stroke-width="2"
                            stroke-linecap="round"
                            stroke-linejoin="round"
                          >
                            <path d="M20 7h-9" /><path d="M14 17H5" /><circle cx="17" cy="17" r="3" /><circle
                              cx="7"
                              cy="7"
                              r="3"
                            />
                          </svg>
                          <span class="whitespace-nowrap">
                            Settings
                          </span>
                        </.sidebar_menu_button>
                      </.sidebar_menu_item>
                    </.sidebar_menu>
                  </.sidebar_group_content>
                </.sidebar_group>
              </.sidebar_content>
            </.sidebar>
            <.sidebar_inset>
              <div class="flex items-center gap-2 p-4">
                <.sidebar_trigger target="demo-sidebar" />
                <span class="text-sm text-muted-foreground">Toggle the sidebar →</span>
              </div>
            </.sidebar_inset>
          </.sidebar_provider>
        </div>
      </.section>

      <div class="text-muted-foreground py-10 text-center text-sm">
        All 58 components · <code>mix shadcn.add &lt;name&gt;</code> to copy any into your app.
      </div>
    </main>
    """
  end

  attr :title, :string, required: true
  slot :inner_block, required: true

  defp section(assigns) do
    ~H"""
    <section class="mt-10">
      <h2 class="mb-4 text-sm font-semibold tracking-wide text-muted-foreground uppercase">
        {@title}
      </h2>
      {render_slot(@inner_block)}
    </section>
    """
  end
end
