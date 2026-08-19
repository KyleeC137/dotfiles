#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Caio's Sway environment installer ==="
echo

# Arch check
if ! command -v pacman >/dev/null 2>&1; then
    echo "ERROR: This installer requires Arch Linux."
    exit 1
fi

# Required files
REQUIRED_FILES=(
    "$DOTFILES/sway-config"
    "$DOTFILES/waybar-config"
    "$DOTFILES/waybar-style.css"
    "$DOTFILES/packages/common.txt"
    "$DOTFILES/wallpapers/q.jpg"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo "ERROR: Missing file:"
        echo "  $file"
        exit 1
    fi
done

echo "Choose machine type:"
echo
echo "1) Common Sway setup"
echo "2) NVIDIA desktop"
echo

read -rp "Choice [1-2]: " choice

case "$choice" in
    1)
        ;;
    2)
        ;;
    *)
        echo "Invalid choice."
        exit 1
        ;;
esac

echo
echo "Installing common packages..."

sudo pacman -S --needed - < "$DOTFILES/packages/common.txt"

if [[ "$choice" == "2" ]]; then
    echo
    echo "Installing NVIDIA packages..."

    sudo pacman -S --needed - < "$DOTFILES/packages/nvidia.txt"
fi

echo
echo "Creating directories..."

mkdir -p "$HOME/.config/sway"
mkdir -p "$HOME/.config/waybar"
mkdir -p "$HOME/Pictures/Wallpapers"

echo "Installing wallpaper..."

ln -sfn \
    "$DOTFILES/wallpapers/q.jpg" \
    "$HOME/Pictures/Wallpapers/q.jpg"

echo "Installing Sway configuration..."

rm -f "$HOME/.config/sway/config"

sed \
    "s|@WALLPAPER@|$HOME/Pictures/Wallpapers/q.jpg|g" \
    "$DOTFILES/sway-config" \
    > "$HOME/.config/sway/config"

echo "Installing Waybar configuration..."

ln -sfn \
    "$DOTFILES/waybar-config" \
    "$HOME/.config/waybar/config"

ln -sfn \
    "$DOTFILES/waybar-style.css" \
    "$HOME/.config/waybar/style.css"

echo
echo "======================================"
echo " Installation complete!"
echo "======================================"
echo
echo "Installed:"
echo "  Sway"
echo "  Waybar"
echo "  Sway utilities"
echo "  Applications"
echo "  Wallpaper"
echo
echo "Restart Sway or log out and back in."
