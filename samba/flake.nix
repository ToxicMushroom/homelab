# Credits to https://code.m3ta.dev/m3tam3re/nixos-generators/src/branch/master/flake.nix
# And to https://github.com/Vuks69/nixos-config/blob/master/modules/services/samba.nix
{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixos-generators,
    ...
  } @ inputs: {
    nixosConfigurations = {
      beverburcht = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
        ];
        specialArgs = {
          isImageTarget = false;
        };
      };
    };
    packages.x86_64-linux = {
      proxmox = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
        specialArgs = {
           isImageTarget = true;
        };
        format = "proxmox";
      };
      qcow = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
        specialArgs = {
           isImageTarget = true;
        };
        format = "qcow";
      };
    };
  };
}
