{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "pure-zsh-${version}";
  version = "2017-03-04";

  src = fetchFromGitHub {
    owner = "bkase";
    repo = "pure";
    rev = "fdae02de51d940db59004ac93c24530cdb972376";
    sha256 = "1wp30lsqyz17swxhml2ryn7kx32kf8r1fcc244cwchzi77bwjv6c";
  };

  installPhase = ''
    cp -R . $out
  '';
}
