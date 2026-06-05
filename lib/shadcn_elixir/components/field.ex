defmodule ShadcnElixir.Components.Field do
  @moduledoc """
  Field — a port of shadcn/ui's [Field](https://ui.shadcn.com/docs/components/field).

  Form field primitives. Composed of `field_set/1`, `field_legend/1`, `field_group/1`,
  `field/1`, `field_content/1`, `field_label/1`, `field_title/1`, `field_description/1`,
  `field_separator/1`, and `field_error/1`.
  """
  use Phoenix.Component

  import ShadcnElixir, only: [cn: 1]
  import ShadcnElixir.Variants

  @field %{
    base: "group/field flex w-full gap-3 data-[invalid=true]:text-destructive",
    variants: %{
      orientation: %{
        "vertical" => "flex-col [&>*]:w-full [&>.sr-only]:w-auto",
        "horizontal" =>
          "flex-row items-center [&>[data-slot=field-label]]:flex-auto " <>
            "has-[>[data-slot=field-content]]:items-start",
        "responsive" =>
          "flex-col [&>*]:w-full [&>.sr-only]:w-auto @md/field-group:flex-row " <>
            "@md/field-group:items-center @md/field-group:[&>*]:w-auto"
      }
    },
    default_variants: %{orientation: "vertical"}
  }

  @legend %{
    base: "mb-3 font-medium",
    variants: %{
      variant: %{"legend" => "text-base", "label" => "text-sm"}
    },
    default_variants: %{variant: "legend"}
  }

  @doc "Groups related fields with an optional legend."
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def field_set(assigns) do
    ~H"""
    <fieldset
      data-slot="field-set"
      class={
        cn([
          "flex flex-col gap-6 has-[>[data-slot=checkbox-group]]:gap-3",
          "has-[>[data-slot=radio-group]]:gap-3",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </fieldset>
    """
  end

  attr(:variant, :string, default: nil, values: [nil, "legend", "label"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def field_legend(assigns) do
    assigns =
      assign(assigns, :class, variant(@legend, variant: assigns.variant, class: assigns.class))

    ~H"""
    <legend data-slot="field-legend" data-variant={@variant || "legend"} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </legend>
    """
  end

  @doc "A vertical stack of fields."
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def field_group(assigns) do
    ~H"""
    <div
      data-slot="field-group"
      class={
        cn([
          "group/field-group @container/field-group flex w-full flex-col gap-7",
          "data-[slot=checkbox-group]:gap-3 [&>[data-slot=field-group]]:gap-4",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc """
  Renders a field.

  ## Examples

      <.field>
        <.field_label for="name">Name</.field_label>
        <.input id="name" name="name" />
        <.field_description>Your full name.</.field_description>
      </.field>
  """
  attr(:orientation, :string, default: nil, values: [nil, "vertical", "horizontal", "responsive"])
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def field(assigns) do
    assigns =
      assign(
        assigns,
        :class,
        variant(@field, orientation: assigns.orientation, class: assigns.class)
      )

    ~H"""
    <div role="group" data-slot="field" data-orientation={@orientation || "vertical"} class={@class} {@rest}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def field_content(assigns) do
    ~H"""
    <div
      data-slot="field-content"
      class={cn(["group/field-content flex flex-1 flex-col gap-1.5 leading-snug", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:for, :string, default: nil)
  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def field_label(assigns) do
    ~H"""
    <label
      for={@for}
      data-slot="field-label"
      class={
        cn([
          "group/field-label flex w-fit items-center gap-2 text-sm leading-snug font-medium",
          "select-none group-data-[disabled=true]/field:opacity-50",
          "peer-disabled:cursor-not-allowed peer-disabled:opacity-50",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </label>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def field_title(assigns) do
    ~H"""
    <div
      data-slot="field-title"
      class={cn(["flex w-fit items-center gap-2 text-sm leading-snug font-medium", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def field_description(assigns) do
    ~H"""
    <p
      data-slot="field-description"
      class={
        cn([
          "text-muted-foreground text-sm leading-normal font-normal",
          "[&>a:hover]:text-primary [&>a]:underline [&>a]:underline-offset-4",
          @class
        ])
      }
      {@rest}
    >
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block)

  def field_separator(assigns) do
    ~H"""
    <div
      data-slot="field-separator"
      class={cn(["relative -my-2 h-5 text-sm", @class])}
      {@rest}
    >
      <div class="bg-border absolute inset-0 top-1/2 h-px"></div>
      <span
        :if={@inner_block != []}
        class="bg-background text-muted-foreground relative mx-auto block w-fit px-2"
      >
        {render_slot(@inner_block)}
      </span>
    </div>
    """
  end

  attr(:class, :any, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def field_error(assigns) do
    ~H"""
    <div
      role="alert"
      data-slot="field-error"
      class={cn(["text-destructive text-sm font-normal", @class])}
      {@rest}
    >
      {render_slot(@inner_block)}
    </div>
    """
  end
end
