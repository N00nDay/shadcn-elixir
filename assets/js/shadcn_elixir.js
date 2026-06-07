// shadcn-elixir client behaviors.
//
// Usage with LiveView (recommended):
//
//   import { Hooks } from "../../deps/shadcn_elixir/assets/js/shadcn_elixir";
//   const liveSocket = new LiveSocket("/live", Socket, { hooks: { ...Hooks } });
//
// Usage without LiveView (dead/static views) — call once after DOM load:
//
//   import { initShadcn } from "../../deps/shadcn_elixir/assets/js/shadcn_elixir";
//   document.addEventListener("DOMContentLoaded", initShadcn);
//
// Components that rely on these hooks: Select, Command, Combobox. The rest
// (dialog, popover, dropdown, tabs, accordion, …) use Phoenix.LiveView.JS or
// native HTML and need no JS here.

const q = (root, sel) => root.querySelector(sel);
const qa = (root, sel) => Array.from(root.querySelectorAll(sel));
const fire = (el, type) => el.dispatchEvent(new Event(type, { bubbles: true }));

// ---- Select -----------------------------------------------------------------

function setupSelect(root) {
  if (root.__shadcnBound) return;
  root.__shadcnBound = true;

  const trigger = q(root, '[data-part="trigger"]');
  const content = q(root, '[data-part="content"]');
  const input = q(root, 'input[data-part="input"]');
  const valueEl = q(root, '[data-part="value"]');
  const items = qa(root, '[data-part="item"]');

  const open = () => {
    // Match the dropdown width to the trigger (like radix's --radix-select-trigger-width),
    // so the menu never overhangs regardless of container sizing.
    content.style.width = trigger.offsetWidth + "px";
    content.hidden = false;
    root.dataset.state = "open";
    trigger.setAttribute("aria-expanded", "true");
  };
  const close = () => {
    content.hidden = true;
    root.dataset.state = "closed";
    trigger.setAttribute("aria-expanded", "false");
  };
  const choose = (item) => {
    input.value = item.dataset.value;
    if (valueEl) {
      valueEl.textContent = item.textContent.trim();
      valueEl.removeAttribute("data-placeholder");
      valueEl.classList.remove("text-muted-foreground");
    }
    items.forEach((i) => {
      const on = i === item;
      i.setAttribute("aria-selected", on ? "true" : "false");
      const check = q(i, '[data-part="check"] svg');
      if (check) check.classList.toggle("hidden", !on);
    });
    fire(input, "input");
    fire(input, "change");
    close();
  };

  trigger.addEventListener("click", (e) => {
    e.preventDefault();
    root.dataset.state === "open" ? close() : open();
  });
  items.forEach((item) => item.addEventListener("click", () => choose(item)));
  document.addEventListener("click", (e) => {
    if (!root.contains(e.target)) close();
  });
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") close();
  });

  // reflect an initial value
  if (input.value) {
    const initial = items.find((i) => i.dataset.value === input.value);
    if (initial) choose(initial);
  }
}

// ---- Command (filter) -------------------------------------------------------

function setupCommand(root) {
  if (root.__shadcnBound) return;
  root.__shadcnBound = true;

  const input = q(root, '[data-part="input"]');
  const empty = q(root, '[data-part="empty"]');
  const items = qa(root, '[data-part="item"]');
  const groups = qa(root, '[data-part="group"]');

  const filter = () => {
    const term = (input.value || "").trim().toLowerCase();
    let visible = 0;
    items.forEach((item) => {
      const hay = ((item.dataset.value || "") + " " + item.textContent).toLowerCase();
      const match = hay.includes(term);
      item.hidden = !match;
      if (match) visible++;
    });
    groups.forEach((group) => {
      const any = qa(group, '[data-part="item"]').some((i) => !i.hidden);
      group.hidden = !any;
    });
    if (empty) empty.hidden = visible > 0;
  };

  if (input) input.addEventListener("input", filter);
  filter();
}

// ---- Combobox (Popover + Command + hidden input) ----------------------------

function setupCombobox(root) {
  if (root.__shadcnBound) return;
  root.__shadcnBound = true;

  const trigger = q(root, '[data-part="trigger"]');
  const content = q(root, '[data-part="content"]');
  const input = q(root, 'input[data-part="input"]');
  const search = q(root, '[data-part="search"]');
  const valueEl = q(root, '[data-part="value"]');
  const empty = q(root, '[data-part="empty"]');
  const items = qa(root, '[data-part="item"]');

  const open = () => {
    // Match the dropdown width to the trigger (like the Select), so it never overhangs.
    content.style.width = trigger.offsetWidth + "px";
    content.hidden = false;
    root.dataset.state = "open";
    trigger.setAttribute("aria-expanded", "true");
    if (search) search.focus();
  };
  const close = () => {
    content.hidden = true;
    root.dataset.state = "closed";
    trigger.setAttribute("aria-expanded", "false");
  };
  const choose = (item) => {
    input.value = item.dataset.value;
    if (valueEl) {
      valueEl.textContent = item.querySelector("span")?.textContent.trim() ?? item.textContent.trim();
      valueEl.classList.remove("text-muted-foreground");
    }
    items.forEach((i) => {
      const on = i === item;
      i.setAttribute("aria-selected", on ? "true" : "false");
      const check = q(i, '[data-part="check"]');
      if (check) check.classList.toggle("hidden", !on);
    });
    fire(input, "input");
    fire(input, "change");
    close();
  };
  const filter = () => {
    const term = (search.value || "").trim().toLowerCase();
    let visible = 0;
    items.forEach((item) => {
      const match = item.textContent.toLowerCase().includes(term);
      item.hidden = !match;
      if (match) visible++;
    });
    if (empty) empty.hidden = visible > 0;
  };

  trigger.addEventListener("click", (e) => {
    e.preventDefault();
    root.dataset.state === "open" ? close() : open();
  });
  if (search) search.addEventListener("input", filter);
  items.forEach((item) => item.addEventListener("click", () => choose(item)));
  document.addEventListener("click", (e) => {
    if (!root.contains(e.target)) close();
  });
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") close();
  });

  if (input.value) {
    const initial = items.find((i) => i.dataset.value === input.value);
    if (initial) choose(initial);
  }
}

// ---- Input OTP --------------------------------------------------------------

function setupInputOTP(root) {
  if (root.__shadcnBound) return;
  root.__shadcnBound = true;

  const hidden = q(root, '[data-part="value"]');
  const slots = qa(root, '[data-part="slot"]');
  const sync = () => {
    hidden.value = slots.map((s) => s.value).join("");
    fire(hidden, "input");
  };

  slots.forEach((slot, i) => {
    slot.addEventListener("input", () => {
      slot.value = slot.value.replace(/\D/g, "").slice(-1);
      if (slot.value && slots[i + 1]) slots[i + 1].focus();
      sync();
    });
    slot.addEventListener("keydown", (e) => {
      if (e.key === "Backspace" && !slot.value && slots[i - 1]) {
        slots[i - 1].focus();
      }
    });
    slot.addEventListener("paste", (e) => {
      e.preventDefault();
      const text = (e.clipboardData.getData("text") || "").replace(/\D/g, "");
      slots.forEach((s, j) => (s.value = text[j] || ""));
      const next = Math.min(text.length, slots.length - 1);
      slots[next].focus();
      sync();
    });
  });
}

// ---- Menu (dropdown / context / menubar keyboard support) -------------------
//
// Brings the `role="menu"` content up to the WAI-ARIA menu pattern: roving focus
// with Arrow/Home/End, Enter/Space to activate, focus moves to the first item on
// open and returns to the opener (the trigger) on close, and the trigger button
// gets aria-haspopup / aria-controls / aria-expanded kept in sync.

const MENU_ITEM_SEL =
  '[role="menuitem"], [role="menuitemcheckbox"], [role="menuitemradio"]';

function setupMenu(root) {
  if (root.__shadcnBound) return;
  root.__shadcnBound = true;

  // The trigger lives next to the content inside the menu wrapper. Resolve the
  // real focusable control (the inner <button>/<a>) so ARIA lands on it.
  const wrapper = root.parentElement;
  const host = wrapper && q(wrapper, '[data-slot$="-trigger"]');
  const trigger = host
    ? host.matches('button, a, [role="button"]')
      ? host
      : host.querySelector('button, a, [role="button"]') || host
    : null;
  if (trigger) {
    trigger.setAttribute("aria-haspopup", "menu");
    trigger.setAttribute("aria-controls", root.id);
    if (!trigger.hasAttribute("aria-expanded"))
      trigger.setAttribute("aria-expanded", "false");
  }

  const enabledItems = () =>
    qa(root, MENU_ITEM_SEL).filter(
      (el) =>
        !el.hidden &&
        el.getAttribute("aria-disabled") !== "true" &&
        el.getAttribute("data-disabled") !== "true" &&
        el.offsetParent !== null
    );

  const focusAt = (list, i) => {
    if (!list.length) return;
    list[(i + list.length) % list.length].focus();
  };

  root.addEventListener("keydown", (e) => {
    const list = enabledItems();
    const i = list.indexOf(document.activeElement);
    switch (e.key) {
      case "ArrowDown":
        e.preventDefault();
        focusAt(list, i < 0 ? 0 : i + 1);
        break;
      case "ArrowUp":
        e.preventDefault();
        focusAt(list, i < 0 ? list.length - 1 : i - 1);
        break;
      case "Home":
        e.preventDefault();
        focusAt(list, 0);
        break;
      case "End":
        e.preventDefault();
        focusAt(list, list.length - 1);
        break;
      case "Enter":
      case " ":
        if (i >= 0) {
          e.preventDefault();
          list[i].click();
        }
        break;
    }
  });

  // React to open/close (driven by data-state) to move focus and sync the trigger.
  const sync = () => {
    const open = root.dataset.state === "open";
    if (trigger) trigger.setAttribute("aria-expanded", open ? "true" : "false");
    if (open && !root.__open) {
      root.__open = true;
      root.__opener = document.activeElement;
      requestAnimationFrame(() => focusAt(enabledItems(), 0));
    } else if (!open && root.__open) {
      root.__open = false;
      const opener = root.__opener;
      if (opener && typeof opener.focus === "function") opener.focus();
    }
  };
  new MutationObserver(sync).observe(root, {
    attributes: true,
    attributeFilter: ["data-state"],
  });
}

// ---- Tabs (roving tabindex + arrow-key navigation) --------------------------
//
// Adds the WAI-ARIA Tabs keyboard pattern on top of the click-driven JS: arrow
// keys move between tabs (Left/Right horizontal, Up/Down vertical), Home/End jump
// to the first/last, and activation follows focus (clicking applies selection).

function setupTabs(root) {
  if (root.__shadcnTabsBound) return;
  root.__shadcnTabsBound = true;

  const vertical = root.dataset.orientation === "vertical";
  const tabs = () => qa(root, '[role="tab"]').filter((t) => !t.disabled);

  root.addEventListener("keydown", (e) => {
    const tab = e.target.closest('[role="tab"]');
    if (!tab || !root.contains(tab)) return;
    const list = tabs();
    const i = list.indexOf(tab);
    if (i < 0) return;
    const next = vertical ? "ArrowDown" : "ArrowRight";
    const prev = vertical ? "ArrowUp" : "ArrowLeft";
    let target = null;
    if (e.key === next) target = list[(i + 1) % list.length];
    else if (e.key === prev) target = list[(i - 1 + list.length) % list.length];
    else if (e.key === "Home") target = list[0];
    else if (e.key === "End") target = list[list.length - 1];
    if (target) {
      e.preventDefault();
      target.focus();
      target.click(); // activation follows focus (radix default)
    }
  });
}

// ---- Resizable --------------------------------------------------------------

function setupResizable(root) {
  if (root.__shadcnBound) return;
  root.__shadcnBound = true;

  const vertical = root.dataset.direction === "vertical";
  qa(root, '[data-part="handle"]').forEach((handle) => {
    const prev = handle.previousElementSibling;
    const next = handle.nextElementSibling;

    // The splitter's orientation is perpendicular to the panel layout.
    handle.setAttribute("aria-orientation", vertical ? "horizontal" : "vertical");
    handle.setAttribute("aria-valuemin", "0");
    handle.setAttribute("aria-valuemax", "100");

    const sizeOf = (el) => (vertical ? el.offsetHeight : el.offsetWidth);
    const reportValue = () => {
      if (!prev || !next) return;
      const total = sizeOf(prev) + sizeOf(next);
      const pct = total ? Math.round((sizeOf(prev) / total) * 100) : 0;
      handle.setAttribute("aria-valuenow", String(pct));
    };
    const applyPct = (pct) => {
      if (!prev || !next) return;
      const p = Math.max(0, Math.min(100, pct));
      prev.style.flex = `${p} 1 0%`;
      next.style.flex = `${100 - p} 1 0%`;
      handle.setAttribute("aria-valuenow", String(Math.round(p)));
    };
    reportValue();

    // Keyboard resize (WAI-ARIA Window Splitter): arrows nudge, Home/End snap.
    handle.addEventListener("keydown", (e) => {
      if (!prev || !next) return;
      const total = sizeOf(prev) + sizeOf(next);
      const cur = total ? (sizeOf(prev) / total) * 100 : 0;
      const dec = vertical ? "ArrowUp" : "ArrowLeft";
      const inc = vertical ? "ArrowDown" : "ArrowRight";
      if (e.key === dec) (e.preventDefault(), applyPct(cur - 5));
      else if (e.key === inc) (e.preventDefault(), applyPct(cur + 5));
      else if (e.key === "Home") (e.preventDefault(), applyPct(0));
      else if (e.key === "End") (e.preventDefault(), applyPct(100));
    });

    handle.addEventListener("pointerdown", (e) => {
      e.preventDefault();
      if (!prev || !next) return;
      const startPos = vertical ? e.clientY : e.clientX;
      const prevSize = sizeOf(prev);
      const nextSize = sizeOf(next);
      const total = prevSize + nextSize;

      const onMove = (ev) => {
        const delta = (vertical ? ev.clientY : ev.clientX) - startPos;
        const newPrev = Math.max(0, Math.min(total, prevSize + delta));
        prev.style.flex = `${newPrev} 1 0%`;
        next.style.flex = `${total - newPrev} 1 0%`;
        handle.setAttribute(
          "aria-valuenow",
          String(total ? Math.round((newPrev / total) * 100) : 0)
        );
      };
      const onUp = () => {
        document.removeEventListener("pointermove", onMove);
        document.removeEventListener("pointerup", onUp);
      };
      document.addEventListener("pointermove", onMove);
      document.addEventListener("pointerup", onUp);
    });
  });
}

// ---- Chart (lightweight SVG, built with safe DOM APIs) ----------------------

const SVGNS = "http://www.w3.org/2000/svg";
const svgEl = (name, attrs) => {
  const node = document.createElementNS(SVGNS, name);
  for (const k in attrs) node.setAttribute(k, attrs[k]);
  return node;
};

const chartColor = (i) =>
  `var(--color-chart-${(i % 5) + 1}, var(--chart-${(i % 5) + 1}))`;

const humanize = (k) => String(k).charAt(0).toUpperCase() + String(k).slice(1);

function setupChart(root) {
  const type = root.dataset.chartType || "bar";
  const variant = root.dataset.chartVariant || "";
  const legend = root.dataset.chartLegend === "true";
  let data = [];
  let keys = ["value"];
  try {
    data = JSON.parse(root.dataset.chart || "[]");
  } catch (_e) {
    data = [];
  }
  try {
    keys = JSON.parse(root.dataset.chartKeys || '["value"]');
  } catch (_e) {
    keys = ["value"];
  }

  if (!root.style.position) root.style.position = "relative";
  const tip = chartTooltip(root, tooltipCfg(variant));

  const svg =
    type === "pie" || type === "donut"
      ? renderPie(data, keys, type, variant, tip)
      : type === "radar"
        ? renderRadar(data, keys, variant, tip)
        : type === "radial"
          ? renderRadial(data, keys, variant, tip)
          : renderCartesian(type, data, keys, variant, tip);

  if (legend) {
    root.style.flexDirection = "column";
    root.style.alignItems = "center";
    root.style.gap = "8px";
    svg.style.flex = "1 1 auto";
    svg.style.minHeight = "0";
    svg.style.height = "auto";
    root.replaceChildren(svg, buildLegend(legendItems(type, data, keys)));
  } else {
    root.replaceChildren(svg);
  }
  root.appendChild(tip.el);
}

function legendItems(type, data, keys) {
  if (type === "pie" || type === "donut") {
    return data.map((d, i) => ({ label: d.label, color: chartColor(i) }));
  }
  return keys.map((k, i) => ({ label: humanize(k), color: chartColor(i) }));
}

function buildLegend(items) {
  const wrap = document.createElement("div");
  wrap.className =
    "flex flex-wrap items-center justify-center gap-x-4 gap-y-1 pt-1 text-muted-foreground";
  items.forEach((it) => {
    const row = document.createElement("div");
    row.className = "flex items-center gap-1.5";
    const sw = document.createElement("span");
    sw.className = "size-2.5 shrink-0 rounded-[2px]";
    sw.style.background = it.color;
    const lbl = document.createElement("span");
    lbl.textContent = it.label;
    row.append(sw, lbl);
    wrap.appendChild(row);
  });
  return wrap;
}

function tooltipCfg(variant) {
  switch (variant) {
    case "line":
      return { indicator: "line" };
    case "none":
      return { indicator: "none" };
    case "no-label":
      return { hideLabel: true };
    case "icons":
      return { icon: true };
    default:
      return {};
  }
}

// A small floating tooltip, built with safe DOM APIs (no innerHTML).
function chartTooltip(root, cfg = {}) {
  const el = document.createElement("div");
  el.className =
    "pointer-events-none absolute z-10 hidden min-w-[8rem] rounded-lg border " +
    "bg-background px-2.5 py-1.5 text-xs shadow-md";
  el.style.transform = "translate(-50%, calc(-100% - 8px))";
  const title = document.createElement("div");
  title.className = "mb-1 font-medium";
  if (cfg.hideLabel) title.style.display = "none";
  const row = document.createElement("div");
  row.className = "flex items-center justify-between gap-4";
  const left = document.createElement("div");
  left.className = "flex items-center gap-1.5 text-muted-foreground";
  const dot = document.createElement("span");
  dot.className =
    cfg.indicator === "line"
      ? "h-3 w-1 shrink-0 rounded-full"
      : cfg.icon
        ? "size-2.5 shrink-0 rounded-full"
        : "size-2.5 shrink-0 rounded-[2px]";
  if (cfg.indicator === "none") dot.style.display = "none";
  const name = document.createElement("span");
  const val = document.createElement("span");
  val.className = "font-mono font-medium tabular-nums text-foreground";
  left.append(dot, name);
  row.append(left, val);
  el.append(title, row);

  return {
    el,
    show(label, series, value, color, x, y) {
      title.textContent = label;
      dot.style.background = color;
      name.textContent = series;
      val.textContent = String(value);
      el.style.left = `${x}px`;
      el.style.top = `${y}px`;
      el.classList.remove("hidden");
    },
    hide() {
      el.classList.add("hidden");
    },
    // Map an SVG-coordinate point to a pixel position inside `root`.
    place(svg, vbW, vbH, sx, sy) {
      const sr = svg.getBoundingClientRect();
      const rr = root.getBoundingClientRect();
      return [
        (sx / vbW) * sr.width + (sr.left - rr.left),
        (sy / vbH) * sr.height + (sr.top - rr.top),
      ];
    },
  };
}

// ---- Path builders ----------------------------------------------------------

function linePath(pts, mode) {
  if (!pts.length) return "";
  if (mode === "step") {
    let d = `M ${pts[0][0]} ${pts[0][1]}`;
    for (let i = 1; i < pts.length; i++) {
      d += ` L ${pts[i][0]} ${pts[i - 1][1]} L ${pts[i][0]} ${pts[i][1]}`;
    }
    return d;
  }
  if (mode === "linear" || pts.length < 3) {
    return "M " + pts.map((p) => p.join(" ")).join(" L ");
  }
  // natural / monotone-ish cubic spline (Catmull-Rom -> bezier)
  let d = `M ${pts[0][0]} ${pts[0][1]}`;
  for (let i = 0; i < pts.length - 1; i++) {
    const p0 = pts[i - 1] || pts[i];
    const p1 = pts[i];
    const p2 = pts[i + 1];
    const p3 = pts[i + 2] || p2;
    const c1x = p1[0] + (p2[0] - p0[0]) / 6;
    const c1y = p1[1] + (p2[1] - p0[1]) / 6;
    const c2x = p2[0] - (p3[0] - p1[0]) / 6;
    const c2y = p2[1] - (p3[1] - p1[1]) / 6;
    d += ` C ${c1x} ${c1y} ${c2x} ${c2y} ${p2[0]} ${p2[1]}`;
  }
  return d;
}

function areaPath(pts, mode, baseY) {
  if (!pts.length) return "";
  return (
    linePath(pts, mode) +
    ` L ${pts[pts.length - 1][0]} ${baseY} L ${pts[0][0]} ${baseY} Z`
  );
}

// ---- Cartesian charts: bar, line, area --------------------------------------

function renderCartesian(type, data, keys, variant, tip) {
  const W = 600, H = 300, pad = 24;
  const innerH = H - pad * 2;
  const innerW = W - pad * 2;
  const dims = { W, H, pad, innerH, innerW };
  const svg = svgEl("svg", {
    viewBox: `0 0 ${W} ${H}`,
    preserveAspectRatio: "none",
    width: "100%",
    height: "100%",
    role: "img",
  });
  const series = keys.map((k) => data.map((r) => Number(r[k]) || 0));

  if (type === "bar") {
    renderBars(svg, data, series, keys, variant, dims, tip);
  } else {
    renderLines(svg, type, data, series, keys, variant, dims, tip);
  }
  return svg;
}

function axisLabels(svg, data, dims) {
  const { pad, innerW, H } = dims;
  data.forEach((d, i) => {
    const t = svgEl("text", {
      class: "chart-axis",
      x: pad + (innerW / Math.max(1, data.length)) * (i + 0.5),
      y: H - 4,
      "text-anchor": "middle",
      "font-size": "10",
    });
    t.textContent = String(d.label);
    svg.appendChild(t);
  });
}

function renderBars(svg, data, series, keys, variant, dims, tip) {
  const { W, H, pad, innerH, innerW } = dims;

  if (variant === "horizontal") {
    return renderHorizontalBars(svg, data, series[0], dims, tip);
  }

  const stacked = variant === "stacked";
  const grouped = variant === "multiple";
  const negative = variant === "negative";
  const mixed = variant === "mixed";
  const active = variant === "active";
  const showLabel = variant === "label" || variant === "custom-label";

  const all = series.flat();
  let maxV, minV = 0;
  if (stacked) {
    maxV = Math.max(1, ...data.map((_, i) => series.reduce((s, a) => s + a[i], 0)));
  } else {
    maxV = Math.max(1, ...all);
    if (negative) minV = Math.min(0, ...all);
  }
  const span = maxV - minV || 1;
  const yOf = (v) => pad + innerH - ((v - minV) / span) * innerH;
  const zeroY = yOf(0);

  // Zero baseline (negative variant draws an explicit axis through zero).
  svg.appendChild(
    svgEl("line", {
      class: "chart-grid",
      x1: pad,
      y1: zeroY,
      x2: W - pad,
      y2: zeroY,
      stroke: "currentColor",
      "stroke-width": "1",
    })
  );

  const slot = innerW / Math.max(1, data.length);
  const maxIdx = series[0].indexOf(Math.max(...series[0]));

  data.forEach((d, i) => {
    const nKeys = grouped ? keys.length : stacked ? keys.length : 1;
    const groupX = pad + i * slot;

    if (stacked) {
      let acc = 0;
      keys.forEach((k, s) => {
        const v = series[s][i];
        const y = yOf(acc + v);
        const h = yOf(acc) - y;
        acc += v;
        addBar(svg, groupX + slot * 0.15, y, slot * 0.7, h, chartColor(s), tip, d.label, humanize(k), v, dims);
      });
    } else if (grouped) {
      const bw = (slot * 0.7) / nKeys;
      keys.forEach((k, s) => {
        const v = series[s][i];
        const y = yOf(v);
        addBar(svg, groupX + slot * 0.15 + s * bw, y, bw * 0.9, zeroY - y, chartColor(s), tip, d.label, humanize(k), v, dims);
      });
    } else {
      const v = series[0][i];
      const y = yOf(v);
      const color = mixed ? chartColor(i) : chartColor(0);
      const bar = addBar(svg, groupX + slot * 0.15, Math.min(y, zeroY), slot * 0.7, Math.abs(zeroY - y), color, tip, d.label, humanize(keys[0]), v, dims);
      if (active && i !== maxIdx) bar.setAttribute("opacity", "0.35");
      if (showLabel) {
        const t = svgEl("text", {
          class: "chart-axis",
          x: groupX + slot / 2,
          y: (variant === "custom-label" ? zeroY - 6 : y - 6),
          "text-anchor": "middle",
          "font-size": "11",
        });
        t.textContent = String(v);
        svg.appendChild(t);
      }
    }
  });

  if (variant !== "custom-label") axisLabels(svg, data, dims);
}

function addBar(svg, x, y, w, h, color, tip, label, series, value, dims) {
  const bar = svgEl("rect", {
    class: "chart-bar",
    x,
    y,
    width: w,
    height: Math.max(0, h),
    rx: "4",
    fill: color,
  });
  bar.addEventListener("mouseenter", () => {
    const [px, py] = tip.place(svg, dims.W, dims.H, x + w / 2, y);
    tip.show(label, series, value, color, px, py);
  });
  bar.addEventListener("mouseleave", () => tip.hide());
  svg.appendChild(bar);
  return bar;
}

function renderHorizontalBars(svg, data, values, dims, tip) {
  const { W, H, pad, innerH, innerW } = dims;
  const max = Math.max(1, ...values);
  const slot = innerH / Math.max(1, data.length);
  values.forEach((v, i) => {
    const w = (v / max) * innerW;
    const y = pad + i * slot + slot * 0.15;
    const bar = svgEl("rect", {
      class: "chart-bar",
      x: pad,
      y,
      width: w,
      height: slot * 0.7,
      rx: "4",
      fill: chartColor(0),
    });
    bar.addEventListener("mouseenter", () => {
      const [px, py] = tip.place(svg, W, H, pad + w, y + slot * 0.35);
      tip.show(data[i].label, "Value", v, chartColor(0), px, py);
    });
    bar.addEventListener("mouseleave", () => tip.hide());
    svg.appendChild(bar);
    const t = svgEl("text", {
      class: "chart-axis",
      x: pad + 6,
      y: y + slot * 0.45,
      "text-anchor": "start",
      "dominant-baseline": "middle",
      "font-size": "10",
    });
    t.textContent = String(data[i].label);
    svg.appendChild(t);
  });
}

function renderLines(svg, type, data, series, keys, variant, dims, tip) {
  const { W, H, pad, innerH, innerW } = dims;
  const mode = variant === "linear" ? "linear" : variant === "step" ? "step" : "natural";
  const multiple = variant === "multiple" || keys.length > 1;
  const stacked = type === "area" && (variant === "stacked" || variant === "expanded");
  const expanded = variant === "expanded";
  const showDots = type === "line" && variant.startsWith("dots");
  const dotColors = variant === "dots-colors";
  const showLabel = variant === "label" || variant === "custom-label";
  const gradient = variant === "gradient";

  const xAt = (i) =>
    data.length > 1 ? pad + (innerW / (data.length - 1)) * i : pad + innerW / 2;

  // y scale
  let max;
  if (stacked && !expanded) {
    max = Math.max(1, ...data.map((_, i) => series.reduce((s, a) => s + a[i], 0)));
  } else {
    max = Math.max(1, ...series.flat());
  }
  const yAt = (v) => pad + innerH - (v / max) * innerH;

  // baseline
  svg.appendChild(
    svgEl("line", {
      class: "chart-grid",
      x1: pad,
      y1: pad + innerH,
      x2: W - pad,
      y2: pad + innerH,
      stroke: "currentColor",
      "stroke-width": "1",
    })
  );

  if (type === "area" && stacked) {
    // Cumulative stacked (optionally normalized to 100%).
    let lower = data.map(() => 0);
    keys.forEach((k, s) => {
      const upper = data.map((_, i) => {
        const total = expanded ? series.reduce((sum, a) => sum + a[i], 0) || 1 : 1;
        const scale = expanded ? innerH / 1 : 1;
        return lower[i] + (expanded ? (series[s][i] / total) * max : series[s][i]);
      });
      const topPts = upper.map((v, i) => [xAt(i), yAt(v)]);
      const botPts = lower.map((v, i) => [xAt(i), yAt(v)]);
      const d =
        linePath(topPts, mode) +
        " L " +
        botPts
          .slice()
          .reverse()
          .map((p) => p.join(" "))
          .join(" L ") +
        " Z";
      svg.appendChild(
        svgEl("path", { d, fill: chartColor(s), "fill-opacity": "0.4", stroke: chartColor(s), "stroke-width": "2" })
      );
      lower = upper;
    });
    axisLabels(svg, data, dims);
    return;
  }

  const seriesToDraw = multiple ? keys.map((_, s) => s) : [0];

  seriesToDraw.forEach((s) => {
    const color = chartColor(s);
    const pts = data.map((_, i) => [xAt(i), yAt(series[s][i])]);

    if (type === "area") {
      const gid = "g" + Math.random().toString(36).slice(2);
      const defs = svgEl("defs", {});
      const grad = svgEl("linearGradient", { id: gid, x1: "0", y1: "0", x2: "0", y2: "1" });
      grad.appendChild(svgEl("stop", { offset: "0%", "stop-color": color, "stop-opacity": gradient ? "0.8" : "0.4" }));
      if (gradient) grad.appendChild(svgEl("stop", { offset: "50%", "stop-color": color, "stop-opacity": "0.3" }));
      grad.appendChild(svgEl("stop", { offset: "95%", "stop-color": color, "stop-opacity": "0.05" }));
      defs.appendChild(grad);
      svg.appendChild(defs);
      svg.appendChild(svgEl("path", { class: "chart-area", d: areaPath(pts, mode, pad + innerH), fill: `url(#${gid})`, stroke: "none" }));
    }

    svg.appendChild(
      svgEl("path", {
        class: "chart-line",
        d: linePath(pts, mode),
        fill: "none",
        stroke: color,
        "stroke-width": "2",
        "stroke-linejoin": "round",
        "stroke-linecap": "round",
      })
    );

    if (showDots || type === "area") {
      // line "dots" variants render markers; plain area does not.
    }
    if (showDots) {
      pts.forEach((p, i) =>
        svg.appendChild(
          svgEl("circle", {
            cx: p[0],
            cy: p[1],
            r: dotColors ? "4" : "3.5",
            fill: dotColors ? chartColor(i) : "var(--background)",
            stroke: color,
            "stroke-width": "2",
          })
        )
      );
    }
    if (showLabel) {
      pts.forEach((p, i) => {
        const t = svgEl("text", {
          class: "chart-axis",
          x: p[0],
          y: p[1] - 8,
          "text-anchor": "middle",
          "font-size": "11",
        });
        t.textContent = String(series[s][i]);
        svg.appendChild(t);
      });
    }
  });

  // hover regions
  const slotW = innerW / Math.max(1, data.length);
  data.forEach((d, i) => {
    const v = series[0][i];
    const cx = xAt(i);
    const cy = yAt(v);
    const hit = svgEl("rect", { x: pad + i * slotW - slotW / 2, y: pad, width: slotW, height: innerH, fill: "transparent" });
    hit.addEventListener("mouseenter", () => {
      const [px, py] = tip.place(svg, W, H, cx, cy);
      tip.show(String(d.label), humanize(keys[0]), v, chartColor(0), px, py);
    });
    hit.addEventListener("mouseleave", () => tip.hide());
    svg.appendChild(hit);
  });

  axisLabels(svg, data, dims);
}

// ---- Polar charts: pie / donut, radar, radial -------------------------------

function polarSvg(size) {
  return svgEl("svg", {
    viewBox: `0 0 ${size} ${size}`,
    preserveAspectRatio: "xMidYMid meet",
    width: "100%",
    height: "100%",
    role: "img",
  });
}

function renderPie(data, keys, type, variant, tip) {
  const S = 300, cx = S / 2, cy = S / 2;
  const donut = type === "donut" || variant.startsWith("donut");
  const inner = donut ? 70 : 0;
  const key = keys[0];
  const total = data.reduce((s, d) => s + (Number(d[key]) || 0), 0) || 1;
  const svg = polarSvg(S);
  let a0 = -Math.PI / 2;
  const baseR = 120;

  data.forEach((d, i) => {
    const v = Number(d[key]) || 0;
    const frac = v / total;
    const a1 = a0 + frac * Math.PI * 2;
    const large = a1 - a0 > Math.PI ? 1 : 0;
    const color = chartColor(i);
    // "donut-active" / "stacked" pops the largest slice outward a touch.
    const r = (variant === "donut-active" || variant === "stacked") && v === Math.max(...data.map((x) => x[key])) ? baseR + 8 : baseR;
    const p = (rad, a) => `${cx + rad * Math.cos(a)} ${cy + rad * Math.sin(a)}`;
    const path = inner
      ? `M ${p(r, a0)} A ${r} ${r} 0 ${large} 1 ${p(r, a1)} L ${p(inner, a1)} A ${inner} ${inner} 0 ${large} 0 ${p(inner, a0)} Z`
      : `M ${cx} ${cy} L ${p(r, a0)} A ${r} ${r} 0 ${large} 1 ${p(r, a1)} Z`;
    const slice = svgEl("path", { d: path, fill: color, stroke: "var(--background)", "stroke-width": "2" });
    const mid = (a0 + a1) / 2;
    slice.addEventListener("mouseenter", () => {
      const mr = inner ? (r + inner) / 2 : r * 0.6;
      const [px, py] = tip.place(svg, S, S, cx + mr * Math.cos(mid), cy + mr * Math.sin(mid));
      tip.show(String(d.label), humanize(key), v, color, px, py);
    });
    slice.addEventListener("mouseleave", () => tip.hide());
    svg.appendChild(slice);

    if (variant === "label" || variant === "custom-label" || variant === "label-list") {
      const lr = inner ? (r + inner) / 2 : r * 0.62;
      const t = svgEl("text", {
        x: cx + lr * Math.cos(mid),
        y: cy + lr * Math.sin(mid),
        "text-anchor": "middle",
        "dominant-baseline": "middle",
        "font-size": "12",
        fill: "var(--background)",
        "font-weight": "600",
      });
      t.textContent = variant === "label-list" ? d.label : String(v);
      svg.appendChild(t);
    }
    a0 = a1;
  });

  if (donut && variant === "donut-text") {
    const big = svgEl("text", { x: cx, y: cy - 4, "text-anchor": "middle", "font-size": "30", "font-weight": "700", fill: "currentColor" });
    big.textContent = String(total);
    const sub = svgEl("text", { class: "chart-axis", x: cx, y: cy + 18, "text-anchor": "middle", "font-size": "12" });
    sub.textContent = "Visitors";
    svg.append(big, sub);
  }

  return svg;
}

function renderRadar(data, keys, variant, tip) {
  const S = 300, cx = S / 2, cy = S / 2, r = 100;
  const n = Math.max(1, data.length);
  const multiple = variant === "multiple" || keys.length > 1;
  const all = keys.flatMap((k) => data.map((d) => Number(d[k]) || 0));
  const max = Math.max(1, ...all);
  const angle = (i) => -Math.PI / 2 + (2 * Math.PI * i) / n;
  const svg = polarSvg(S);

  const noGrid = variant === "grid-none";
  const circleGrid = variant.startsWith("grid-circle");
  const noLines = variant === "grid-circle-no-lines";
  const filled = variant === "grid-filled" || variant === "grid-circle-filled";

  if (!noGrid) {
    for (let g = 1; g <= 3; g++) {
      const rr = (r * g) / 3;
      if (circleGrid) {
        svg.appendChild(
          svgEl("circle", {
            class: "chart-grid",
            cx,
            cy,
            r: rr,
            fill: g === 3 && filled ? "currentColor" : "none",
            "fill-opacity": filled ? "0.05" : "0",
            stroke: "currentColor",
            "stroke-width": "1",
          })
        );
      } else {
        const pts = data.map((_, i) => [cx + rr * Math.cos(angle(i)), cy + rr * Math.sin(angle(i))]);
        svg.appendChild(
          svgEl("polygon", {
            class: "chart-grid",
            points: pts.map((p) => p.join(",")).join(" "),
            fill: g === 3 && filled ? "currentColor" : "none",
            "fill-opacity": filled ? "0.05" : "0",
            stroke: "currentColor",
            "stroke-width": "1",
          })
        );
      }
    }
    if (!noLines) {
      data.forEach((_, i) => {
        svg.appendChild(
          svgEl("line", {
            class: "chart-grid",
            x1: cx,
            y1: cy,
            x2: cx + r * Math.cos(angle(i)),
            y2: cy + r * Math.sin(angle(i)),
            stroke: "currentColor",
            "stroke-width": "1",
          })
        );
      });
    }
  }

  data.forEach((d, i) => {
    const lx = cx + (r + 16) * Math.cos(angle(i));
    const ly = cy + (r + 16) * Math.sin(angle(i));
    const t = svgEl("text", {
      class: "chart-axis",
      x: lx,
      y: ly,
      "text-anchor": "middle",
      "dominant-baseline": "middle",
      "font-size": "10",
    });
    t.textContent = String(d.label);
    svg.appendChild(t);
  });

  const linesOnly = variant === "lines-only";
  const showDots = variant === "dots";
  const seriesIdx = multiple ? keys.map((_, s) => s) : [0];

  seriesIdx.forEach((s) => {
    const color = chartColor(s);
    const pts = data.map((d, i) => {
      const rr = r * ((Number(d[keys[s]]) || 0) / max);
      return [cx + rr * Math.cos(angle(i)), cy + rr * Math.sin(angle(i))];
    });
    svg.appendChild(
      svgEl("polygon", {
        points: pts.map((p) => p.join(",")).join(" "),
        fill: linesOnly ? "none" : color,
        "fill-opacity": linesOnly ? "0" : variant.includes("filled") ? "0.6" : "0.3",
        stroke: color,
        "stroke-width": "2",
      })
    );
    if (showDots || multiple) {
      pts.forEach((p, i) => {
        const dot = svgEl("circle", { cx: p[0], cy: p[1], r: "3.5", fill: color });
        dot.addEventListener("mouseenter", () => {
          const [px, py] = tip.place(svg, S, S, p[0], p[1]);
          tip.show(String(data[i].label), humanize(keys[s]), data[i][keys[s]], color, px, py);
        });
        dot.addEventListener("mouseleave", () => tip.hide());
        svg.appendChild(dot);
      });
    }
  });

  return svg;
}

function renderRadial(data, keys, variant, tip) {
  const S = 300, cx = S / 2, cy = S / 2;
  const key = keys[0];
  const max = Math.max(1, ...data.map((d) => Number(d[key]) || 0));
  const ringW = variant === "shape" ? 26 : 20;
  const gap = 6, outer = 120;
  const svg = polarSvg(S);
  const start = -Math.PI / 2;
  const cap = variant === "shape" ? "butt" : "round";

  const arc = (r, a1, color, width, capStyle) => {
    const x0 = cx + r * Math.cos(start);
    const y0 = cy + r * Math.sin(start);
    const x1 = cx + r * Math.cos(a1);
    const y1 = cy + r * Math.sin(a1);
    const large = a1 - start > Math.PI ? 1 : 0;
    return svgEl("path", {
      d: `M ${x0} ${y0} A ${r} ${r} 0 ${large} 1 ${x1} ${y1}`,
      fill: "none",
      stroke: color,
      "stroke-width": String(width),
      "stroke-linecap": capStyle,
    });
  };

  data.forEach((d, i) => {
    const r = outer - i * (ringW + gap);
    if (r < ringW) return;
    const color = chartColor(i);
    const v = Number(d[key]) || 0;
    const frac = Math.min(0.9999, v / max);
    svg.appendChild(arc(r, start + 2 * Math.PI * 0.9999, "var(--muted)", ringW, "round"));
    const bar = arc(r, start + 2 * Math.PI * frac, color, ringW, cap);
    bar.addEventListener("mouseenter", () => {
      const [px, py] = tip.place(svg, S, S, cx, cy - r);
      tip.show(String(d.label), humanize(key), v, color, px, py);
    });
    bar.addEventListener("mouseleave", () => tip.hide());
    svg.appendChild(bar);

    if (variant === "label") {
      const t = svgEl("text", { class: "chart-axis", x: cx + 6, y: cy - r, "dominant-baseline": "middle", "font-size": "10" });
      t.textContent = `${d.label}`;
      svg.appendChild(t);
    }
  });

  if (variant === "text") {
    const total = data.reduce((s, d) => s + (Number(d[key]) || 0), 0);
    const big = svgEl("text", { x: cx, y: cy - 4, "text-anchor": "middle", "font-size": "30", "font-weight": "700", fill: "currentColor" });
    big.textContent = String(total);
    const sub = svgEl("text", { class: "chart-axis", x: cx, y: cy + 18, "text-anchor": "middle", "font-size": "12" });
    sub.textContent = "Visitors";
    svg.append(big, sub);
  }

  return svg;
}

// ---- Toaster (built with safe DOM APIs) -------------------------------------

function setupToaster(root) {
  if (root.__shadcnBound) return;
  root.__shadcnBound = true;

  // Toasts slide from / leave toward the edge the toaster is anchored to.
  const fromTop = (root.getAttribute("data-position") || "bottom-right").startsWith("top");
  const inClass = fromTop ? "shadcn-toast-in-top" : "shadcn-toast-in";
  const outClass = fromTop ? "shadcn-toast-out-top" : "shadcn-toast-out";

  const dismiss = (el) => {
    if (el.__dismissing) return;
    el.__dismissing = true;
    el.classList.remove(inClass);
    el.classList.add(outClass);
    setTimeout(() => el.remove(), 200);
  };

  const add = (detail) => {
    const { title, description, variant, duration = 4000 } = detail || {};
    const destructive = variant === "destructive";
    const el = document.createElement("div");
    // Errors interrupt (assertive alert); everything else announces politely.
    el.setAttribute("role", destructive ? "alert" : "status");
    el.setAttribute("aria-live", destructive ? "assertive" : "polite");
    el.setAttribute("aria-atomic", "true");
    el.className =
      "pointer-events-auto relative flex w-full items-center justify-between gap-4 " +
      "overflow-hidden rounded-md border p-4 pr-10 shadow-lg bg-background text-foreground " +
      inClass +
      " " +
      (destructive ? "border-destructive bg-destructive text-white" : "");
    const stack = document.createElement("div");
    stack.className = "grid gap-1";
    if (title) {
      const t = document.createElement("div");
      t.className = "text-sm font-semibold";
      t.textContent = title; // safe
      stack.appendChild(t);
    }
    if (description) {
      const d = document.createElement("div");
      d.className = "text-sm opacity-90";
      d.textContent = description; // safe
      stack.appendChild(d);
    }
    el.appendChild(stack);

    // Keyboard-accessible close button (not just click-anywhere-to-dismiss).
    const closeBtn = document.createElement("button");
    closeBtn.type = "button";
    closeBtn.setAttribute("aria-label", "Close");
    closeBtn.className =
      "absolute top-1 right-1 rounded-md p-1 opacity-70 transition-opacity hover:opacity-100";
    closeBtn.textContent = "✕";
    closeBtn.addEventListener("click", (e) => {
      e.stopPropagation();
      dismiss(el);
    });
    el.appendChild(closeBtn);

    // Dismiss on click, or automatically after `duration`.
    el.addEventListener("click", () => dismiss(el));
    fromTop ? root.prepend(el) : root.appendChild(el);
    if (duration > 0) setTimeout(() => dismiss(el), duration);
  };

  window.addEventListener("shadcn:toast", (e) => add(e.detail));
}

/** Programmatically show a toast. */
export function toast(title, opts = {}) {
  window.dispatchEvent(new CustomEvent("shadcn:toast", { detail: { title, ...opts } }));
}

// ---- LiveView hooks ---------------------------------------------------------

export const Hooks = {
  ShadcnSelect: {
    mounted() {
      setupSelect(this.el);
    },
  },
  ShadcnCommand: {
    mounted() {
      setupCommand(this.el);
    },
  },
  ShadcnCombobox: {
    mounted() {
      setupCombobox(this.el);
    },
  },
  ShadcnInputOTP: {
    mounted() {
      setupInputOTP(this.el);
    },
  },
  ShadcnMenu: {
    mounted() {
      setupMenu(this.el);
    },
  },
  ShadcnTabs: {
    mounted() {
      setupTabs(this.el);
    },
  },
  ShadcnResizable: {
    mounted() {
      setupResizable(this.el);
    },
  },
  ShadcnChart: {
    mounted() {
      setupChart(this.el);
    },
    updated() {
      setupChart(this.el);
    },
  },
  ShadcnToaster: {
    mounted() {
      setupToaster(this.el);
      this.handleEvent("shadcn:toast", (payload) =>
        window.dispatchEvent(new CustomEvent("shadcn:toast", { detail: payload }))
      );
    },
  },
};

// ---- Standalone initializer (no LiveView) -----------------------------------

export function initShadcn(root = document) {
  qa(root, '[data-slot="select"]').forEach(setupSelect);
  qa(root, '[data-slot="command"]').forEach(setupCommand);
  qa(root, '[data-slot="combobox"]').forEach(setupCombobox);
  qa(root, '[data-slot="input-otp"]').forEach(setupInputOTP);
  qa(root, '[role="menu"][data-state]').forEach(setupMenu);
  qa(root, '[data-slot="tabs"]').forEach(setupTabs);
  qa(root, '[data-slot="resizable-panel-group"]').forEach(setupResizable);
  qa(root, '[data-slot="chart"]').forEach(setupChart);
  qa(root, '[data-slot="toaster"]').forEach(setupToaster);
}

export default Hooks;
