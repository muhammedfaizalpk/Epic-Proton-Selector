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

die() {
    echo "ERROR: $*" >&2
    exit 1
}

find_runtime() {
    local -a files=()
    local file

    shopt -s nullglob
    for file in "$RUNTIME_ROOT"/*/proton; do
        [[ -f "$file" && -x "$file" ]] && files+=("$file")
    done
    shopt -u nullglob

    ((${#files[@]} == 1)) ||
        die "Expected exactly one Epic Proton runtime; found ${#files[@]}."

    printf '%s\n' "${files[0]}"
}

write_stub() {
    local destination="$1"
    local temp

    temp="$(mktemp "${destination}.tmp.XXXXXX")"

    cat > "$temp" <<'STUB'
#!/bin/bash
# EPIC-PROTON-SELECTOR-STUB

PROTON_ROOT="$HOME/.local/share/Steam/steamapps/common"
EPIC_PROTON="$(dirname "$0")/proton.epic"

SELECTED="$EPIC_PROTON"
ARGS=()

while (($#)); do
    arg="$1"
    shift

    case "$arg" in
        --proton=*)
            name="${arg#--proton=}"
            candidate="$PROTON_ROOT/$name/proton"

            if [ -x "$candidate" ]; then
                SELECTED="$candidate"
            else
                echo "Proton not found: $candidate" >&2
            fi
            ;;

        *)
            ARGS+=("$arg")
            ;;
    esac
done

exec "$SELECTED" "${ARGS[@]}"
STUB

    chmod 755 "$temp"
    mv -f -- "$temp" "$destination"
}

install_selector() {
    local proton backup

    proton="$(find_runtime)"
    backup="${proton}.epic"

    if [[ -f "$backup" ]]; then
        if grep -Fqx "$MARKER" "$proton" 2>/dev/null; then
            echo "Proton selector is already installed."
            return
        fi

        die "proton.epic already exists. Refusing to overwrite."
    fi

    echo "Installing Proton selector..."
    echo "Runtime: $(dirname "$proton")"
    echo

    mv -- "$proton" "$backup"

    if ! write_stub "$proton"; then
        rm -f -- "$proton"
        mv -- "$backup" "$proton"
        die "Installation failed. Original Proton restored."
    fi

    echo "Installation successful!"
    echo "Original Proton backed up as proton.epic."
}

install_selector
echo
