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

  # Plugins are the tack pins in the `plugins` group of ../.tack/pins.toml.
  # Pins are fetched lazily, so only enabled plugins are downloaded.
  pins = import ../.tack;
  pluginNames = builtins.attrNames (
    lib.filterAttrs (_name: meta: meta.group or null == "plugins") pins._meta
  );

  # Result shape: { fasteners = <source>; history = <source>; "sheet-metal" = <source>; }
  availablePlugins = lib.genAttrs pluginNames (name: pins.${name});
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
