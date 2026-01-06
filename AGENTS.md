# AGENTS.md

This document provides AI agents with the essential context for working with the nix-common-config repository.

## Repository Purpose

This repository contains common NixOS, nix-darwin, and home-manager modules that are:
- Reusable across multiple machines
- Generally non-sensitive (no secrets)
- Designed to be imported as a git submodule in private machine configs
- Licensed under LGPL v3

## Core Pattern: Function-Returning-Function Modules

ALL modules in this repository MUST follow this pattern:

```nix
flake @ {inputs, ...}: {config, lib, pkgs, ...}: {
  # Module content here
}
```

The first function layer receives the flake object, giving modules access to all flake inputs. The second layer is the standard Nix module interface.

## Module Auto-Discovery

The `gatherModules` function in `lib.nix` automatically:
1. Scans module directories recursively
2. Converts file paths to module names using kebab-case
3. Applies the flake object to each module
4. Exposes them as flake outputs

### Naming Convention
- `modules/nixos/base/common.nix` → `nixosModules.base-common`
- `modules/home-manager/hypr/default.nix` → `homeModules.hypr`
- `modules/nvf/assist/lsp.nix` → `nvfModules.assist-lsp`

Note: `default.nix` files collapse their directory name (the `/default` suffix is removed). This aligns with Nix's built-in behavior where importing a directory imports the `default.nix` within it. Use this pattern for highly-complex modules broken into submodules for organization, where submodules are interdependent and the entire sub-tree should be imported as a set. For example:
- `nixos/base/` - Independent, reusable modules
- `home-manager/hypr/` - Interdependent modules forming a cohesive Hyprland environment

## Module Structure

### NixOS Modules (`modules/nixos/`)
- `base/` - Core system modules, always imported via `base-common`
- `interactive/` - GUI/interactive system configurations (laptops/desktops)
- `extra/` - Optional/specialized services
- `server/` - Server-specific configurations
- `quirks/` - Hardware-specific fixes and workarounds

### Home Manager Modules (`modules/home-manager/`)
- Individual program configurations
- Complex environments (e.g., `hypr/`, `caelestia/`)
- Use kebab-case for module filenames

### Darwin Modules (`modules/darwin/`)
- macOS-specific configurations using nix-darwin
- Often reference cryptic macOS defaults keys that need comments

### NVF Modules (`modules/nvf/`)
- Modular Neovim configuration using the NVF framework
- Organized by function: `assist/`, `editing/`, `ui/`, `mappings/`, etc.

## Writing Modules

### Module Template
```nix
flake @ {inputs, ...}: {config, lib, pkgs, ...}: {
  # Standard module content
  config = lib.mkOverride 900 {
    # Strong but overridable defaults
  };
}
```

### Conventions
- Use `lib.mkOverride 900` for defaults (strong but overridable)
- Use kebab-case for module filenames (e.g., `my-module.nix`)
- Use camelCase for variable names within modules
- Use descriptive filenames that clearly indicate purpose
- Add comments only when option names don't describe their effect
- Example of necessary comments: macOS defaults keys, obscure settings
- Do NOT create new logical subfolders (like `nixos/base`, `nixos/extra`, `nvf/ui`) unless explicitly requested. If a new module doesn't fit in an existing category OR is complex enough that it should be broken down into multiple interdependent modules, seek user approval first

### Import Pattern in Modules
```nix
imports = builtins.attrValues {
  inherit (nixosModules) base-sshd base-sudo;
};
```

## Key Abstractions

### The `hmUsers` Option
Defined in `modules/nixos/base/home-manager-users.nix`, this provides a unified interface for managing Linux users and their Home Manager configurations within NixOS configurations.

## Testing & Formatting
- Use `alejandra` for Nix formatting
- The project supports `x86_64-linux` and `aarch64-darwin`
