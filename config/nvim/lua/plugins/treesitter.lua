-- Treesitter plugins
-- ===

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- Install parsers
      local ensure_installed = {
        "bash", "c", "css", "go", "hcl", "html", "java", "javascript",
        "json", "lua", "make", "markdown", "markdown_inline", "python",
        "query", "regex", "ruby", "rust", "scala", "toml", "tsx",
        "typescript", "vim", "vimdoc", "yaml",
      }

      -- Auto-install parsers
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local ft = vim.bo.filetype
          local lang = vim.treesitter.language.get_lang(ft) or ft
          if vim.tbl_contains(ensure_installed, lang) then
            pcall(vim.treesitter.start)
          end
        end,
      })

      -- Enable highlighting
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
  },

  -- Auto close/rename HTML tags
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
