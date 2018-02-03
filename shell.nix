{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, array, async, attoparsec, base
      , blaze-builder, bytestring, case-insensitive, conduit
      , conduit-extra, containers, data-default, directory, filepath
      , fsnotify, hspec, http-client, http-conduit, http-reverse-proxy
      , http-types, HUnit, lifted-base, mtl, network, process, random
      , regex-tdfa, stdenv, stm, tar, template-haskell, text, time, tls
      , transformers, unix, unix-compat, unordered-containers, vector
      , wai, wai-app-static, wai-extra, warp, warp-tls, yaml, zlib
      }:
      mkDerivation {
        pname = "keter";
        version = "1.4.3.2";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          aeson array async attoparsec base blaze-builder bytestring
          case-insensitive conduit conduit-extra containers data-default
          directory filepath fsnotify http-client http-conduit
          http-reverse-proxy http-types lifted-base mtl network process
          random regex-tdfa stm tar template-haskell text time tls
          transformers unix unix-compat unordered-containers vector wai
          wai-app-static wai-extra warp warp-tls yaml zlib
        ];
        executableHaskellDepends = [ base data-default filepath ];
        testHaskellDepends = [
          base bytestring conduit hspec HUnit transformers unix
        ];
        homepage = "http://www.yesodweb.com/";
        description = "Web application deployment manager, focusing on Haskell web frameworks";
        license = stdenv.lib.licenses.mit;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
