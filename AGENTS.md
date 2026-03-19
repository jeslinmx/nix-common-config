# AGENTS.md

This document provides the essential context for working with the nix-common-config repository.

## Repository Purpose

NixOS, nix-darwin, and home-manager modules that are:

- Reusable across multiple machines
- Non-sensitive (no secrets)

The project targets `x86_64-linux` and `aarch64-darwin`

## Core Pattern: Function-Returning-Function Modules

ALL modules in this repository MUST follow this pattern:

```nix
{inputs, ...}: {config, lib, pkgs, ...}: {
  # Module content here
}
```

The first function layer receives the flake object, providing access to all flake inputs and outputs. The second layer is the standard Nix module interface. Even if this layer is not needed (e.g. the module does not rely on any module arguments such as `pkgs` or `config`), maintain it as a function definition for consistency.

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

Nix files under the subdirectories of `./modules/` are automatically registered as modules in the flake outputs. The names are processed as such:

- The first subdirectory level determines the type of module - `nixosModules` is populated by `./modules/nixos/`, `homeModules` by `./modules/home-manager/` etc.
- Remaining subdirectory levels are for logical organization and their names are concatenated in kebab-case
- `default.nix` files collapse into their parent directory's name
- Examples:
  - `modules/nixos/base/common.nix` → `nixosModules.base-common`
  - `modules/home-manager/hypr/default.nix` → `homeModules.hypr`
  - `modules/nvf/assist/lsp.nix` → `nvfModules.assist-lsp`

If necessary, consult the `gatherModules` calls in `flake.nix` and definition in `lib.nix` for implementation details.

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

**MANDATORY**: Before creating configuration files with `environment.etc`, `home.file` or `xdg.configFile`, ALWAYS check if a native option exists for specifying equivalent configuration. Most modules also include a `settings`, `config`, `extraConfig`, etc. option for specifying additional configuration as an arbitrary attrset or string; use this as an escape hatch for configuration which the options do not natively cover.
If specifying program config using one of the above escape hatches, also prepend a comment with the URL of the program's configuration documentation for future reference by users and agents.

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

## Key Abstractions

### The `hmUsers` Option

Defined in `modules/nixos/base/home-manager-users.nix`, this provides a unified
interface for managing Linux users and their Home Manager configurations within
NixOS configurations.

## Tips

- When troubleshooting nvf configuration issues, you can run `nvf-print-config` to dump the entirety of the generated neovim config for inspection.
