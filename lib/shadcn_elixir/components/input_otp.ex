defmodule ShadcnElixir.Components.InputOTP do
  @moduledoc """
  InputOTP — a port of shadcn/ui's
  [Input OTP](https://ui.shadcn.com/docs/components/input-otp).

  A segmented one-time-password input. Auto-advance, backspace, and paste are handled by
  the `ShadcnInputOTP` JS hook (see `assets/js/shadcn_elixir.js`), which keeps a hidden
  combined value in sync for form submission.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]

  @doc """
  Renders an OTP input.

  ## Examples

      <.input_otp id="otp" name="code" length={6} />
  """
  attr(:id, :string, required: true)
  attr(:name, :string, default: nil)
  attr(:length, :integer, default: 6)
  attr(:value, :string, default: "")
  attr(:class, :any, default: nil)
  attr(:rest, :global)

  def input_otp(assigns) do
    assigns = assign(assigns, :slots, 0..(assigns.length - 1))

    ~H"""
    <div
      id={@id}
      phx-hook="ShadcnInputOTP"
      data-slot="input-otp"
      data-length={@length}
      class={cn(["flex items-center gap-2", @class])}
      {@rest}
    >
      <input type="hidden" name={@name} value={@value} data-part="value" />
      <div data-slot="input-otp-group" class="flex items-center">
        <input
          :for={i <- @slots}
          type="text"
          inputmode="numeric"
          autocomplete="one-time-code"
          maxlength="1"
          data-part="slot"
          data-index={i}
          value={String.at(@value, i) || ""}
          class={
            cn([
              "border-input relative flex size-9 items-center justify-center border-y border-r",
              "text-center text-sm shadow-xs outline-none transition-all first:rounded-l-md",
              "first:border-l last:rounded-r-md",
              "focus:border-ring focus:ring-ring/50 focus:ring-[3px] focus:z-10"
            ])
          }
        />
      </div>
    </div>
    """
  end
end
