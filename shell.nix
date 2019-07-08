let
  pkgs = import <nixpkgs> {};

  easy-ps = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";

    # at this git revision:
    rev = "80e6c66c7b5cffefeb823ebebf156d2d7acd3285";

    # this sha can be obtained by using
    # nix-prefetch-git https://github.com/justinwoo/easy-purescript-nix --rev 828e34277dfd77507324d47f3a5e84afa81183c4
    # (without --rev for latest master)
    sha256 = "0npvnr3h4vnq6ibwi9gvxgijyjnwmmyvqglq471wkkn6b4ygry9v";
  });
in pkgs.stdenv.mkDerivation {
  name = "purescript-halogen-pure";
  src = ./.;
  buildInputs = with pkgs; with nodePackages; with easy-ps; [
    purs
    nodejs-10_x
    bower
    pulp
  ];
}
