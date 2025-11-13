{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./Common/Snowfall.nix
      ./Common/Wine.nix
      ./Common/Winboat.nix
      ./Common/Garbage-Collection.nix
    ];

}
