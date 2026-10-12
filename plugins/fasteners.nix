# ./plugins/fasteners.nix
{ fetchFromGitHub }:
fetchFromGitHub {
  owner = "shaise";
  repo = "FreeCAD_FastenersWB";
  rev = "last";
  hash = "sha256-mYg8M1APYtleQVgnVvGtpRQ/z90RvGK2v+FkHEBFfj0=";
}
