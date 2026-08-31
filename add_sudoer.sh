#!/bin/bash

set -e

# Måste köras som root
if [ "$EUID" -ne 0 ]; then
    echo "Detta script måste köras som root."
    echo
    echo "Kör:"
    echo "  su -"
    echo "  ./$(basename "$0")"
    exit 1
fi

# Hitta den vanliga användaren
TARGET_USER="${SUDO_USER:-}"

if [ -z "$TARGET_USER" ] || [ "$TARGET_USER" = "root" ]; then
    read -rp "Ange användarnamn som ska få sudo: " TARGET_USER
fi

# Kontrollera att användaren finns
if ! id "$TARGET_USER" >/dev/null 2>&1; then
    echo "FEL: användaren '$TARGET_USER' finns inte."
    exit 1
fi

echo "Användare: $TARGET_USER"

# Installera sudo om det saknas
if ! command -v sudo >/dev/null 2>&1; then
    echo "sudo saknas. Installerar..."
    apt update
    apt install -y sudo
else
    echo "sudo är redan installerat."
fi

# Lägg användaren i sudo-gruppen
if id -nG "$TARGET_USER" | tr ' ' '\n' | grep -qx sudo; then
    echo "Användaren är redan medlem i sudo-gruppen."
else
    echo "Lägger till $TARGET_USER i sudo-gruppen..."
    usermod -aG sudo "$TARGET_USER"
fi

echo
echo "===== KLART ====="
echo
echo "Användare:"
id "$TARGET_USER"

echo
echo "Logga ut och logga in igen för att sudo-gruppen ska aktiveras."
