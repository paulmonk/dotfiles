-- Autocommands
-- ===

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General autocommands
local general = augroup("user_general", { clear = true })

-- When editing a file, always jump to the last known cursor position
autocmd("BufReadPost", {
  group = general,
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    local excluded = { "gitcommit", "gitrebase", "svn", "hgcommit" }
    for _, v in ipairs(excluded) do
      if ft == v then return end
    end

    if vim.bo.buftype ~= "" or vim.wo.diff or vim.wo.previewwindow then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line = mark[1]
    local last_line = vim.api.nvim_buf_line_count(0)

    if line > 0 and line <= last_line then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
      if vim.fn.foldclosed(".") ~= -1 then
        vim.cmd("normal! zvzz")
      end
    end
  end,
})

-- Update filetype on save if empty
autocmd("BufWritePost", {
  group = general,
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "" or vim.b.ftdetect then
      vim.b.ftdetect = nil
      vim.cmd("filetype detect")
    end
  end,
})

-- Highlight yank
autocmd("TextYankPost", {
  group = general,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- Automatically set read-only for files being edited elsewhere
autocmd("SwapExists", {
  group = general,
  pattern = "*",
  command = "let v:swapchoice = 'o'",
})

-- Update diff comparison once leaving insert mode
autocmd("InsertLeave", {
  group = general,
  pattern = "*",
  callback = function()
    if vim.wo.diff then
      vim.cmd("diffupdate")
    end
  end,
})

-- Equalize window dimensions when resizing vim window
autocmd("VimResized", {
  group = general,
  pattern = "*",
  command = "wincmd =",
})

-- Check if file changed when its window is focus
autocmd("FocusGained", {
  group = general,
  pattern = "*",
  command = "checktime",
})

-- Highlight current line only on focused normal buffer windows
autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
  group = general,
  pattern = "*",
  callback = function()
    if not vim.wo.cursorline and vim.bo.buftype == "" then
      vim.wo.cursorline = true
    end
  end,
})

-- Hide cursor line when leaving normal non-diff windows
autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
  group = general,
  pattern = "*",
  callback = function()
    if vim.wo.cursorline and not vim.wo.diff and vim.bo.buftype == "" and not vim.wo.previewwindow and vim.fn.pumvisible() == 0 then
      vim.wo.cursorline = false
    end
  end,
})

-- Enable wrap mode for json files only
autocmd("BufEnter", {
  group = general,
  pattern = { "*.json", "*.jsonc" },
  command = "setlocal wrap",
})

-- Persistent undo
local undo = augroup("user_persistent_undo", { clear = true })

autocmd("BufWritePre", {
  group = undo,
  pattern = { "/tmp/*", "*.tmp", "*.bak", "COMMIT_EDITMSG", "MERGE_MSG" },
  callback = function()
    vim.bo.undofile = false
    if vim.fn.expand("%:t") == "COMMIT_EDITMSG" or vim.fn.expand("%:t") == "MERGE_MSG" then
      vim.bo.swapfile = false
    end
  end,
})

-- Security: disable backup/swap for sensitive files
local secure = augroup("user_secure", { clear = true })

autocmd({ "BufNewFile", "BufReadPre" }, {
  group = secure,
  pattern = { "/tmp/*", "$TMPDIR/*", "$TMP/*", "$TEMP/*", "*/shm/*", "/private/var/*", ".vault.vim" },
  callback = function()
    vim.bo.swapfile = false
    vim.bo.undofile = false
    vim.bo.backup = false
    vim.bo.writebackup = false
    vim.o.shada = ""
  end,
})

-- Filetype-specific settings
local filetypes = augroup("user_filetypes", { clear = true })

autocmd("FileType", {
  group = filetypes,
  pattern = { "apache", "html" },
  command = "setlocal path+=./;/",
})

autocmd("FileType", {
  group = filetypes,
  pattern = "crontab",
  command = "setlocal nobackup nowritebackup",
})

autocmd("FileType", {
  group = filetypes,
  pattern = { "gitcommit", "qfreplace" },
  command = "setlocal nofoldenable",
})

autocmd("FileType", {
  group = filetypes,
  pattern = "gitcommit",
  command = "setlocal spell",
})

autocmd("FileType", {
  group = filetypes,
  pattern = "helm",
  command = "setlocal expandtab",
})

autocmd("FileType", {
  group = filetypes,
  pattern = "markdown",
  command = "setlocal expandtab spell formatoptions=tcroqn2 comments=n:>",
})

autocmd("FileType", {
  group = filetypes,
  pattern = "python",
  command = "setlocal expandtab tabstop=4",
})

autocmd("FileType", {
  group = filetypes,
  pattern = "sql",
  command = "setlocal commentstring=--\\ %s",
})

autocmd("FileType", {
  group = filetypes,
  pattern = "terraform",
  command = "setlocal expandtab",
})

-- Let treesitter use bash highlight for zsh files
autocmd("FileType", {
  group = filetypes,
  pattern = "zsh",
  callback = function()
    local ok, ts_highlight = pcall(require, "nvim-treesitter.highlight")
    if ok then
      ts_highlight.attach(0, "bash")
    end
  end,
})

-- Helm filetype detection
autocmd({ "BufNewFile", "BufRead" }, {
  group = filetypes,
  pattern = { "*/templates/*.yaml", "*/templates/*.yml", "*/templates/*.tpl" },
  command = "setfiletype helm",
})

-- Terraform filetype detection
autocmd({ "BufNewFile", "BufRead" }, {
  group = filetypes,
  pattern = { "*.tf", "*.tfvars" },
  command = "setfiletype terraform",
})

autocmd({ "BufNewFile", "BufRead" }, {
  group = filetypes,
  pattern = "*.hcl",
  command = "setfiletype hcl",
})
