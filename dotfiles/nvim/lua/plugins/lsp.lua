return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        ruby_lsp = {
          mason = false,
        },
        rubocop = {
          enabled = false,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ruby = { "standardrb", "rubocop", stop_after_first = true },
      },
      formatters = {
        standardrb = {
          command = "bundle",
          prepend_args = { "exec", "standardrb" },
          condition = function(_, ctx)
            return vim.fs.find(".standard.yml", { path = ctx.dirname, upward = true })[1] ~= nil
          end,
        },
        rubocop = {
          command = "bundle",
          prepend_args = { "exec", "rubocop" },
        },
      },
    },
  },
}
