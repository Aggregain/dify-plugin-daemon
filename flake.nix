{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    # flake-utils replacement
    supportedSystems = ["x86_64-linux"];
    overlaysFor = system: [];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (
        system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = overlaysFor system;
            };
            inherit system;
          }
      );
  in {
    devShells = forEachSupportedSystem ({
      pkgs,
      system,
    }: {
      default = with pkgs;
        mkShell {
          buildInputs = [
            # go deps
            go_1_23
            gopls
          ];
        };
    });
  };
}
