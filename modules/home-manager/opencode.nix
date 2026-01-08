_: {pkgs, ...}: {
  programs.opencode = {
    settings = {
      agent = {
        # disable non-omo agents
        build.disable = true;
        plan.disable = true;
        # disable non-omo subagents
        general.disable = true;
        explore.disable = true;
      };
      plugin = [
        "oh-my-opencode"
        "opencode-antigravity-auth@1.2.7"
        "@ramtinj95/opencode-tokenscope"
        "@simonwjackson/opencode-direnv"
        "@openspoon/subtask2@latest"
      ];
      provider = {
        google = let
          geminiParams = {
            attachment = true;
            limit = {
              context = 1048576;
              output = 65535;
            };
            modalities = {
              input = ["text" "image" "pdf"];
              output = ["text"];
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
            antigravity-gemini-3-pro-high = geminiParams // {name = "Gemini 3 Pro High (Antigravity)";};
            antigravity-gemini-3-pro-low = geminiParams // {name = "Gemini 3 Pro Low (Antigravity)";};
            antigravity-gemini-3-flash = flashParams // {name = "Gemini 3 Flash (Antigravity)";};
            gemini-3-pro-preview = geminiParams // {name = "Gemini 3 Pro Preview (CLI)";};
            gemini-3-flash-preview = flashParams // {name = "Gemini 3 Flash Preview (CLI)";};
            "gemini-2.5-pro" = flashParams // {name = "Gemini 2.5 Pro (CLI)";};
            "gemini-2.5-flash" = flashParams // {name = "Gemini 2.5 Flash (CLI)";};
            antigravity-claude-opus-4-5-thinking-high = claudeParams // {name = "Claude Opus 4.5 Think High (Antigravity)";};
            antigravity-claude-opus-4-5-thinking-medium = claudeParams // {name = "Claude Opus 4.5 Think Medium (Antigravity)";};
            antigravity-claude-opus-4-5-thinking-low = claudeParams // {name = "Claude Opus 4.5 Think Low (Antigravity)";};
            antigravity-claude-opus-4-5 = claudeParams // {name = "Claude Opus 4.5 (Antigravity)";};
            antigravity-claude-sonnet-4-5-thinking-high = claudeParams // {name = "Claude Sonnet 4.5 Think High (Antigravity)";};
            antigravity-claude-sonnet-4-5-thinking-medium = claudeParams // {name = "Claude Sonnet 4.5 Think Medium (Antigravity)";};
            antigravity-claude-sonnet-4-5-thinking-low = claudeParams // {name = "Claude Sonnet 4.5 Think Low (Antigravity)";};
            antigravity-claude-sonnet-4-5 = claudeParams // {name = "Claude Sonnet 4.5 (Antigravity)";};
          };
        };
      };
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };
        grep_app = {
          type = "remote";
          url = "https://mcp.grep.app";
        };
        websearch = {
          type = "remote";
          url = "https://mcp.exa.ai/mcp?tools=web_search_exa";
        };
        github = {
          type = "remote";
          url = "https://api.githubcopilot.com/mcp/";
          oauth = {
            # fixes dynamic client registration
            clientId = "";
            clientSecret = "";
          };
        };
      };
    };
  };
  xdg.configFile."opencode/oh-my-opencode.json".text = let
    glm = "opencode/glm-4.7-free";
    g3flash = "google/antigravity-gemini-3-flash";
    g3proh = "google/antigravity-gemini-3-pro-high";
    copush = "google/antigravity-claude-opus-4-5-thinking-high";
    csonneth = "google/antigravity-claude-sonnet-4-5-thinking-high";
  in
    builtins.toJSON {
      "$schema" = "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json";
      google_auth = false;
      sisyphus_agent = {
        # leave default primary agents enabled as primary
        default_builder_enabled = true;
        planner_enabled = true;
        replace_plan = false;
      };
      agents = let
        permissions = rec {
          read_only = {
            edit = "ask";
            bash = {
              echo = "allow";
              cat = "allow";
              ls = "allow";
              "git status" = "allow";
              "git diff" = "allow";
              "*" = "ask";
            };
            webfetch = "allow";
            doom_loop = "ask";
            external_directory = "ask";
          };
          read_write = {
            edit = "allow";
            bash =
              read_only.bash
              // {
                "git *" = "allow";
              };
          };
        };
      in {
        Sisyphus = {
          # orchestrator
          model = g3proh; # need a better reasoning model
          color = "#000000";
          permission = permissions.read_write;
          # tools = {};
        };
        oracle = {
          # arhictecture and code review
          model = glm; # need a better reasoning model
          permission = permissions.read_only;
        };
        librarian = {
          # code research
          model = g3flash;
          permission = permissions.read_only;
        };
        explore = {
          # codebase exploration
          model = g3flash;
          permission = permissions.read_only;
        };
        frontend-ui-ux-engineer = {
          # ui focused coding
          model = g3proh;
          permission = permissions.read_write;
        };
        document-writer = {
          # technical writing
          model = g3flash;
          permission = permissions.read_write;
        };
        multimodal-looker = {
          # visual content analysis
          model = g3flash;
          permission = permissions.read_only;
        };
      };
      background_task = {
        modelConcurrency = {
          ${glm} = 10;
          ${g3flash} = 10;
          ${g3proh} = 2;
          ${copush} = 2;
          ${csonneth} = 5;
        };
      };
      disabled_mcps = ["websearch" "context7" "grep_app"]; # do it ourselves
    };
  home.packages = with pkgs; [uv bun];
}
