{
  description = "A flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };

        androidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ "34.0.0" "35.0.0" "36.0.0" ];
          platformVersions = [ "34" "35" "36" ];
          abiVersions = [ "x86_64" "arm64-v8a" ];
          includeNDK = true;
          ndkVersions = [ "28.2.13676358" ];
          cmakeVersions = [ "3.22.1" ];
          includeEmulator = false;
          includeSources = false;
          includeSystemImages = false;
        };
        androidSdk = androidComposition.androidsdk;
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bun
            flutter
            supabase-cli
            jdk17
            androidSdk

            typst
            tinymist
            typstyle
          ];
          buildInputs = [ pkgs.bashInteractive ];
          shellHook = ''
            export ANDROID_HOME="${androidSdk}/libexec/android-sdk"
            export ANDROID_SDK_ROOT="${androidSdk}/libexec/android-sdk"
            export ANDROID_NDK_ROOT="${androidSdk}/libexec/android-sdk/ndk/28.2.13676358"
            export JAVA_HOME="${pkgs.jdk17.home}"
          '';
        };
      }
    );
}
