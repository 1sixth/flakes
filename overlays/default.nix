{ inputs }:

{
  hyprland = final: prev: {
    inherit (inputs.hyprland-contrib.packages.${prev.system}) grimblast;

    hyprland = prev.hyprland.override {
      nvidiaPatches = true;
    };

    waybar = prev.waybar.overrideAttrs (old: {
      postPatch = ''
        sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
      '';
      postFixup = ''
       wrapProgram $out/bin/waybar \
         --suffix PATH : ${inputs.nixpkgs.lib.makeBinPath [ final.hyprland ]}
      '';
      mesonFlags = old.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  };
}
