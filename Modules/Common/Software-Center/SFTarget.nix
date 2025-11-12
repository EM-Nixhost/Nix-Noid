{ config, pkgs, lib, ... }:

# This file defines the options for the Snowfall Software Center
# and configures it.

with lib;
let
  # This 'bootstrapPkgs' logic is correct and prevents infinite recursion.
  bootstrapPkgs = import <nixpkgs> {};

  nsc-source = bootstrapPkgs.fetchFromGitHub {
    owner = "snowfallorg";
    repo = "nix-software-center";
    rev = "0.1.2";
    sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
  };
in
{
  # --- THE FIX ---
  # The module file for this version is located at 'nix/module.nix'
  # inside the source repository.
  imports = [
    "${nsc-source}/nix/module.nix"
  ];
  # ---------------

  # 1. Define the option to enable the Snowfall module globally
  options.Snowfall.enable = mkEnableOption "Enable Snowfall Org's Nix Software Center";

  # 2. Define the option to receive the path to the user's private application file
  options.Snowfall.privateConfigPath = mkOption {
    type = types.nullOr types.path;
    default = null;
    description = "The path to the user's private Applications.nix file to be targeted by the Software Center.";
  };

  # 3. Configure Snowfall only if enabled
  config = mkIf config.Snowfall.enable {

    # This 'pkgs' is the correct, final, module-argument pkgs
    # (which now contains nix-software-center thanks to the Snowfall.nix file)
    environment.systemPackages = with pkgs; [
      nix-software-center
      adwaita-icon-theme
      adwaita-icon-theme-legacy
    ];

    # This option now exists thanks to the 'imports' block above
    programs.nix-software-center = {
      enable = true;

      # Set the target file to the user's private path if provided by Host/Host.nix
      targetFile =
        if config.Snowfall.privateConfigPath != null
        then config.Snowfall.privateConfigPath
        else null; # If null, let Snowfall use its default behavior
    };
  };
}
