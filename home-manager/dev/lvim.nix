{ lib, pkgs, config, inputs, ... }:
let 
    cfg = config.programs.lvim;
in
{
  options = {
    programs.lvim.enable = lib.mkEnableOption "Enable lvim";
  };
  config = lib.mkIf cfg.enable {
      home.packages = [ inputs.nixpkgs-2411.legacyPackages.${pkgs.system}.lunarvim ];
      home.file."${config.xdg.configHome}/lvim/config.lua" = {
        text = ''
          --[[
           THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
           `lvim` is the global options object
          ]]
          -- vim options
          vim.opt.shiftwidth = 4
          vim.opt.tabstop = 4
          vim.opt.relativenumber = true
          vim.opt.wrap = true
          vim.opt.textwidth = 0
          -- vim.opt.columns = 80
          vim.opt.wrapmargin = 0
          -- vim.opt.linebreak = true

          -- general
          lvim.log.level = "info"
          lvim.format_on_save = {
              enabled = true,
              pattern = { "*.rs", "*.md", "*.lua" },
              timeout = 1000,
          }
          -- to disable icons and use a minimalist setup, uncomment the following
          -- lvim.use_icons = false

          -- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
          lvim.leader = ","
          -- add your own keymapping
          lvim.keys.normal_mode["<M-k>"] = "gk"
          lvim.keys.normal_mode["<M-j>"] = "gj"
          lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
          lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
          lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

          lvim.keys.insert_mode["kj"] = "<Esc>"
          lvim.keys.insert_mode["jk"] = "<Esc>"


          -- -- Use which-key to add extra bindings with the leader-key prefix
          -- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
          -- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

          -- -- Change theme settings
          lvim.colorscheme = "lunar"

          lvim.builtin.alpha.active = true
          lvim.builtin.alpha.mode = "dashboard"
          lvim.builtin.terminal.active = true
          lvim.builtin.nvimtree.setup.view.side = "left"
          lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

          -- Automatically install missing parsers when entering buffer
          lvim.builtin.treesitter.auto_install = true
          lvim.builtin.treesitter.indent = false

          -- lvim.builtin.treesitter.ignore_install = { "haskell" }

          -- -- always installed on startup, useful for parsers without a strict filetype
          -- lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }

          -- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

          -- --- disable automatic installation of servers lvim.lsp.installer.setup.automatic_installation = false

          -- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
          -- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
          -- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
          -- local opts = {} -- check the lspconfig documentation for a list of all possible options
          -- require("lvim.lsp.manager").setup("pyright", opts)

          -- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
          -- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
          -- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
          --   return server ~= "emmet_ls"
          -- end, lvim.lsp.automatic_configuration.skipped_servers)

          -- -- you can set a custom on_attach function that will be used for all the language servers
          -- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
          -- lvim.lsp.on_attach_callback = function(client, bufnr)
          --   local function buf_set_option(...)
          --     vim.api.nvim_buf_set_option(bufnr, ...)
          --   end
          --   --Enable completion triggered by <c-x><c-o>
          --   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
          -- end

          -- -- linters, formatters and code actions <https://www.lunarvim.org/docs/languages#lintingformatting>
          -- local formatters = require "lvim.lsp.null-ls.formatters"
          -- formatters.setup {
          --   { command = "stylua" },
          --   {
          --     command = "prettier",
          --     extra_args = { "--print-width", "100" },
          --     filetypes = { "typescript", "typescriptreact" },
          --   },
          -- }
          -- local linters = require "lvim.lsp.null-ls.linters"
          -- linters.setup {
          --   { command = "flake8", filetypes = { "python" } },
          --   {
          --     command = "shellcheck",
          --     args = { "--severity", "warning" },
          --   },
          -- }
          -- local code_actions = require "lvim.lsp.null-ls.code_actions"
          -- code_actions.setup {
          --   {
          --     exe = "eslint",
          --     filetypes = { "typescript", "typescriptreact" },
          --   },
          -- }

          -- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
          -- lvim.plugins = {
          --     {
          --       "folke/trouble.nvim",
          --       cmd = "TroubleToggle",
          --     },
          -- }

          vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer", "pyright" })
          lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
            return server ~= "ruff"
          end, lvim.lsp.automatic_configuration.skipped_servers)

          lvim.plugins = {
              {
                  "simrat39/rust-tools.nvim",
                  -- ft = { "rust", "rs" }, -- IMPORTANT: re-enabling this seems to break inlay-hints
                  config = function()
                      require("rust-tools").setup {
                          tools = {
                              executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
                              reload_workspace_from_cargo_toml = true,
                              inlay_hints = {
                                  auto = true,
                                  only_current_line = false,
                                  show_parameter_hints = true,
                                  parameter_hints_prefix = "<- ",
                                  other_hints_prefix = "=> ",
                                  max_len_align = false,
                                  max_len_align_padding = 1,
                                  right_align = false,
                                  right_align_padding = 7,
                                  highlight = "Comment",
                              },
                              hover_actions = {
                                  border = {
                                      { "╭", "FloatBorder" },
                                      { "─", "FloatBorder" },
                                      { "╮", "FloatBorder" },
                                      { "│", "FloatBorder" },
                                      { "╯", "FloatBorder" },
                                      { "─", "FloatBorder" },
                                      { "╰", "FloatBorder" },
                                      { "│", "FloatBorder" },
                                  },
                                  auto_focus = true,
                              },
                          },
                          server = {
                              on_init = require("lvim.lsp").common_on_init,
                              on_attach = function(client, bufnr)
                                  require("lvim.lsp").common_on_attach(client, bufnr)
                                  local rt = require "rust-tools"
                                  -- Hover actions
                                  vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
                                  -- Code action groups
                                  vim.keymap.set("n", "<leader>lA", rt.code_action_group.code_action_group, { buffer = bufnr })
                              end,
                          },
                      }
                  end,
              },
          }

          -- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
          -- vim.api.nvim_create_autocmd("FileType", {
          --   pattern = "zsh",
          --   callback = function()
          --     -- let treesitter use bash highlight for zsh files as well
          --     require("nvim-treesitter.highlight").attach(0, "bash")
          --   end,
          -- })
        '';
      };
  };
}
