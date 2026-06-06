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
       rows: @rows
     )}
  end

  def handle_event("select_date", %{"date" => date}, socket) do
    {:noreply, assign(socket, selected: Date.from_iso8601!(date))}
  end

  def handle_event("change_month", %{"month" => month}, socket) do
    {:noreply, assign(socket, month: Date.from_iso8601!(month))}
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
          <label class="flex items-center gap-2">
            <.checkbox name="terms" /> <span class="text-sm">Accept terms</span>
          </label>
          <label class="flex items-center gap-2">
            <.switch name="wifi" checked /> <span class="text-sm">Wi-Fi</span>
          </label>
          <.radio_group>
            <label class="flex items-center gap-2">
              <.radio_group_item name="plan" value="free" checked /> <span class="text-sm">Free</span>
            </label>
            <label class="flex items-center gap-2">
              <.radio_group_item name="plan" value="pro" /> <span class="text-sm">Pro</span>
            </label>
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
                <.dialog_close dialog="dlg"><.button variant="outline">Cancel</.button></.dialog_close>
                <.button>Save</.button>
              </.dialog_footer>
            </.dialog_content>
          </.dialog>

          <.dropdown_menu id="dd">
            <.dropdown_menu_trigger menu="dd"><.button variant="outline">Menu</.button></.dropdown_menu_trigger>
            <.dropdown_menu_content menu="dd">
              <.dropdown_menu_label>My account</.dropdown_menu_label>
              <.dropdown_menu_separator />
              <.dropdown_menu_item menu="dd">Profile</.dropdown_menu_item>
              <.dropdown_menu_item menu="dd">Settings</.dropdown_menu_item>
              <.dropdown_menu_item menu="dd" variant="destructive">Log out</.dropdown_menu_item>
            </.dropdown_menu_content>
          </.dropdown_menu>

          <.popover id="pop">
            <.popover_trigger popover="pop"><.button variant="outline">Popover</.button></.popover_trigger>
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
          <:col :let={r} label="Role"><.badge variant="secondary">{r.role}</.badge></:col>
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
