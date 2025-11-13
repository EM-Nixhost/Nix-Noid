{ config, pkgs, lib, ... }:

{
options = {
    Extra-Launchers.enable =
      lib.mkEnableOption "enables Extra-Launchers";
    };
   config = lib.mkIf config.Extra-Launchers.enable {

    };

    environment.systemPackages = with pkgs; [
      # Baseline Launchers
      heroic
      prismlauncher
      # Piracy
      hydralauncher
      lutris
    ];
  };
}
