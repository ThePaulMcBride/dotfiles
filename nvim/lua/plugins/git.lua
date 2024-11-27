local keys = require("lazy.core.handler.keys")
return {
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = false,
      message_template = " <summary> • <date> • <author> • <<sha>>",
      date_format = "%Y-%m-%d %H:%M:%S",
      virtual_text_column = 1,
    },
    keys = {
      {
        "<leader>gbu",
        "<cmd>GitBlameToggle<cr>",
        desc = "toggle git blame",
      },
      {
        "<leader>gbe",
        "<cmd>GitBlameEnable<cr>",
        desc = "enable git blame",
      },
      {
        "<leader>gbd",
        "<cmd>GitBlameDisable<cr>",
        desc = "disable git blame",
      },
      {
        "<leader>gbh",
        "<cmd>GitBlameCopySHA<cr>",
        desc = "copy line commit SHA",
      },
      {
        "<leader>gbl",
        "<cmd>GitBlameCopyCommitURL<cr>",
        desc = "copy line commit URL",
      },
      {
        "<leader>gbo",
        "<cmd>GitBlameOpenFileURL<cr>",
        desc = "opens file in default browser",
      },
      {
        "<leader>gbc",
        "<cmd>GitBlameCopyFileURL<cr>",
        desc = "copy file url to clipboard",
      },
    },
  },
}
