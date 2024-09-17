{
  description = "CrazyEgg K8s traffic plug fork";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ parts, ... }:
    parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        { self', pkgs, ... }:
        let
          beamPackages = pkgs.beam_minimal.packages.erlang_27;
          elixir = beamPackages.elixir_1_17;
        in
        {
          devShells = {
            default = self'.devShells.develop;
            develop = pkgs.mkShell {
              packages = [ elixir ];
              env = {
                ERL_AFLAGS = "+pc unicode -kernel shell_history enabled";
                ELIXIR_ERL_OPTIONS = "+fnu +sssdio 128";
              };
            };
          };
        };
    };
}
