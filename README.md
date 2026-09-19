# Omarchy Agents Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Omarchy%20Linux%20%7C%20Hyprland-brightgreen.svg)](https://omarchy.org/)

A native [Omarchy](https://omarchy.org/) status bar widget and panel for tracking AI coding agent token consumption, rate limits, model breakdowns, and usage pace in real time.

Built for **Claude Code** and **Gemini / Antigravity CLI**, with support for Codex and Fireworks.

---

## ✨ Features

- **Google Gemini & Antigravity Support**: Automatic token consumption tracking and rate-limit windowing parsed from local `~/.gemini/antigravity-cli` session transcripts and history.
- **Claude Code Support**: Live tracking of 5-hour session quotas, 7-day weekly limits, prompt counts, and local transcript statistics.
- **Visual Rate Limits**: Progress meters showing percentage consumed and precise countdown timers to quota resets.
- **Token Breakdown by Model**: Inspect input tokens, generated output tokens, and cache hits across models (e.g. *Gemini 3.8 Flash*, *Claude 3.7 Sonnet*).
- **Daily Usage History**: 7-day timeline of token burn rates, session counts, and prompts.
- **Native Omarchy Look & Feel**: Beautiful Quickshell UI styled with your active Omarchy theme colors, fonts, and blur.
- **Self-Hiding & Always-Show Modes**: Hides gracefully when no subscriptions have recorded data, or stays pinned with `alwaysShow: true`.

---

## 🚀 Installation

### Option 1: Via Omarchy CLI (Recommended)

Add and enable the plugin directly using Omarchy's built-in plugin manager:

```bash
omarchy plugin add https://github.com/Vaibhav-0236/omarchy-agents.git --enable
```

To install the Gemini collector binary to `~/.local/bin/` as well:
```bash
~/.config/omarchy/plugins/omarchy-agents/install.sh
```

### Option 2: Clone & One-Click Install

```bash
git clone https://github.com/Vaibhav-0236/omarchy-agents.git
cd omarchy-agents
./install.sh
```

The installer will:
1. Copy the `omarchy-agent-usage-gemini` collector to `~/.local/bin/` (ensuring it's executable).
2. Install the plugin files into `~/.config/omarchy/plugins/omarchy-agents`.
3. Validate the manifest against the Omarchy schema and rescan running shell plugins.

---

## ⚙️ Configuration

### Adding to your Status Bar

If not enabled during install, enable the widget with:

```bash
omarchy plugin enable omarchy-agents
```

Or add `"omarchy-agents"` directly to your bar layout in `~/.config/omarchy/shell.json`:

```json
{
  "bar": {
    "layout": {
      "right": [
        {
          "id": "omarchy-agents",
          "alwaysShow": true,
          "providers": {
            "gemini": { "enabled": true },
            "claude": { "enabled": true },
            "codex": { "enabled": false },
            "fireworks": { "enabled": false }
          }
        }
      ]
    }
  }
}
```

*Changes to `shell.json` hot-reload automatically on save.*

### Plugin Settings

| Setting | Default | Description |
|---|---|---|
| `alwaysShow` | `true` | Keeps the icon visible on the bar even before active tokens are recorded today. |
| `refreshIntervalSec` | `900` (15m) | How often usage records and rate limits refresh. |
| `providers` | `gemini`, `claude` | Configure per-agent enablement (`enabled: true/false`). |
| `syncMode` | `"Off"` | Synchronize and aggregate token usage across multiple machines. |

Change settings quickly from the terminal:
```bash
# Refresh every 5 minutes (300 seconds)
omarchy bar set omarchy-agents refreshIntervalSec 300 --json

# Set enabled providers
omarchy bar set omarchy-agents providers '{
  "gemini": { "enabled": true },
  "claude": { "enabled": true }
}' --json
```

---

## ⌨️ Shortcuts & Interactions

- **Left Click**: Open / close the agent stats panel.
- **Middle Click**: Cycle to the next enabled AI agent tab.
- **Right Click**: Launch your active coding agent in terminal.
- **Inside the Panel**:
  - `h` / `l` or **Arrow Keys**: Switch between agent tabs.
  - `j` / `k` or **Scroll**: Scroll through tokens and history.
  - `r` or `Enter`: Force an immediate stats refresh.
  - `Esc`: Close the panel.

---

## 🏗️ Architecture & How It Works

The Omarchy Agents architecture separates display from telemetry collection:

```
~/.gemini/antigravity-cli/ ──┐
                             ├──>  bin/omarchy-agent-usage-gemini  ──>  ~/.local/state/omarchy/agents/usage/gemini.json
~/.claude/ ──────────────────┘                                            │
                                                                           ▼
                                                                  Main.qml (Quickshell)
                                                                           │
                                                                           ▼
                                                                  Panel.qml (Status Bar & Popup)
```

1. **Collectors (`bin/`)**:
   - `omarchy-agent-usage-gemini`: A standalone Python script that reads local Antigravity transcript logs, calculates character-to-token conversions, determines active model tags, computes hourly/weekly quota windows, and writes standard JSON records.
   - Claude and other agents utilize their native Omarchy collectors (`omarchy-agent-usage-claude`).
2. **State Directory**:
   Records are cached in `~/.local/state/omarchy/agents/usage/<agent>.json`.
3. **Quickshell UI (`Main.qml` & `Panel.qml`)**:
   Watches the JSON records on disk. When changed or refreshed, it updates the visual fuel gauges, model lists, and charts instantly without blocking the compositor.

---

## 🤝 Contributing

Contributions are warmly welcome! If you'd like to add collectors for other agents or enhance the UI:

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/awesome-agent`.
3. Verify your changes pass validation: `omarchy plugin validate .`.
4. Submit a Pull Request.

---

## 📄 License

Distributed under the [MIT License](LICENSE). Copyright (c) 2026 Vaibhav Ojha.
