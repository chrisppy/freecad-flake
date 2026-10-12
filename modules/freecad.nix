# ./modules/freecad.nix
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkIf
    ;
  cfg = config.programs.freecad;

  # Relative path to our upstream plugins directory
  pluginsDirPath = ../plugins;

  # 1. Read files in our internal plugins folder
  pluginFolderContents = builtins.readDir pluginsDirPath;

  # 2. Filter out anything that isn't a '.nix' file layout
  pluginNixFiles = lib.filterAttrs (
    name: type: (type == "regular" || type == "symlink") && (lib.hasSuffix ".nix" name)
  ) pluginFolderContents;

  # 3. Clean names (e.g., "sheet-metal.nix" -> "sheet-metal")
  pluginNames = map (name: lib.removeSuffix ".nix" name) (builtins.attrNames pluginNixFiles);

  # 4. Programmatically callPackage on each file to produce an attrset of derivations
  # Result shape: { fasteners = <pkg>; history = <pkg>; "sheet-metal" = <pkg>; }
  availablePlugins = lib.genAttrs pluginNames (
    name: pkgs.callPackage (pluginsDirPath + "/${name}.nix") { }
  );
in
{
  options.programs.freecad = {
    enable = mkEnableOption "customized FreeCAD installation wrapper";

    # Dynamic boolean toggles generated automatically based on upstream plugin files!
    plugins = lib.genAttrs pluginNames (
      name:
      mkOption {
        type = types.bool;
        default = false;
        description = "Enable the custom upstream ${name} workbench plugin.";
      }
    );

    # Configuration Drops (XML templates)
    userCfg = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to a baseline user.cfg XML template file injected via the launcher wrapper.";
    };
    systemCfg = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to a global system.cfg XML template file injected via the launcher wrapper.";
    };

    # Escape Hatch Parameters
    pythons = mkOption {
      type = types.listOf types.unspecified;
      default = null;
      description = "Python extensions package mappings.";
    };
    makeWrapperFlags = mkOption {
      type = types.listOf types.str;
      default = null;
    };

    package = mkOption {
      type = types.package;
      readOnly = true;
      description = "The resulting customized FreeCAD package derivation.";
    };
  };

  config = mkIf cfg.enable {
    programs.freecad.package =
      let
        # Filter our availablePlugins map to find which options the user flagged 'true'
        selectedPlugins = lib.filterAttrs (name: _value: cfg.plugins.${name}) availablePlugins;
        enabledPluginPackages = builtins.attrValues selectedPlugins;
      in
      pkgs.freecad.customize {
        name = "freecad-custom";
        inherit (cfg) pythons;
        inherit (cfg) makeWrapperFlags;
        inherit (cfg) userCfg;
        inherit (cfg) systemCfg;

        # Merge manual items with programmatically enabled upstream plugin hashes
        modules = enabledPluginPackages;
      };

    # Inject package directly into the standard profile path tracking arrays
    environment.systemPackages = [ cfg.package ];
  };
}
