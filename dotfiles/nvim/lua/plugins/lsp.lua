return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      ruby_lsp = {
        mason = false,
      },
    },
  },
}
