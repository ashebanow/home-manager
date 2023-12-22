{
  description = "ashebanow's way-too-complicated nix configuration";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org/"
    ];

    extra-substituters = [
      "https://cattivi-public.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cattivi-public.cachix.org-1:qQQ8FHPoEibPtL1FTZTmVbUL78KW2zCRk+LZPsRiwQ4="
    ];
  };

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix = {
    #   url = "github:Mic92/sops-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, ... }:
    let
      linuxArmSystem = "aarch64-linux";
      darwinSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";

      darwinPkgs = nixpkgs.legacyPackages.${darwinSystem};
      linuxPkgs = nixpkgs.legacyPackages.${linuxSystem};
    in
    {
      nix.registry.nixpkgs.flake = inputs.nixpkgs;

      nixosConfigurations = {
        shebanix = nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          specialArgs = { inherit inputs; }; # forward inputs to modules
          modules = [
            ./hosts/shebanix/configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.verbose = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ashebanow = import ./hosts/linux-default/home.nix;
            }
          ];
        };
        virt1 = nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          specialArgs = { inherit inputs; }; # forward inputs to modules
          modules = [
            ./hosts/virt1/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.verbose = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ashebanow = import ./hosts/linux-default/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
        virt2 = nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          specialArgs = { inherit inputs; }; # forward inputs to modules
          modules = [
            ./hosts/virt2/configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.verbose = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ashebanow = import ./hosts/linux-default/home.nix;
            }
          ];
        };
      };

      darwinConfigurations = {
        miraclemax = darwin.lib.darwinSystem {
          system = darwinSystem;
          specialArgs = { inherit inputs; }; # forward inputs to modules
          modules = [
            ./hosts/darwin-default/configuration.nix
            home-manager.darwinModules.home-manager {
              home-manager.verbose = true;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ashebanow = import ./hosts/darwin-default/home.nix;
            }
            # sops-nix.nixosModules.sops
          ];
        };
      };

      homeConfigurations = {
        home-manager.verbose = true;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        ashebanow = home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;
          modules = [
            ./hosts/linux-default/home.nix
          ];
        };
        ubuntu-desktop = home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;
          modules = [
            ./hosts/ubuntu-desktop/home.nix
          ];
        };
      };
    };
}
