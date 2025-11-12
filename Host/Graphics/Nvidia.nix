{ config, pkgs, lib, ... }:

{
options = {
    Nvidia.enable =
      lib.mkEnableOption "enables Nvidia";
    };

   config = lib.mkIf config.Nvidia.enable {

  nixpkgs.config.allowUnfree = true;
  # X11 with current settings works so far the best with 144Hz on external and internal and can change brightness, no gestures for gnome(meh)
  # sudo systemctl restart display-manager -> restart to apply changes; !!!All apps would close
  # For now not laggy when intel enabled
  boot.kernelParams = [ "i915.modeset=1" ];
  #   "nouveau.modeset=0" "nvidia.NVreg_EnableGpuFirmware=0"
  hardware.graphics = {
    enable = true;
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

  # Does not work
  # Disable Nvidia power management services for suspen/hibernate issues
  # services.nvidia-suspend.enable = false;
  # services.nvidia-hibernate.enable = false;
  # services.nvidia-resume.enable = false;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    dynamicBoost.enable = true;

    prime = {
      sync.enable = true;
      intelBusId = "PCI:00:02:0";
      nvidiaBusId = "PCI:01:00:0";
    };
  };
};
}
