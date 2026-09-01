#!/bin/bash

# Stop the script if any command fails
set -e

echo "========================================="
echo "   Installing Chad's Arch/Hyprland Rice  "
echo "========================================="

# 1. Update the system
echo "-> Updating system..."
sudo pacman -Syu --noconfirm

# 2. Install standard Arch packages
echo "-> Installing core packages from standard repositories..."
sudo pacman -S --needed --noconfirm \
    hyprland \
    kitty \
    yazi \
    wofi \
    waybar \
    mako \
    firefox \
    network-manager-applet \
    blueman \
    wireplumber \
    playerctl \
    brightnessctl \
    ttf-jetbrains-mono-nerd \
    noto-fonts-emoji \
    git \
    base-devel \
    awww

# 3. Install AUR Helper (yay)
if ! command -v yay &> /dev/null; then
    echo "-> Installing 'yay' (AUR helper)..."
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin
    makepkg -si --noconfirm
    cd - > /dev/null
    rm -rf /tmp/yay-bin
else
    echo "-> 'yay' is already installed."
fi

# 4. Install AUR packages
echo "-> Installing AUR packages..."
yay -S --needed --noconfirm hyprcap

# 5. Deploy configurations
echo "-> Copying dotfiles to ~/.config..."
mkdir -p ~/.config

# This checks if you moved the folders into a .config directory as advised, 
# or if they are still sitting in the root of your my-rice folder.
if [ -d ".config/hypr" ]; then
    cp -r .config/* ~/.config/
else
    for dir in hypr kitty mako waybar wofi; do
        if [ -d "$dir" ]; then
            cp -r "$dir" ~/.config/
        fi
    done
fi

# 6. Deploy wallpaper
echo "-> Setting up wallpaper..."
mkdir -p ~/Pictures/Wallpapers
if [ -f "wp6600403.jpg" ]; then
    cp wp6600403.jpg ~/Pictures/Wallpapers/
    echo "   Wallpaper copied to ~/Pictures/Wallpapers/"
fi

# 7. Enable background services
echo "-> Enabling necessary system services..."
sudo systemctl enable --now NetworkManager.service
sudo systemctl enable --now bluetooth.service

echo "========================================="
echo "   Installation Complete!                "
echo "   You can now reboot or start Hyprland. "
echo "========================================="
