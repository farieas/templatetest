# anti-gravity-init.sh
# 1. Create a workspace directory
mkdir -p ./my-workspace
TARGET_DIR=$(realpath ./my-workspace)

# 2. Run the template's bootstrap logic using nix-build
# We use --arg to inject pkgs and --out-link to capture the result
nix-build -E "let pkgs = import <nixpkgs> {}; in (import ./idx-template.nix { inherit pkgs; }).bootstrap" \
  --substituters "https://cache.nixos.org" \
  --argstr WS_NAME "my-app" \
  -o "$TARGET_DIR"

# Note: The unmodified idx-template.nix logic will now copy ./app to $TARGET_DIR
