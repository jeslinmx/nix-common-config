# AGENTS.md

This document provides AI agents with the essential context for working with the
nix-common-config repository.

## Repository Purpose

This repository contains common NixOS, nix-darwin, and home-manager modules that
are:

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

The first function layer receives the flake object, giving modules access to all
flake inputs. The second layer is the standard Nix module interface. Even if
this layer is not needed (e.g. the module does not rely on any module arguments
such as `pkgs` or `config`), maintain it as a function definition, not as an
attrset:

```nix
# ✅ Do this
_: {...}: {
  # Module content here
}

# ❌️ Don't do this!
_: {
  # Module content here
}
```

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

Note: `default.nix` files collapse their directory name (the `/default` suffix
is removed). This aligns with Nix's built-in behavior where importing a
directory imports the `default.nix` within it. Use this pattern for
highly-complex modules broken into submodules for organization, where submodules
are interdependent and the entire sub-tree should be imported as a set. For
example:

- `nixos/base/` - Independent, reusable modules
- `home-manager/hypr/` - Interdependent modules forming a cohesive Hyprland
  environment

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
- Do NOT create new logical subfolders (like `nixos/base`, `nixos/extra`,
  `nvf/ui`) unless explicitly requested. If a new module doesn't fit in an
  existing category OR is complex enough that it should be broken down into
  multiple interdependent modules, seek user approval first

### Import Pattern in Modules

```nix
imports = builtins.attrValues {
  inherit (nixosModules) base-sshd base-sudo;
};
```

## Checking for Existing Options

**MANDATORY**: Before creating configuration files with `environment.etc`,
`home.file` or `xdg.configFile`, ALWAYS check if a native option exists for
specifying equivalent configuration.

### Why This Matters

- Home Manager, NixOS, and frameworks like NVF provide dedicated module options
  for most popular programs
- Native options provide better type safety, automatic schema handling, and
  integration
- Using `home.file`/`xdg.configFile` when a native option exists bypasses these
  benefits; only use this as an escape hatch when no module exists.
- Most modules also include a `settings`, `config`, `extraConfig`, etc. option
  for specifying additional configuration as an arbitrary attrset or string; use
  this as an escape hatch for configuration which the options do not natively
  cover.
- If specifying program config using one of the above escape hatches, also
  prepend a comment with the URL of the program's configuration documentation
  for future reference by users and agents.

### How to Check

Use LSP or an MCP tool to search up available options. Option descriptions will
typically also mention the name of the config file which will be written to.

#### Home Manager Options

```nix
# ✅ Check first: Is there a programs.<name> option?
programs.opencode = {
  enable = true;
  rules = { /* config */ };
  agents = { /* config */ };
  settings = { /* config */ };
  /* config */
};

# ❌ Don't do this if programs.<name> exists:
home.file.".config/opencode/config.json".text = builtins.toJSON { /* config */ };
```

#### NixOS Options

```nix
# ✅ Check first: Is there a services.<name> option?
services.nginx = {
  enable = true;
  # ...
};

# ❌ Don't manually manage systemd services if a module exists
```

#### NVF Options

```nix
# ✅ Check first: Is there a built-in plugin/option?
vim.lsp = {
  enable = true;
  /* config */
}

# ❌ Don't manually configure if nvf provides an abstraction
vim.plugins = [ pkgs.vimPlugins.nvim-lspconfig ];
```

## Configuration File Management

When native options don't exist for a program, use these guidelines for creating
configuration files.

### Prefer `xdg.configFile` for XDG-Compliant Configs

For programs that follow XDG Base Directory specifications and store config in
`~/.config`:

```nix
# ✅ Preferred for XDG-compliant configs
xdg.configFile."program/config.toml".source = pkgs.writers.writeTOML "config.toml" {
  setting = "value";
};

# ❌️  less semantic, don't do this
home.file.".config/program/config.toml".source = pkgs.writers.writeTOML "config.toml" {
  setting = "value";
};
```

### When to Use Each

| Use Case                             | Recommended Option        | Reason                                                     |
| ------------------------------------ | ------------------------- | ---------------------------------------------------------- |
| XDG-compliant configs in `~/.config` | `xdg.configFile`          | Semantic clarity, uses `xdg.configHome`                    |
| Files outside `~/.config`            | `home.file`               | General-purpose file placement                             |
| Directory symlinking                 | `home.file."path".source` | Bring in an entire directory's files from a Nix store path |

### Examples from This Repository

```nix
# ✅ xdg.configFile: XDG-compliant program
xdg.configFile."termshark/termshark.toml".source = pkgs.writers.writeTOML "" { ... };

# ✅ home.file: Directory symlinking
home.file.".config/hypr/shaders".source = ./shaders;
```

## Key Abstractions

### The `hmUsers` Option

Defined in `modules/nixos/base/home-manager-users.nix`, this provides a unified
interface for managing Linux users and their Home Manager configurations within
NixOS configurations.

## Testing & Formatting

- Use `alejandra` for Nix formatting
- The project supports `x86_64-linux` and `aarch64-darwin`
