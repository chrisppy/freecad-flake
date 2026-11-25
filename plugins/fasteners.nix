# ./plugins/fasteners.nix
{ fetchFromGitHub }:
fetchFromGitHub {
  owner = "shaise";
  repo = "FreeCAD_FastenersWB";
  rev = "last";
  hash = "sha256-j/AyL+dgYUy3pa0Hw8dKns/htLk6AAmY3Q8Hh7qryz4=";
}
