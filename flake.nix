{
  description = "NixOS, nix-darwin and home-manager common configuration modules";

  nixConfig.extra-substituters = [
    "https://nvf.cachix.org/"
  ];

  inputs = {
    # flake helpers
    flake-parts.url = "github:hercules-ci/flake-parts";

    # nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "nixpkgs/nixpkgs-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

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
      url = "github:AvengeMedia/dms-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin modules
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager modules
    stylix = {
      url = "github:danth/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
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
    flake-parts.lib.mkFlake {inherit inputs;} ({self, ...}: {
      flake = let
        inherit (self.lib) gatherModules;
      in {
        lib = import ./lib.nix inputs;

        darwinModules = gatherModules self ./modules/darwin;
        nixosModules = gatherModules self ./modules/nixos;
        homeModules = gatherModules self ./modules/home-manager;
        nvfModules = gatherModules self ./modules/nvf;
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
