_: {pkgs, ...}: {
  vim = {
    lsp.servers.commit-lsp = {
      cmd = ["commit-lsp" "run"];
      filetypes = ["gitcommit"];
    };
    extraPackages = [
      (pkgs.rustPlatform.buildRustPackage
        {
          pname = "commit-lsp";
          version = "0.2.1";
          src = pkgs.fetchFromGitHub {
            owner = "texel-sensei";
            repo = "commit-lsp";
            rev = "v0.2.1";
            hash = "sha256-AuBojf0NGcKos7J2ACbl0LLKXsfaLbGoSvAifZPysi4=";
          };
          cargoHash = "sha256-u2Ts1az7+31jv8jKsSKmhxyhu5adLIe3WUjTzgZTMh0=";
          nativeBuildInputs = [pkgs.pkg-config];
          buildInputs =
            [pkgs.openssl]
            # ++ lib.optionals pkgs.stdenv.isDarwin [
            #   pkgs.darwin.apple_sdk.frameworks.Security
            #   pkgs.libiconv
            # ]
            ;
        })
    ];
  };
}
