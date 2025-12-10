return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
    "b0o/schemastore.nvim",
  },

  opts = {
    servers = {
      bashls = {},
      emmet_language_server = {},
      gopls = {},
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                vim.fn.expand "$VIMRUNTIME/lua",
                vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
                vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                "${3rd}/luv/library",
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
          },
        },
      },
      nixd = {
        settings = {
          nixd = {
            options = {
              nixos = {
                expr = "(builtins.getFlake (builtins.toString <nix-config>)).nixosConfigurations."
                  .. vim.uv.os_gethostname()
                  .. ".options",
              },
              home_manager = {
                expr = "(builtins.getFlake (builtins.toString <nix-config>)).nixosConfigurations."
                  .. vim.uv.os_gethostname()
                  .. ".options.home-manager.users.type.getSubOptions []",
              },
            },
          },
        },
      },
      pylsp = {},
      superhtml = {},
      tailwindcss = {},
      ts_ls = {},
      jsonls = function()
        return {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas {
                extra = {
                  description = "Fastfetch config file schema",
                  fileMatch = "config.jsonc",
                  name = "fastfetch",
                  url = "https://raw.githubusercontent.com/fastfetch-cli/fastfetch/refs/heads/dev/doc/json_schema.json",
                },
                validate = { enable = true }, -- https://github.com/b0o/SchemaStore.nvim/issues/8#issuecomment-1129528787
              },
            },
          },
        }
      end,
      yamlls = function()
        return {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" }, -- disable builtin support
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        }
      end,
    },
  },
  config = function(_, opts)
    -- enable lsps
    for lsp, config in pairs(opts.servers) do
      vim.lsp.config(lsp, type(config) == "function" and config() or config)
      vim.lsp.enable(lsp)
    end
  end,

  lazy = false,
}
