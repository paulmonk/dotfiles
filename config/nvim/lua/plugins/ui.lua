-- UI plugins
-- ===

return {
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    },
    opts = {
      view = { side = "left" },
      renderer = {
        icons = { show = { git = false } },
      },
    },
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to buffer 1" },
      { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to buffer 2" },
      { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to buffer 3" },
      { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to buffer 4" },
      { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to buffer 5" },
      { "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Go to buffer 6" },
      { "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Go to buffer 7" },
      { "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Go to buffer 8" },
      { "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Go to buffer 9" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        offsets = {
          { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", separator = true },
        },
      },
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "solarized_dark",
        globalstatus = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "                                   ",
        "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
        "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠠⡐⠐⠁⠀⠀⠛⠁  ⠿⣿⣿⣷⠆         ",
        "         ⠊⠉⠛⠿⣶⣦⣶⣶⣤⣶⣀⠠⣤⣤⣤⣧⠄⣀⣴⣿⡿⣻⣿        ",
        "             ⠀⠀⠀⠉⠛⠿⣿⣶⣤⠤⣍⠙⣿⣿⣿⣿⣿⣿⣿⣿        ",
        "               ⠀⠀⠉⠻⣿⣶⣤⣈⠛⢦⠙⣿⣿⣿⣿⣿⣿        ",
        "                  ⠉⠻⣿⣷⣤⣙⣃⡠⣌⣿⣿⣿⣿⣿        ",
        "                    ⠙⢿⣿⣶⣤⡀⡶⣿⣿⣿⣿        ",
        "                      ⠹⣿⣷⣶⣤⣼⣿⣿⣿        ",
        "                       ⠹⣿⣿⣿⣿⣿⣿        ",
        "                                   ",
        "            N E O V I M             ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("n", " " .. " New file", "<cmd>ene <BAR> startinsert<cr>"),
        dashboard.button("r", " " .. " Recent files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("g", " " .. " Find text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("c", " " .. " Config", "<cmd>e $MYVIMRC<cr>"),
        dashboard.button("l", "󰒲 " .. " Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("q", " " .. " Quit", "<cmd>qa<cr>"),
      }
      return dashboard.opts
    end,
    config = function(_, opts)
      require("alpha").setup(opts)
    end,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = { enabled = true } },
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>j", group = "jump" },
        { "<leader>l", group = "LLM/Claude" },
        { "<leader>lc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
        { "<leader>lf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
        { "<leader>ls", "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude", mode = "v" },
        { "<leader>la", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        { "<leader>ld", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject diff" },
        { "<leader>lm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "toggle" },
        { "<leader>x", group = "diagnostics" },
      },
    },
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    keys = {
      { "<leader>un", function() require("notify").dismiss({ silent = true, pending = true }) end, desc = "Dismiss notifications" },
    },
    opts = {
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.75) end,
    },
    init = function()
      vim.notify = require("notify")
    end,
  },

  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
