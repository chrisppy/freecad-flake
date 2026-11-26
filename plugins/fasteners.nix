# ./plugins/fasteners.nix
{ fetchFromGitHub }:
fetchFromGitHub {
  owner = "shaise";
  repo = "FreeCAD_FastenersWB";
  # Pinned to the commit upstream's moving "last" tag pointed to;
  # .github/workflows/update-plugins.yml opens a PR when the tag moves.
  # upstream-tag: last
  rev = "f4eb7bb028b96a7235751fe91771f71f9024e94e";
  hash = "sha256-j/AyL+dgYUy3pa0Hw8dKns/htLk6AAmY3Q8Hh7qryz4=";
}
