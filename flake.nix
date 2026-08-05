{
  description = "NixOS, nix-darwin and home-manager common configuration modules";

  nixConfig = {
    extra-substituters = ["https://nvf.cachix.org/"];
    extra-trusted-public-keys = ["nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="];
  };

  inputs = {
    # flake helpers
    flake-parts.url = "github:hercules-ci/flake-parts/main";

    # nixpkgs
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";

    # NixOS modules
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugin-registry = {
      url = "github:AvengeMedia/dms-plugin-registry/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin modules
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager modules
    stylix = {
      url = "github:danth/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Supporting repos
    tt-schemes = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };
    paperwmspoon = {
      url = "github:mogenson/PaperWM.spoon";
      flake = false;
    };
    hammerspoons = {
      url = "github:Hammerspoon/Spoons";
      flake = false;
    };
    dms-plugin-musiclyrics = {
      url = "github:jeslinmx/dms-plugin-musiclyrics";
      flake = false;
    };
  };

  outputs = {
    flake-parts,
    nvf,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({
      self,
      lib,
      ...
    }: {
      imports = [./flake-module.nix];

      detect = {
        extraArgs = {inherit (self) inputs darwinModules homeModules nixosModules nvfModules;};
        configurations.enable = false;
      };

      flake = {
        flakeModule = import ./flake-module.nix;
        lib = import ./lib.nix lib;
      };

      systems = ["x86_64-linux" "aarch64-darwin"];
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
        packages = let
          nvfConf = nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [self.nvfModules.default];
          };
        in {inherit (nvfConf) neovim;};
      };
    });
}
