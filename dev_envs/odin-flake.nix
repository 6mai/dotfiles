{
  description = "Odinlang dev flake";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.x86_64-linux.default =
        pkgs.mkShell
          {
            nativeBuildInputs = with pkgs; [
              pkgs.odin
              pkgs.ols
            ];

            odin = "${pkgs.odin}";
            libs = "${pkgs.odin}/share/";
            core = "${pkgs.odin}/share/core";
            vendor = "${pkgs.odin}/share/vendor";
          };
    };
}
