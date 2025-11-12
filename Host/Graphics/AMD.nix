# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
options = {
    AMD.enable =
      lib.mkEnableOption "enables AMD";
    };

   config = lib.mkIf config.AMD.enable {

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    services.xserver.videoDrivers = ["amdgpu"];

    # Note: If this is an AMD module, you likely meant 'hardware.amdgpu' options
    # or you should remove any 'hardware.nvidia' settings.
    # Assuming you meant to *keep* this specific setting:
    hardware.nvidia.modesetting.enable = true;
  };
}
