#!/usr/bin/env bash

# If not running inside a terminal, relaunch this script in Konsole.
if [[ ! -t 1 ]]; then
    KONSOLE="$(command -v konsole)"

    if [[ -z "$KONSOLE" ]]; then
        kdialog --error "Konsole is not installed."
        exit 1
    fi

    exec "$KONSOLE" --hold -e /bin/bash "$0" "$@"
fi

PROTON_ROOT="$HOME/.local/share/Steam/steamapps/common"

clear

if [[ ! -d "$PROTON_ROOT" ]]; then
    echo "Steam Proton directory not found."
    read -rp "Press Enter to exit..."
    exit 1
fi

found=0

for proton in "$PROTON_ROOT"/*/proton; do
    [[ -x "$proton" ]] || continue

    folder="$(basename "$(dirname "$proton")")"

    echo "--proton=\"$folder\""

    found=1
done

if (( ! found )); then
    echo "No installed Proton builds found."
fi
