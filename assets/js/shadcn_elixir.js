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

// ---- Resizable --------------------------------------------------------------

function setupResizable(root) {
  if (root.__shadcnBound) return;
  root.__shadcnBound = true;

  const vertical = root.dataset.direction === "vertical";
  qa(root, '[data-part="handle"]').forEach((handle) => {
    handle.addEventListener("pointerdown", (e) => {
      e.preventDefault();
      const prev = handle.previousElementSibling;
      const next = handle.nextElementSibling;
      if (!prev || !next) return;
      const startPos = vertical ? e.clientY : e.clientX;
      const prevSize = vertical ? prev.offsetHeight : prev.offsetWidth;
      const nextSize = vertical ? next.offsetHeight : next.offsetWidth;
      const total = prevSize + nextSize;

      const onMove = (ev) => {
        const delta = (vertical ? ev.clientY : ev.clientX) - startPos;
        const newPrev = Math.max(0, Math.min(total, prevSize + delta));
        prev.style.flex = `${newPrev} 1 0%`;
        next.style.flex = `${total - newPrev} 1 0%`;
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

function setupChart(root) {
  const type = root.dataset.chartType || "bar";
  let data = [];
  try {
    data = JSON.parse(root.dataset.chart || "[]");
  } catch (_e) {
    data = [];
  }
  const W = 600, H = 300, pad = 24;
  const max = Math.max(1, ...data.map((d) => Number(d.value) || 0));
  const innerH = H - pad * 2;
  const innerW = W - pad * 2;
  const color = "var(--color-chart-1, var(--chart-1))";

  const svg = svgEl("svg", {
    viewBox: `0 0 ${W} ${H}`,
    preserveAspectRatio: "none",
    width: "100%",
    height: "100%",
    role: "img",
  });
  const grid = svgEl("line", {
    class: "chart-grid",
    x1: pad,
    y1: pad + innerH,
    x2: W - pad,
    y2: pad + innerH,
    stroke: "currentColor",
    "stroke-width": "1",
  });
  svg.appendChild(grid);

  if (type === "line") {
    const step = data.length > 1 ? innerW / (data.length - 1) : 0;
    const pts = data.map((d, i) => {
      const x = pad + i * step;
      const y = pad + innerH - ((Number(d.value) || 0) / max) * innerH;
      return [x, y];
    });
    svg.appendChild(
      svgEl("polyline", {
        class: "chart-line",
        fill: "none",
        stroke: color,
        "stroke-width": "2",
        points: pts.map((p) => p.join(",")).join(" "),
      })
    );
    pts.forEach(([x, y]) =>
      svg.appendChild(svgEl("circle", { cx: x, cy: y, r: "3", fill: color }))
    );
  } else {
    const slot = innerW / Math.max(1, data.length);
    const bw = slot * 0.7;
    data.forEach((d, i) => {
      const h = ((Number(d.value) || 0) / max) * innerH;
      svg.appendChild(
        svgEl("rect", {
          class: "chart-bar",
          x: pad + i * slot + slot * 0.15,
          y: pad + innerH - h,
          width: bw,
          height: h,
          rx: "4",
          fill: color,
        })
      );
    });
  }

  data.forEach((d, i) => {
    const text = svgEl("text", {
      class: "chart-axis",
      x: pad + (innerW / Math.max(1, data.length)) * (i + 0.5),
      y: H - 4,
      "text-anchor": "middle",
      "font-size": "10",
    });
    text.textContent = String(d.label); // safe: no HTML parsing
    svg.appendChild(text);
  });

  root.replaceChildren(svg);
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
    const el = document.createElement("div");
    el.setAttribute("role", "status");
    el.className =
      "pointer-events-auto relative flex w-full items-center justify-between gap-4 " +
      "overflow-hidden rounded-md border p-4 shadow-lg bg-background text-foreground " +
      inClass +
      " " +
      (variant === "destructive" ? "border-destructive bg-destructive text-white" : "");
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
  qa(root, '[data-slot="resizable-panel-group"]').forEach(setupResizable);
  qa(root, '[data-slot="chart"]').forEach(setupChart);
  qa(root, '[data-slot="toaster"]').forEach(setupToaster);
}

export default Hooks;
