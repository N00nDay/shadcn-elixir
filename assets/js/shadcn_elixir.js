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
};

// ---- Standalone initializer (no LiveView) -----------------------------------

export function initShadcn(root = document) {
  qa(root, '[data-slot="select"]').forEach(setupSelect);
  qa(root, '[data-slot="command"]').forEach(setupCommand);
  qa(root, '[data-slot="combobox"]').forEach(setupCombobox);
}

export default Hooks;
