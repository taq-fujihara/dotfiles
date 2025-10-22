#!/usr/bin/env bash

set -euo pipefail

echo "====================================="
echo "🔄 Changing default shell to fish..."
echo "====================================="

BREW_FISH_PATH="$(brew --prefix)/bin/fish"

# Make sure fish exists
if [ ! -x "$BREW_FISH_PATH" ]; then
    echo "❌ fish not found at $BREW_FISH_PATH"
    exit 1
fi

# Ensure fish path is in /etc/shells
if ! grep -qxF "$BREW_FISH_PATH" /etc/shells; then
    echo "Adding $BREW_FISH_PATH to /etc/shells..."
    echo "$BREW_FISH_PATH" | sudo tee -a /etc/shells > /dev/null
else
    echo "✅ $BREW_FISH_PATH already present in /etc/shells"
fi

# Change user’s login shell if not already set
if [ "$SHELL" != "$BREW_FISH_PATH" ]; then
    echo "Changing default shell to $BREW_FISH_PATH for user $USER..."
    sudo usermod --shell "$BREW_FISH_PATH" "$USER"
    echo "✅ Default shell set to fish"
else
    echo "✅ Default shell already set to $BREW_FISH_PATH"
fi
