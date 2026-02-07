#!/bin/bash

set -e          # Exit immediately if a command fails
set -u          # Treat unset variables as errors
set -o pipefail # Prevent errors in a pipeline from being masked

INSTALL_DIR="$HOME/.config/hypr/hyprquick"

print() {
    local type="$1"
    local text="$2"

    case "$type" in
        SKIP)     code="30" ;;
        ERROR)     code="31" ;;
        DONE)   code="32" ;;
        WARN)  code="33" ;;
        INFO)    code="34" ;;
        *) code="0" ;;
    esac

    printf "\e[%sm[%s]\e[0m %s\n" "$code" "$type" "$text"
}

print "WARN" "This will permanently delete hyprquick."
read -p "Are you sure you want to continue? [y/N] " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    print "DONE" "Keeping existing installation. Aborting."
    exit 1
fi

# TODO: cleanly uninstall hyprquick
