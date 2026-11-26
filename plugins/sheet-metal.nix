# ./plugins/sheet-metal.nix
{ fetchFromGitHub }:
fetchFromGitHub {
  owner = "shaise";
  repo = "FreeCAD_SheetMetal";
  # Pinned to the commit upstream's moving "Last" tag pointed to;
  # .github/workflows/update-plugins.yml opens a PR when the tag moves.
  # upstream-tag: Last
  rev = "6c40458ddf880bfa16ff4fec7c05bf53709afcb3";
  hash = "sha256-WZJ3Au6y4RNkvG2/ZqBlWW56Sq2OD7yiFucO8M2x7f0=";
}
