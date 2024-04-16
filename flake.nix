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

          installPhase = ''
            mkdir -p $out/etc/nginx

            python3 nginx_config.py sources.txt > $out/etc/nginx/nginx.conf
          '';
        };
      }
    );
}
