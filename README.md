# mermaid-cli-playwright-flake

Packaging-only Nix flake for `jplana/mermaid-cli-playwright` (the upstream source is fetched from GitHub and pinned in `flake.lock`).

Upstream project: https://github.com/jplana/mermaid-cli-playwright

## Use

- Run `mmdc`: `nix run . -- -i input.mmd -o output.svg`
- Build package: `nix build .`
- Show help: `nix run . -- -h`

## Update upstream

- Update the pinned upstream revision: `nix flake update --update-input mermaid-src`
- If the upstream `package-lock.json` changes, update `npmDepsHash` in `nix/package.nix` (Nix will tell you the expected hash).

## Use from another flake

Add this flake as an input and reference `packages.<system>.default` (or `packages.<system>.mermaid-cli-playwright`).
