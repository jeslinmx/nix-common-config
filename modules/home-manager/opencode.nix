_: {pkgs, ...}: {
  programs.opencode = {
    settings = {
      plugin = [
        "oh-my-opencode"
        "opencode-antigravity-auth@1.2.7"
      ];
      provider = {
        google = {
          name = "Google";
          models = {
            antigravity-gemini-3-pro-high = {
              name = "Gemini 3 Pro High (Antigravity)";
              attachment = true;
              limit = {
                context = 1048576;
                output = 65535;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [
                  "text"
                ];
              };
            };
            antigravity-gemini-3-pro-low = {
              name = "Gemini 3 Pro Low (Antigravity)";
              attachment = true;
              limit = {
                context = 1048576;
                output = 65535;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [
                  "text"
                ];
              };
            };
            antigravity-gemini-3-flash = {
              name = "Gemini 3 Flash (Antigravity)";
              attachment = true;
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = [
                  "text"
                  "image"
                  "pdf"
                ];
                output = [
                  "text"
                ];
              };
            };
          };
        };
      };
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };
        grep = {
          type = "remote";
          url = "https://mcp.grep.app";
        };
        duckduckgo = {
          type = "local";
          command = [
            "uvx"
            "duckduckgo-mcp-server"
          ];
        };
        fetch = {
          type = "local";
          command = [
            "uvx"
            "mcp-server-fetch"
          ];
        };
        git = {
          type = "local";
          command = [
            "uvx"
            "mcp-server-git"
            "--repository"
            "\${workspaceFolder}"
          ];
        };
        memory = {
          type = "local";
          command = [
            "bunx"
            "-y"
            "@modelcontextprotocol/server-memory"
          ];
          enabled = false;
        };
        sequentialthinking = {
          type = "local";
          command = [
            "bunx"
            "-y"
            "@modelcontextprotocol/server-sequential-thinking"
          ];
          enabled = false;
        };
      };
    };
  };
  xdg.configFile."opencode/oh-my-opencode.json".text = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json";
    google_auth = false;
    agents = {
      Sisyphus = {
        model = "opencode/glm-4.7-free";
      };
      librarian = {
        model = "opencode/glm-4.7-free";
      };
      explore = {
        model = "google/antigravity-gemini-3-flash";
      };
      oracle = {
        model = "opencode/glm-4.7-free";
      };
      frontend-ui-ux-engineer = {
        model = "google/antigravity-gemini-3-pro-high";
      };
      document-writer = {
        model = "google/antigravity-gemini-3-flash";
      };
      multimodal-looker = {
        model = "google/antigravity-gemini-3-flash";
      };
    };
  };
  home.packages = with pkgs; [uv bun];
}
