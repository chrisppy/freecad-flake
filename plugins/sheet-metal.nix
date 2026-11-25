# ./plugins/sheet-metal.nix
{ fetchFromGitHub }:
fetchFromGitHub {
  owner = "shaise";
  repo = "FreeCAD_SheetMetal";
  # Upstream moves the "Last" tag on every release; pin the commit it pointed to.
  rev = "71bce0002b051d8a6c87e11fffd50c600ef9af49";
  hash = "sha256-9G/KbUl2iKmqnwStQhaJpuWqkP4jquZ/KvT7+VOu3bs=";
}
