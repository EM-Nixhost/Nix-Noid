{ config, pkgs, lib, ... }:
{
    # Enable X server (needed for XWayland compatibility)
    services.xserver.enable = true;

    # --- KDE Plasma 6 Desktop Environment (Uses KWin as its Wayland compositor) ---
    services.desktopManager.plasma6.enable = true;

    # Enable SDDM display manager
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    # --- Hyprland Wayland Compositor (Provided as a separate session) ---
    programs.hyprland.enable = true;

    # NOTE: The custom session block for i3 is removed as Hyprland is a standalone
    # Wayland compositor and cannot be layered onto KDE like i3 was on X11.

    # Environment packages
    environment.systemPackages = with pkgs; [
      kdePackages.dolphin-plugins
      kdePackages.ffmpegthumbs
      vlc
      gparted
      icoutils
      # Hyprland companion packages
      waybar # Status bar for Wayland (Recommended replacement for Plasma taskbar)
      wofi   # Application launcher for Wayland (dmenu replacement)
      libnotify # Useful for desktop notifications in Hyprland
      # Explicitly adding KRunner, the Plasma search and command utility.
      kdePackages.krunner
      kdePackages.kio-admin
    ];
    environment.plasma6.excludePackages = with pkgs; [
      kdePackages.kdepim-runtime
      kdePackages.kmahjongg
      kdePackages.kmines
      kdePackages.konversation
      kdePackages.kpat
      kdePackages.ksudoku
    ];

    # Configure keymap
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  }
