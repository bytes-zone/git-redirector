{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import inputs.nixpkgs { inherit system; };
      in {
        formatter = pkgs.nixpkgs-fmt;

        devShell = pkgs.mkShell { packages = [ ]; };

        packages.config = pkgs.stdenv.mkDerivation {
          name = "generator";
          src = ./src;

          nativeBuildInputs = [ pkgs.python3 ];

          buildPhase = ''
            python3 nginx_config.py sources.txt > nginx.conf
          '';

          installPhase = ''
            mkdir -p $out/etc/nginx
            mv nginx.conf $out/etc/nginx
          '';
        };
      }
    );
}
