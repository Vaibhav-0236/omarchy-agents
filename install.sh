#!/usr/bin/env bash
# omarchy-agents installer
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="${HOME}/.local/bin"
PLUGINS_DIR="${HOME}/.config/omarchy/plugins"
TARGET_DIR="${PLUGINS_DIR}/omarchy-agents"

echo "==> Installing omarchy-agents..."

# 1. Install collector script
mkdir -p "$BIN_DIR"
cp "$SCRIPT_DIR/bin/omarchy-agent-usage-gemini" "$BIN_DIR/omarchy-agent-usage-gemini"
chmod +x "$BIN_DIR/omarchy-agent-usage-gemini"
echo "✓ Installed collector to $BIN_DIR/omarchy-agent-usage-gemini"

# 2. Check ~/.local/bin in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo "⚠️  Notice: $BIN_DIR is not in your PATH. Consider adding it to your shell configuration."
fi

# 3. Install plugin files into Omarchy plugins directory
mkdir -p "$PLUGINS_DIR"
if [[ "$SCRIPT_DIR" != "$TARGET_DIR" ]]; then
  rm -rf "$TARGET_DIR"
  mkdir -p "$TARGET_DIR"
  cp -r "$SCRIPT_DIR/manifest.json" "$SCRIPT_DIR/Agent.qml" "$SCRIPT_DIR/Main.qml" "$SCRIPT_DIR/Panel.qml" "$SCRIPT_DIR/assets" "$SCRIPT_DIR/bin" "$TARGET_DIR/"
  echo "✓ Installed plugin files to $TARGET_DIR"
fi

# 4. Validate plugin
if command -v omarchy >/dev/null 2>&1; then
  echo "==> Validating plugin..."
  omarchy plugin validate "$TARGET_DIR"
  
  # Rescan plugins in omarchy-shell
  if command -v omarchy-shell >/dev/null 2>&1; then
    omarchy-shell shell rescanPlugins >/dev/null 2>&1 || true
  fi
  
  echo ""
  echo "🎉 omarchy-agents successfully installed!"
  echo ""
  echo "To enable it in your status bar, run:"
  echo "  omarchy plugin enable omarchy-agents"
  echo ""
  echo "Or customize placement in ~/.config/omarchy/shell.json."
else
  echo "✓ Plugin files placed in $TARGET_DIR"
fi
