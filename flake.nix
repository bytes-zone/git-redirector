{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import inputs.nixpkgs { inherit system; };
      in rec {
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

        # for debugging, if needed
        # packages.container = pkgs.dockerTools.buildLayeredImage {
        packages.container = pkgs.dockerTools.streamLayeredImage {
          name = "ghcr.io/bytes-zone/git-redirector";

          # make /var/log/nginx so Nginx doesn't fail trying to open it (which
          # it does no matter what you say in log settings, apparently.)
          extraCommands = ''
            mkdir -p tmp/nginx_client_body
            mkdir -p var/log/nginx
          '';

          contents = [
            pkgs.fakeNss
            pkgs.nginxMainline
            packages.config

            # for debugging, if needed
            # pkgs.dockerTools.binSh
            # pkgs.coreutils
          ];

          config = {
            "ExposedPorts"."80/tcp" = { };
            Entrypoint = [ "nginx" ];
            Cmd = [ "-c" "/etc/nginx/nginx.conf" ];

            # for debugging, if needed
            # Entrypoint = "/bin/sh";
          };
        };
      }
    );
}
