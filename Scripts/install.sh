#!/bin/bash

set -e          # Exit immediately if a command fails
set -u          # Treat unset variables as errors
set -o pipefail # Prevent errors in a pipeline from being masked

REPO_URL="https://github.com/Gael-Lopes-Da-Silva/hyprquick.git"
INSTALL_DIR="$HOME/.config/quickshell/hyprquick"
PACKAGES=(
    quickshell            # Widget framework

    brightnessctl         # Monitor brightness info
    cliphist              # Clipboard history manager
    wl-clipboard          # Wayland clipboard support
    ddcutil               # Monitor utils
    gpu-screen-recorder   # Screen recorder
    hypridle              # Idle event daemon
    hyprlock              # Screen locking
    hyprpicker            # Color picker
    hyprshot              # Screenshot utils
    hyprsunset            # Blue light filter
    libnotify             # Notification library
    playerctl             # Music player daemon
    upower                # Battery informations utils
    power-profiles-daemon # Power profiles
    imagemagick           # Image utility tools
    tesseract             # OCR utils
    udiskie               # Auto mount usb
)

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

# Prevent running the script as root
if [ "$(id -u)" -eq 0 ]; then
    print "ERROR" "Please do not run this script as root."
    exit 1
fi

# Clone or update the repository
if [ -d "$INSTALL_DIR" ]; then
    print "INFO" "Updating hyprquick..."
    git -C "$INSTALL_DIR" pull
else
    print "INFO" "Cloning hyprquick..."
    git clone --depth=1 "$REPO_URL" "$INSTALL_DIR"
fi

# Install required packages using the detected AUR helper
print "INFO" "Installing required packages..."
sudo pacman -Syy --needed --devel --noconfirm "${PACKAGES[@]}" || true
print "INFO" "Required packages installed."

print "INFO" "Starting hyprquick..."
# eww daemon 2>/dev/null || true
print "INFO" "Hyprquick started."
disown

print "DONE" "Installation complete."
