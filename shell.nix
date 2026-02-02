# shell.nix (The Anti-gravity Bridge)
{ pkgs ? import <nixpkgs> {} }:
let
  # Import your unmodified dev.nix
  devNix = import ./dev.nix { inherit pkgs; };
  
  # Helper to extract the onCreate command
  onCreateScript = devNix.idx.workspace.onCreate or {};
  
  # Helper to construct the preview command
  previewCmd = devNix.idx.previews.previews.web.command or [];
in
pkgs.mkShell {
  # Automatically install packages like python3 and nodejs_20 from your dev.nix
  buildInputs = devNix.packages or [];

  # Map env variables
  shellHook = ''
    echo "--- Anti-gravity Environment Loading ---"
    
    # Run onCreate hooks if not already done
    if [ ! -f .idx_done ]; then
      echo "Executing onCreate hooks..."
      ${pkgs.lib.concatStringsSep "\n" (builtins.attrValues (builtins.removeAttrs onCreateScript ["default"]))}
      touch .idx_done
    fi

    # Create an alias for the 'web' preview command
    alias preview="${pkgs.lib.concatStringsSep " " previewCmd}"
    
    echo "Type 'preview' to start the server."
  '';
}