{
  description = "Yuko's Nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      nix-darwin,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        specialArgs = {
          user = {
            name = "hh2333";
            home = "/Users/hh2333";
          };

        };

        modules = [
          ./configs/darwin.nix
          home-manager.darwinModules.home-manager
        ];
      };

      # This configuration is specific to the Apple Silicon Mac. Keep these
      # outputs Darwin-only, while allowing platform-independent outputs below.
      packages.aarch64-darwin.default = self.darwinConfigurations.default.system;

      apps.aarch64-darwin.darwin-rebuild = {
        type = "app";
        program = "${nix-darwin.packages.aarch64-darwin.darwin-rebuild}/bin/darwin-rebuild";
        meta.description = "Run the nix-darwin rebuild tool pinned by flake.lock";
      };

      # Keep `nix fmt` available on every declared development platform.
      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
    };
}
