#!/usr/bin/env bash

# Open in Konsole when double-clicked.
if [[ ! -t 1 ]]; then
    KONSOLE="$(command -v konsole)"

    if [[ -z "$KONSOLE" ]]; then
        kdialog --error "Konsole is not installed."
        exit 1
    fi

    exec "$KONSOLE" --hold -e /bin/bash "$0" "$@"
fi

RUNTIME_ROOT="$HOME/.local/share/com.epicgames.eglv2/compat/runtime"
MARKER="# EPIC-PROTON-SELECTOR-STUB"

clear

echo "======================================"
echo "       EPIC PROTON SELECTOR"
echo "              UNINSTALL"
echo "======================================"
echo

shopt -s nullglob
backups=("$RUNTIME_ROOT"/*/proton.epic)
shopt -u nullglob

if ((${#backups[@]} == 0)); then
    echo "No Epic Proton backup found."
    echo "Nothing to uninstall."
    exit 1
fi

if ((${#backups[@]} > 1)); then
    echo "Multiple Epic Proton backups found."
    echo "Cannot safely determine which one to restore."
    exit 1
fi

backup="${backups[0]}"
proton="${backup%.epic}"

if [[ ! -f "$proton" ]]; then
    echo "Current Proton stub is missing:"
    echo "$proton"
    exit 1
fi

if ! grep -Fqx "$MARKER" "$proton"; then
    echo "Unrecognized Proton file."
    echo "Nothing has been changed."
    exit 1
fi

temp="${proton}.selector-temp"

if [[ -e "$temp" ]]; then
    echo "Temporary file already exists:"
    echo "$temp"
    echo "Cannot safely continue."
    exit 1
fi

echo "Restoring Epic's original Proton..."
echo

if ! mv -- "$proton" "$temp"; then
    echo "Could not move the selector stub."
    exit 1
fi

if mv -- "$backup" "$proton"; then
    rm -f -- "$temp"
    chmod +x "$proton"
    echo "Successfully restored Epic's original Proton!"
else
    mv -- "$temp" "$proton"
    echo "Restoration failed."
    echo "Selector stub has been restored."
    exit 1
fi

echo
echo "Uninstallation complete."
