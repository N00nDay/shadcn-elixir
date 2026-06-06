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
