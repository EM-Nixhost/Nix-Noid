{ config, pkgs, lib, ... }:

{
options = {
    Nvidia.enable =
      lib.mkEnableOption "enables Nvidia";
    };

   config = lib.mkIf config.Nvidia.enable {

  nixpkgs.config.allowUnfree = true;
  boot.kernelParams = [ "i915.modeset=1" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libvdpau
      vaapiVdpau
      libva
      vulkan-loader
      vulkan-validation-layers
      nvidia-vaapi-driver
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    dynamicBoost.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:01:00:0";
    };
  };
};
}
