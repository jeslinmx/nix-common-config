_: {
  lib,
  pkgs,
  ...
}: {
  programs.opencode = {
    enableMcpIntegration = true;
    rules = ./AGENTS.md;
    agents = ./agents;
    commands = ./commands;
    # skills = ./skills;
    tools = ./tools;
    settings = let
      toolsets = {
        weblookup = ["webfetch" "websearch" "exa_*" "grep_app_*" "context7_*"];
        filelookup = ["list" "glob" "grep" "lsp"];
        delegate = ["todowrite" "task"];
      };
      sensitiveFiles = ["*.env" "*.env.*" "*.aes" "*.age" "*.argon2" "*.bcrypt" "*.gpg" "*.pgp" "*.scrypt" "*.cert" "*.crt" "*.key" "*.pem" "secret/**" "secrets/**" "credential/**" "credentials/**"];
      applyPerms = perms:
        perms
        |> lib.mapAttrsToList (tool: perm:
          toolsets |> lib.attrByPath [tool] [tool] |> map (tool: lib.nameValuePair tool perm))
        |> lib.flatten
        |> builtins.listToAttrs;
      applyPolicy = policy: files: files |> map (file: lib.nameValuePair file policy) |> builtins.listToAttrs;
    in {
      permission = applyPerms {
        weblookup = "allow";
        filelookup = "allow";
        read = (applyPolicy "allow" ["*"]) // (applyPolicy "deny" sensitiveFiles);
        write = (applyPolicy "allow" ["*"]) // (applyPolicy "deny" sensitiveFiles);
        delegate = "allow";
        bash = "ask";

        skill = "allow";
        todoread = "allow";
        external_directory = "ask";
        doom_loop = "deny";
      };
      agent = {
        plan.permission = applyPerms {write = "deny";};
      };
      plugin = [
        "opencode-antigravity-auth@1.6.0"
        # "@ramtinj95/opencode-tokenscope"
        "@spoons-and-mirrors/subtask2@latest"
      ];
      provider = {
        google = let
          geminiParams = {
            limit = {
              context = 1048576;
              output = 65535;
            };
            modalities = {
              input = ["text" "image" "pdf"];
              output = ["text"];
            };
          };
          proParams =
            geminiParams
            // {
              variants = {
                low.thinkingLevel = "low";
                high.thinkingLevel = "high";
              };
            };
          flashParams = geminiParams // {limit = geminiParams.limit // {output = 65536;};};
          claudeParams = {
            limit = {
              context = 200000;
              output = 64000;
            };
            modalities = {
              input = ["text" "image" "pdf"];
              output = ["text"];
            };
          };
        in {
          name = "Google";
          models = {
            antigravity-gemini-3-pro = proParams // {name = "Gemini 3 Pro (Antigravity)";};
            antigravity-gemini-3-1-pro = proParams // {name = "Gemini 3.1 Pro (Antigravity)";};
            antigravity-gemini-3-flash =
              flashParams
              // {
                name = "Gemini 3 Flash (Antigravity)";
                variants = {
                  minimal.thinkingLevel = "minimal";
                  low.thinkingLevel = "low";
                  medium.thinkingLevel = "medium";
                  high.thinkingLevel = "high";
                };
              };
            antigravity-claude-sonnet-4-6 = claudeParams // {name = "Claude Sonnet 4.6 (Antigravity)";};
            antigravity-claude-opus-4-6-thinking =
              claudeParams
              // {
                name = "Claude Opus 4.6 Thinking (Antigravity)";
                variants = {
                  low.thinkingConfig.thinkingBudget = 8192;
                  max.thinkingConfig.thinkingBudget = 32768;
                };
              };
            gemini-3-1-pro-preview = geminiParams // {name = "Gemini 3.1 Pro Preview (CLI)";};
            gemini-3-1-pro-preview-customtools = geminiParams // {name = "Gemini 3.1 Pro Preview Custom Tools (CLI)";};
            gemini-3-pro-preview = geminiParams // {name = "Gemini 3 Pro Preview (CLI)";};
            gemini-3-flash-preview = flashParams // {name = "Gemini 3 Flash Preview (CLI)";};
            "gemini-2.5-pro" = flashParams // {name = "Gemini 2.5 Pro (CLI)";};
            "gemini-2.5-flash" = flashParams // {name = "Gemini 2.5 Flash (CLI)";};
          };
        };
      };
    };
  };
  # https://github.com/spoons-and-mirrors/subtask2?tab=readme-ov-file#configuration
  xdg.configFile."opencode/subtask2.jsonc".source = pkgs.writers.writeJSON "subtask2.jsonc" {
    replace_generic = true;
    logging = false;
  };

  programs.mcp = {
    enable = true;
    servers = {
      context7.url = "https://mcp.context7.com/mcp";
      grep_app.url = "https://mcp.grep.app";
      exa.url = "https://mcp.exa.ai/mcp?tools=web_search_exa";
    };
  };
  home.packages = with pkgs; [uv bun];
}
