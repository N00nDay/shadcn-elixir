// ApexCharts-backed `ShadcnChart` hook for the demo/docs site.
//
// The library ships a dependency-free SVG `ShadcnChart` hook for portability; the demo opts
// into ApexCharts for the smooth, Recharts-like look (gradient areas, polished tooltips). It
// reads the same data attributes the `<.chart>` component emits — `data-chart-type`,
// `data-chart-variant`, `data-chart-keys`, `data-chart-legend`, `data-chart` — and maps the
// per-card variants onto ApexCharts options.
//
// Every chart shares ONE custom tooltip (`makeTooltip`) built from the library's own design
// tokens (Tailwind utilities: bg-background, border, text-muted-foreground, font-mono,
// tabular-nums) so the tooltip is cohesive across area/bar/line/pie/radar/radial. The
// Tooltips tab varies that same tooltip via `tip-*` variants (indicator, label, formatter…).
// Colors come from the live `--chart-1..5` / theme CSS variables; a MutationObserver on
// `<html>` re-renders on dark-mode toggle.
import ApexCharts from "apexcharts"

const humanize = (k) => String(k).charAt(0).toUpperCase() + String(k).slice(1)

const esc = (s) =>
  String(s).replace(/[&<>"]/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c]))

const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

// "2024-05-16" -> "May 16, 2024"; anything else is returned unchanged.
const fmtDate = (label) => {
  const m = String(label).match(/^(\d{4})-(\d{2})-(\d{2})/)
  return m ? `${MONTHS[+m[2] - 1]} ${+m[3]}, ${m[1]}` : label
}

// Apply an alpha to a resolved color (oklch / rgb); leaves other formats unchanged.
function withAlpha(color, a) {
  const c = String(color).trim()
  const ok = c.match(/^oklch\(([^)]+)\)$/i)
  if (ok) return `oklch(${ok[1].split("/")[0].trim()} / ${a})`
  const rgb = c.match(/^rgba?\(([^)]+)\)$/i)
  if (rgb) return `rgba(${rgb[1].split(",").slice(0, 3).join(",")}, ${a})`
  return c
}

// Expand a single monochrome color into N readable shades (for pie slices, radial rings,
// "mixed" bars) so a mono theme stays legible where distinct colors are needed.
function monoShades(color, n) {
  if (n <= 1) return [color]
  return Array.from({ length: n }, (_, i) => withAlpha(color, 1 - (i / n) * 0.78))
}

// Resolve theme tokens from the chart element so scoped themes (a `data-base` ancestor) win.
function themeTokens(el) {
  const cs = getComputedStyle(el || document.documentElement)
  const v = (name) => cs.getPropertyValue(name).trim()
  return {
    colors: [1, 2, 3, 4, 5].map((i) => v(`--chart-${i}`)),
    foreground: v("--foreground"),
    muted: v("--muted-foreground"),
    border: v("--border"),
    background: v("--background"),
    dark: document.documentElement.classList.contains("dark"),
  }
}

function parse(el) {
  let data = []
  let keys = ["value"]
  try {
    data = JSON.parse(el.dataset.chart || "[]")
  } catch (_e) {}
  try {
    keys = JSON.parse(el.dataset.chartKeys || '["value"]')
  } catch (_e) {}
  let colors = null
  try {
    colors = JSON.parse(el.dataset.chartColors || "null")
  } catch (_e) {}
  return {
    type: el.dataset.chartType || "bar",
    variant: el.dataset.chartVariant || "",
    legend: el.dataset.chartLegend === "true",
    keys,
    data,
    colors,
  }
}

function curveFor(variant) {
  if (variant === "linear") return "straight"
  if (variant === "step") return "stepline"
  return "smooth"
}

// ---- Cohesive custom tooltip (grounded in library design tokens) ------------

// Tooltip behaviour for the Tooltips tab (`tip-*`); everything else gets the default dot.
function tooltipOptsFor(variant) {
  switch (variant) {
    case "tip-line":
      return { indicator: "line" }
    case "tip-none":
      return { indicator: "none" }
    case "tip-no-label":
      return { indicator: "dot", hideLabel: true }
    case "tip-custom-label":
      return { indicator: "dot", labelFmt: (l) => `${l} 2024` }
    case "tip-label-formatter":
      return { indicator: "dot", labelFmt: (l) => String(l).toUpperCase() }
    case "tip-formatter":
      return { indicator: "dot", valueFmt: (v) => `${Number(v).toLocaleString()} visitors` }
    case "tip-icons":
      return { indicator: "icon" }
    case "tip-advanced":
      return { indicator: "dot", valueFmt: (v) => Number(v).toLocaleString(), total: true }
    default:
      return { indicator: "dot" }
  }
}

function indicatorHtml(color, opts) {
  if (opts.indicator === "none") return ""
  const cls =
    opts.indicator === "line"
      ? "h-3 w-1 shrink-0 rounded-full"
      : opts.indicator === "icon"
        ? "size-2.5 shrink-0 rounded-full"
        : "size-2.5 shrink-0 rounded-[2px]"
  return `<span class="${cls}" style="background:${color}"></span>`
}

function rowHtml(name, value, color, opts) {
  return (
    `<div class="flex items-center justify-between gap-4 leading-none">` +
    `<div class="flex items-center gap-1.5 text-muted-foreground">${indicatorHtml(color, opts)}<span>${esc(name)}</span></div>` +
    `<span class="font-mono font-medium tabular-nums text-foreground">${esc(value)}</span>` +
    `</div>`
  )
}

function wrapHtml(title, rows, opts, totalRow = "") {
  const head =
    !opts.hideLabel && title != null && title !== ""
      ? `<div class="font-medium text-foreground">${esc(title)}</div>`
      : ""
  return (
    `<div class="grid min-w-[8rem] gap-1.5 rounded-lg border bg-background px-2.5 py-1.5 text-xs shadow-xl">` +
    head +
    `<div class="grid gap-1.5">${rows}${totalRow}</div>` +
    `</div>`
  )
}

function makeTooltip(cfg, opts) {
  const { type, keys, data } = cfg
  const lf = opts.labelFmt || ((l) => l)
  const vf = opts.valueFmt || ((v) => v)

  return ({ seriesIndex, dataPointIndex, w }) => {
    const colors = w.globals.colors

    // Pie / donut / radialBar: one slice or ring per index.
    if (type === "pie" || type === "donut" || type === "radial") {
      const i = seriesIndex
      const d = data[i] || {}
      return wrapHtml(null, rowHtml(d.label, vf(d[keys[0]]), colors[i], opts), opts)
    }

    // Radar + cartesian: a row per series at the hovered category.
    const di = dataPointIndex
    const d = data[di] || {}
    const rows = keys.map((k, si) => rowHtml(humanize(k), vf(d[k]), colors[si], opts)).join("")
    let totalRow = ""
    if (opts.total) {
      const sum = keys.reduce((s, k) => s + (Number(d[k]) || 0), 0)
      totalRow =
        `<div class="mt-0.5 flex items-center justify-between gap-4 border-t pt-1.5 leading-none font-medium text-foreground">` +
        `<span>Total</span><span class="font-mono tabular-nums">${esc(vf(sum))}</span></div>`
    }
    return wrapHtml(lf(fmtDate(d.label)), rows, opts, totalRow)
  }
}

// ---- Options ----------------------------------------------------------------

function buildOptions(cfg, t, el) {
  const { type, variant, legend, keys, data } = cfg
  const labels = data.map((d) => d.label)
  const polar = ["pie", "donut", "radar", "radial"].includes(type)
  const stacked = (type === "bar" || type === "area") && (variant === "stacked" || variant === "expanded")
  const showLabels = ["label", "custom-label", "label-list"].includes(variant)
  const tipOpts = tooltipOptsFor(variant)
  // Radar fires tooltips per-marker (intersect), not shared, so keep it out of `shared`.
  const shared = type === "bar" || type === "line" || type === "area"

  const base = {
    chart: {
      type: type === "donut" ? "donut" : type === "radial" ? "radialBar" : type,
      height: "100%",
      width: "100%",
      parentHeightOffset: 0,
      fontFamily: "inherit",
      background: "transparent",
      toolbar: { show: false },
      zoom: { enabled: false },
      stacked,
      // "expanded" is normalized to %s in the series below, then stacked normally — more
      // reliable than ApexCharts' own "100%" stackType, which renders area charts wrong.
      stackType: "normal",
      animations: { enabled: true, speed: 400 },
    },
    colors: t.colors,
    dataLabels: {
      enabled: showLabels,
      style: { fontSize: "11px", fontWeight: 500, colors: undefined },
      background: { enabled: false },
      dropShadow: { enabled: false },
    },
    legend: {
      show: legend,
      position: "bottom",
      // Breathing room above the legend (between it and the x-axis).
      offsetY: 8,
      fontSize: "13px",
      labels: { colors: t.foreground },
      markers: { size: 6, shape: "circle" },
      itemMargin: { horizontal: 10, vertical: 4 },
    },
    tooltip: { shared, intersect: !shared, custom: makeTooltip(cfg, tipOpts) },
    grid: { borderColor: t.border, strokeDashArray: 4, padding: { top: 0, bottom: 0 } },
    stroke: { lineCap: "round" },
  }

  // Optional per-chart color override (CSS var names → resolved values), expanded into
  // monochrome shades when more distinct colors are needed than were given (pie slices,
  // radial rings, distributed "mixed" bars).
  if (cfg.colors && cfg.colors.length) {
    const cs = getComputedStyle(el || document.documentElement)
    let resolved = cfg.colors.map((name) => cs.getPropertyValue(name).trim() || name)
    const distinct =
      type === "pie" || type === "donut" || type === "radial"
        ? data.length
        : type === "bar" && variant === "mixed"
          ? data.length
          : resolved.length
    if (resolved.length < distinct) resolved = monoShades(resolved[0], distinct)
    base.colors = resolved
  }

  // ---- Polar: pie / donut --------------------------------------------------
  if (type === "pie" || type === "donut") {
    const key = keys[0]
    base.series = data.map((d) => Number(d[key]) || 0)
    base.labels = labels
    base.stroke = { width: 2, colors: ["var(--background)"] }
    base.dataLabels.style.colors = ["#fff"]
    base.plotOptions = {
      pie: {
        expandOnClick: false,
        donut: { size: type === "donut" ? "62%" : "0%" },
      },
    }
    if (variant === "donut-text") {
      const total = data.reduce((s, d) => s + (Number(d[key]) || 0), 0)
      base.plotOptions.pie.donut.labels = {
        show: true,
        name: { show: true, fontSize: "13px", offsetY: 18, color: t.muted },
        value: { show: true, fontSize: "26px", fontWeight: 700, offsetY: -16, color: t.foreground },
        total: { show: true, showAlways: true, label: "Visitors", color: t.muted, formatter: () => String(total) },
      }
    }
    return base
  }

  // ---- Polar: radar --------------------------------------------------------
  if (type === "radar") {
    base.series = keys.map((k) => ({ name: humanize(k), data: data.map((r) => Number(r[k]) || 0) }))
    base.labels = labels
    base.xaxis = { categories: labels, labels: { style: { colors: labels.map(() => t.muted) } } }
    base.yaxis = { show: false }
    base.stroke = { width: 2, lineCap: "round" }
    base.fill = { opacity: variant === "lines-only" ? 0 : variant.includes("filled") ? 0.5 : 0.2 }
    // Markers must be hoverable for the tooltip to fire — keep them small but present.
    base.markers = { size: variant === "dots" ? 5 : 3, strokeWidth: 1, hover: { size: 6 } }
    base.plotOptions = { radar: { polygons: { strokeColors: t.border, connectorColors: t.border } } }
    return base
  }

  // ---- Polar: radialBar ----------------------------------------------------
  // radialBar has no floating tooltip — its hover feedback is the center label, which
  // updates to the hovered ring (and shows a resting total/value). Variants differ by ring
  // count (single gauge vs. concentric rings vs. stacked) and what the center shows.
  if (type === "radial") {
    const multiKey = keys.length > 1
    const ringLabels = multiKey ? keys.map(humanize) : data.map((d) => d.label)
    const realValues = multiKey
      ? keys.map((k) => Number(data[0][k]) || 0)
      : data.map((d) => Number(d[keys[0]]) || 0)
    const single = realValues.length === 1
    const total = realValues.reduce((s, v) => s + v, 0)
    // Single-value gauges scale to a rounded target (partial fill); rings scale to the max.
    const target = single ? Math.ceil(realValues[0] / 500) * 500 : Math.max(1, ...realValues)
    const centerTotal = variant === "text" || variant === "stacked"

    base.series = realValues.map((v) => Math.round((v / target) * 100))
    base.labels = ringLabels
    base.tooltip = { enabled: false }
    base.plotOptions = {
      radialBar: {
        hollow: { size: variant === "shape" ? "42%" : single ? "58%" : "44%" },
        track: { background: t.border, strokeWidth: "100%", margin: 4 },
        dataLabels: {
          show: true,
          name: { show: true, fontSize: "13px", offsetY: single ? 24 : 20, color: t.muted },
          value: {
            show: true,
            fontSize: single ? "30px" : "22px",
            fontWeight: 700,
            offsetY: single ? -14 : -16,
            color: t.foreground,
            formatter: (val, opts) => String(realValues[(opts && opts.seriesIndex) || 0]),
          },
          total: {
            show: true,
            label: centerTotal ? "Visitors" : ringLabels[ringLabels.length - 1],
            color: t.muted,
            formatter: () => String(centerTotal ? total : realValues[realValues.length - 1]),
          },
        },
      },
    }
    return base
  }

  // ---- Cartesian: bar / line / area ---------------------------------------
  // "Expanded" stacks the series to a constant 100% — normalize each point ourselves.
  const expanded = type === "area" && variant === "expanded"
  base.series = keys.map((k) => ({
    name: humanize(k),
    data: data.map((r) => {
      const v = Number(r[k]) || 0
      if (!expanded) return v
      const total = keys.reduce((s, kk) => s + (Number(r[kk]) || 0), 0) || 1
      return Math.round((v / total) * 1000) / 10
    }),
  }))
  // ISO date labels (e.g. dense daily data) → a datetime axis with weekly "MMM dd" ticks.
  const isDate = labels.length > 0 && /^\d{4}-\d{2}-\d{2}/.test(String(labels[0]))
  base.xaxis = {
    type: isDate ? "datetime" : "category",
    categories: labels,
    tickAmount: isDate ? 12 : undefined,
    labels: {
      style: { colors: isDate ? t.muted : labels.map(() => t.muted), fontSize: "11px" },
      format: isDate ? "MMM dd" : undefined,
      datetimeUTC: false,
      rotate: 0,
      hideOverlappingLabels: true,
    },
    axisBorder: { show: false },
    axisTicks: { show: false },
    // Our custom tooltip already shows the category, so drop ApexCharts' bottom axis label.
    tooltip: { enabled: false },
    // A soft highlight band only as wide as the point it captures — the bar's width for
    // bars, a thin point-width band for line/area (becomes a line as the data gets dense).
    // Horizontal bars highlight along the y-axis instead (see below).
    crosshairs: {
      show: !(type === "bar" && variant === "horizontal"),
      width: type === "bar" ? "barWidth" : 8,
      fill: { type: "solid", color: t.muted },
      opacity: 0.12,
      stroke: { width: 0, dashArray: 0 },
      dropShadow: { enabled: false },
    },
  }
  base.yaxis = { show: false, max: expanded ? 100 : undefined }

  if (type === "bar") {
    base.stroke = { width: 0 }
    base.plotOptions = {
      bar: {
        horizontal: variant === "horizontal",
        distributed: variant === "mixed",
        borderRadius: 4,
        borderRadiusApplication: "end",
        columnWidth: "60%",
        dataLabels: { position: variant === "custom-label" ? "bottom" : "top" },
      },
    }
    if (variant === "mixed") base.legend.show = false
    base.dataLabels.style.colors = [t.foreground]
  } else {
    // line / area
    base.stroke = { curve: curveFor(variant), width: 2, lineCap: "round" }
    // Show dots for the dots* variants AND the label variants (labels sit above the dots).
    const lineDots =
      type === "line" &&
      (variant.startsWith("dots") || variant === "label" || variant === "custom-label")
    base.markers = { size: lineDots ? 5 : 0, strokeWidth: 2, hover: { sizeOffset: 2 } }

    if (variant === "dots-custom") {
      // Hollow ring dots (background fill, series-colored stroke) — distinct from filled "dots".
      base.markers.size = 6
      base.markers.colors = [t.background]
      base.markers.strokeColors = base.colors
      base.markers.strokeWidth = 2
    } else if (variant === "dots-colors") {
      // A different shade per dot.
      const shades = monoShades(base.colors[0] || t.foreground, data.length)
      base.markers.discrete = data.map((_, i) => ({
        seriesIndex: 0,
        dataPointIndex: i,
        fillColor: shades[i],
        strokeColor: shades[i],
        size: 5,
      }))
    }

    base.dataLabels.style.colors = [t.foreground]
    // Label variants: lift the value label above the dot.
    if (type === "line" && (variant === "label" || variant === "custom-label")) {
      base.dataLabels.offsetY = -10
    }
    if (type === "area") {
      base.fill = {
        type: "gradient",
        gradient: {
          shadeIntensity: 1,
          opacityFrom: variant === "gradient" ? 0.7 : 0.4,
          opacityTo: variant === "gradient" ? 0.1 : 0.05,
          stops: [0, 95],
        },
      }
    }
  }
  return base
}

// A fingerprint of everything that affects the rendered chart — used to skip needless
// rebuilds when LiveView re-renders the page but this chart's data didn't change.
function chartSignature(el) {
  const d = el.dataset
  return [d.chart, d.chartType, d.chartVariant, d.chartKeys, d.chartColors, d.chartLegend, d.chartTheme].join("|")
}

// Horizontal bars get no native category crosshair, so highlight the hovered ROW ourselves:
// track the cursor's y over the whole plot and band the corresponding category row (behind the
// transparent-bg chart svg, so the white bar stays on top — like the vertical column band).
function setupRowHighlight(root, numRows) {
  if (root.__rowHLCleanup) root.__rowHLCleanup()

  const band = document.createElement("div")
  band.style.cssText = "position:absolute;left:0;right:0;display:none;pointer-events:none;"
  band.style.background = getComputedStyle(root).getPropertyValue("--muted-foreground").trim()
  band.style.opacity = "0.12"
  root.insertBefore(band, root.firstChild)

  const onMove = (e) => {
    const grid = root.querySelector(".apexcharts-grid")
    if (!grid || numRows < 1) return
    const g = grid.getBoundingClientRect()
    const rr = root.getBoundingClientRect()
    const yInGrid = e.clientY - g.top
    if (yInGrid < 0 || yInGrid > g.height) {
      band.style.display = "none"
      return
    }
    const rowH = g.height / numRows
    const idx = Math.min(numRows - 1, Math.max(0, Math.floor(yInGrid / rowH)))
    band.style.top = `${g.top - rr.top + idx * rowH}px`
    band.style.height = `${rowH}px`
    band.style.display = "block"
  }
  const onLeave = () => {
    band.style.display = "none"
  }

  root.addEventListener("mousemove", onMove)
  root.addEventListener("mouseleave", onLeave)
  root.__rowHLCleanup = () => {
    root.removeEventListener("mousemove", onMove)
    root.removeEventListener("mouseleave", onLeave)
    if (band.parentNode) band.parentNode.removeChild(band)
    root.__rowHLCleanup = null
  }
}

function build(el) {
  const cfg = parse(el)
  const opts = buildOptions(cfg, themeTokens(el), el)
  if (!el.style.position) el.style.position = "relative"
  const mount = document.createElement("div")
  mount.style.width = "100%"
  mount.style.height = "100%"
  // Skeleton placeholder fills the reserved space until the chart finishes rendering.
  const skeleton = document.createElement("div")
  skeleton.className = "absolute inset-2 animate-pulse rounded-md bg-muted/60"
  el.replaceChildren(mount, skeleton)
  if (el.__rowHLCleanup) el.__rowHLCleanup()
  const chart = new ApexCharts(mount, opts)
  const done = () => {
    skeleton.remove()
    if (cfg.type === "bar" && cfg.variant === "horizontal") setupRowHighlight(el, cfg.data.length)
  }
  chart.render().then(done, done)
  return chart
}

export const ShadcnChart = {
  mounted() {
    this._sig = chartSignature(this.el)
    this.chart = build(this.el)
    // Re-render with fresh token colors when the theme (`.dark`) toggles.
    this._obs = new MutationObserver(() => {
      if (this.chart) this.chart.destroy()
      this.chart = build(this.el)
    })
    this._obs.observe(document.documentElement, { attributes: true, attributeFilter: ["class"] })
  },
  updated() {
    // Only rebuild when THIS chart's data changed — other LiveView updates leave it alone.
    const sig = chartSignature(this.el)
    if (sig === this._sig) return
    this._sig = sig
    if (this.chart) this.chart.destroy()
    this.chart = build(this.el)
  },
  destroyed() {
    if (this._obs) this._obs.disconnect()
    if (this.el.__rowHLCleanup) this.el.__rowHLCleanup()
    if (this.chart) this.chart.destroy()
  },
}
