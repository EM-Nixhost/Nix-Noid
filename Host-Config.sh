#!/usr/bin/env bash

# This script generates the local Host/Host.nix and User application files
# based on your specific template.
# It MUST be run with sudo, e.g.: sudo bash Host-Config.sh

set -e

# --- Configuration ---
# Ensure the script is run from the correct directory (/etc/nixos)
cd /etc/nixos

HOST_DIR="Host"
HOST_FILE="$HOST_DIR/Host.nix"
USER_DIR_BASE="Users"

# --- 1. Get User Input (Robust Loop) ---
echo "--- NixOS Host Setup ---"

HOSTNAME=""
while [ -z "$HOSTNAME" ]; do
    read -p "Enter the desired HOSTNAME for this machine: " HOSTNAME
done

USERNAME=""
while [ -z "$USERNAME" ]; do
    read -p "Enter the primary USERNAME for this machine: " USERNAME
done

# Confirm variables
echo "------------------------------------------------"
echo "CONFIRMATION:"
echo "Hostname: '$HOSTNAME'"
echo "Username: '$USERNAME'"
echo "------------------------------------------------"
read -p "Is this correct? (y/n) " -n 1 -r
echo    # move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborted by user."
    exit 1
fi

# --- 2. Define Paths ---
USER_DIR="$USER_DIR_BASE/$USERNAME"
USER_APP_FILE="$USER_DIR/Applications.nix"
SYMLINK_PATH="/home/$USERNAME/Applications.nix"

# --- 3. Move Hardware Configuration ---
# Create Host directory if it doesn't exist
sudo mkdir -p "$HOST_DIR"

HARDWARE_FILE="hardware-configuration.nix"
NEW_HARDWARE_PATH="$HOST_DIR/$HARDWARE_FILE"

if [ -f "$HARDWARE_FILE" ]; then
    echo "Moving $HARDWARE_FILE to $NEW_HARDWARE_PATH..."
    sudo mv "$HARDWARE_FILE" "$NEW_HARDWARE_PATH"
elif [ -f "$NEW_HARDWARE_PATH" ]; then
    echo "$HARDWARE_FILE is already in the Host directory."
else
    echo "Warning: $HARDWARE_FILE not found in /etc/nixos."
fi

# --- 4. Create Host.nix (Using Your Exact Template) ---
echo "Generating $HOST_FILE..."

# We use \${} to prevent shell expansion for Nix variables,
# but allow $USERNAME and $HOSTNAME to expand.
sudo tee "$HOST_FILE" > /dev/null <<EOF
{ config, pkgs, lib, ... }:

let
  primaryUser = "$USERNAME";
  privatePackagePath = ../Users/\${primaryUser}/Applications.nix;

  isNvidia = builtins.pathExists "/proc/driver/nvidia/version";
  isAmd = !isNvidia;

  isKDE = true;
  isGnome = !isKDE;

in
{
  networking.hostName = "$HOSTNAME";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";

  users.users.\${primaryUser} = {
    isNormalUser = true;
    description = "\${primaryUser}'s Account";
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" ];
  };

  imports =
   [
      ./hardware-configuration.nix
      ./Unstable.nix
      ../Users/\${primaryUser}/Applications.nix
    ]
    # These conditional imports are appended
    ++ (lib.optional isKDE ./Desktop-Enviroment/KDE.nix)
    ++ (lib.optional isGnome ./Desktop-Enviroment/Gnome.nix)
    ++ (lib.optional isAmd ./Graphics/AMD.nix)
    ++ (lib.optional isNvidia ./Graphics/Nvidia.nix);

}
EOF

# --- 5. Create User Application File ---
echo "Creating user directory: $USER_DIR"
sudo mkdir -p "$USER_DIR"

echo "Creating applications file: $USER_APP_FILE"
sudo tee "$USER_APP_FILE" > /dev/null <<EOF
{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    # Add packages here
  ];
}
EOF

# --- 6. Set Permissions and Create Symlink ---
echo "Setting permissions..."
# Ensure the home directory exists (crucial for new installs)
sudo mkdir -p "/home/$USERNAME"

sudo chown -R "$USERNAME:users" "$USER_DIR_BASE"
sudo chown "$USERNAME:users" "$HOST_FILE"
# Also ensure the user owns their own home folder if we just created it
sudo chown "$USERNAME:users" "/home/$USERNAME"

echo "Creating symlink at $SYMLINK_PATH..."
sudo ln -sf "/etc/nixos/$USER_APP_FILE" "$SYMLINK_PATH"
sudo chown -h "$USERNAME:users" "$SYMLINK_PATH"

echo "---"
echo "Setup Complete."
echo "1. Hardware configuration moved to Host/."
echo "2. Host.nix generated."
echo "3. User applications file created and symlinked."
echo "Run 'sudo nixos-rebuild switch' to apply."
