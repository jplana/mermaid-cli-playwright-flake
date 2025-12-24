{
  lib,
  buildNpmPackage,
  makeWrapper,
  nodejs,
  playwright,
  playwright-driver,
  upstreamSrc,
}:

buildNpmPackage rec {
  pname = "mermaid-cli-playwright";
  version = "11.12.0";

  src = upstreamSrc;

  npmBuildScript = "prepack";
  npmFlags = [ "--include=dev" ];

  npmDepsHash = "sha256-jNWlp2Jntndij8VJ1BFXYfNghnWOoWU+SAWfBxW+8Rg=";

  nativeBuildInputs = [
    makeWrapper
  ];

  env.PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  postPatch = ''
    substituteInPlace src/index.js \
      --replace-fail "from 'playwright'" "from 'playwright-core'" \
      --replace-fail "import('playwright')" "import('playwright-core')" \
      --replace-fail "import(\"playwright\")" "import(\"playwright-core\")"
    substituteInPlace src-test/test.js \
      --replace-fail "from 'playwright'" "from 'playwright-core'"
  '';

  postInstall = ''
    rm -rf "$out/lib/node_modules/${pname}/node_modules/playwright" \
      "$out/lib/node_modules/${pname}/node_modules/playwright-core"
    rm -f "$out/lib/node_modules/${pname}/node_modules/.bin/playwright" \
      "$out/lib/node_modules/${pname}/node_modules/.bin/playwright-core"
    ln -s ${playwright} "$out/lib/node_modules/${pname}/node_modules/playwright-core"

    wrapProgram "$out/bin/mmdc" \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]} \
      --set-default PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers} \
      --set-default PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD 1 \
      --set-default PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS 1
  '';

  meta = {
    description = "Command-line interface for mermaid, rendered via Playwright (Chromium/Firefox/WebKit)";
    homepage = "https://github.com/jplana/mermaid-cli-playwright";
    license = lib.licenses.mit;
    mainProgram = "mmdc";
    platforms = lib.platforms.unix;
  };
}
