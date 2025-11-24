{ config, pkgs, lib, ... }:

{
  options.VM.enable = lib.mkEnableOption "Enable Virt-Manager and KVM virtualization";

  config = lib.mkIf config.VM.enable {

    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    programs.dconf.enable = true;
  };
}
