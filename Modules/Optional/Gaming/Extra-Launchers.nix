{ config, pkgs, lib, ... }:

{
options = {
    Extra-Launchers.enable =
      lib.mkEnableOption "enables Extra-Launchers";
    };

   config = lib.mkIf config.Extra-Launchers.enable {
    programs.steam.enable = true;
    programs.steam.gamescopeSession.enable = true;

    programs.gamemode.enable = true;

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS =
        "\${HOME}/.steam/root/compatibilitytools.d";
    };

    environment.systemPackages = with pkgs; [
      # System Req's
      wineWowPackages.waylandFull
      protonup
      protonup-qt
      # Baseline Launchers
      heroic
      prismlauncher
      # Piracy
      hydralauncher
      lutris
    ];
  };
}
