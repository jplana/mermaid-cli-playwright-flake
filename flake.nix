{
  description = "mermaid-cli-playwright packaged as a Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mermaid-src = {
      url = "github:jplana/mermaid-cli-playwright";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, flake-utils, mermaid-src, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        mermaid-cli-playwright = pkgs.callPackage ./nix/package.nix { upstreamSrc = mermaid-src; };
      in
      {
        packages = {
          inherit mermaid-cli-playwright;
          default = mermaid-cli-playwright;
        };

        apps.default = flake-utils.lib.mkApp {
          drv = mermaid-cli-playwright;
          exePath = "/bin/mmdc";
        };
      }
    );
}
