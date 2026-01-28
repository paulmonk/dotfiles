-- Keymaps
-- ===

local map = vim.keymap.set

-- Disable arrow movement, resize windows instead
map("n", "<Up>", "<cmd>resize +1<CR>", { desc = "Increase window height" })
map("n", "<Down>", "<cmd>resize -1<CR>", { desc = "Decrease window height" })
map("n", "<Left>", "<cmd>vertical resize +1<CR>", { desc = "Increase window width" })
map("n", "<Right>", "<cmd>vertical resize -1<CR>", { desc = "Decrease window width" })

-- Fast Saving
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("v", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("c", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Fast Quit
map("n", "Q", "<cmd>q!<CR>", { desc = "Quit without saving" })

-- Toggle fold
map("n", "<CR>", "za", { desc = "Toggle fold" })

-- Double leader key for toggling visual-line mode
map("n", "<Leader><Leader>", "V", { desc = "Visual line mode" })
map("v", "<Leader><Leader>", "<Esc>", { desc = "Exit visual mode" })

-- Drag current line/s vertically and auto-indent
map("n", "<Leader>k", "<cmd>move-2<CR>==", { desc = "Move line up" })
map("n", "<Leader>j", "<cmd>move+<CR>==", { desc = "Move line down" })
map("v", "<Leader>k", ":move'<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<Leader>j", ":move'>+<CR>gv=gv", { desc = "Move selection down" })

-- Duplicate lines without affecting PRIMARY and CLIPBOARD selections
map("n", "<Leader>d", 'm`""Y""P``', { desc = "Duplicate line" })
map("v", "<Leader>d", '""Y""Pgv', { desc = "Duplicate selection" })

-- Reselect and re-yank any text that is pasted in visual mode
map("v", "p", "pgvy", { desc = "Paste and re-yank" })

-- Start an external command with a single bang
map("n", "!", ":!>", { desc = "External command" })

-- Window control
map("n", "s", "<Nop>")
map("n", "sb", "<cmd>buffer#<CR>", { desc = "Alternate buffer" })
map("n", "sc", "<cmd>close<CR>", { desc = "Close window" })
map("n", "sd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "sv", "<cmd>split<CR>", { desc = "Split horizontal" })
map("n", "sg", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "st", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "so", "<cmd>only<CR>", { desc = "Only window" })
map("n", "sq", "<cmd>quit<CR>", { desc = "Quit window" })

-- Split current buffer, go to previous window and previous buffer
map("n", "ssv", "<cmd>split<CR><cmd>wincmd p<CR><cmd>e#<CR>", { desc = "Split and go to prev" })
map("n", "ssg", "<cmd>vsplit<CR><cmd>wincmd p<CR><cmd>e#<CR>", { desc = "Vsplit and go to prev" })

-- C-r: Easier search and replace visual/select mode
map("x", "<C-r>", function()
  local selection = vim.fn.getreg("s")
  vim.cmd('normal! gv"sy')
  local escaped = vim.fn.escape(vim.fn.getreg("s"), "\\/")
  escaped = escaped:gsub("\n", "\\n")
  vim.fn.setreg("s", selection)
  return ":%s/\\V" .. escaped .. "//gc<Left><Left><Left>"
end, { expr = true, desc = "Search and replace selection" })

-- Helper functions
local M = {}

-- Jump to URL, Hex Code, GitHub Project or Word
function M.jump_to_selection()
  local word = vim.fn.expand("<cWORD>")
  local url = word:match("https?://[^ >,;)]*")

  if url then
    vim.fn.system({ "open", url })
    print("Opening URL " .. url)
    return
  end

  local hexcode = word:match("[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]")
  if hexcode then
    url = "https://www.colorhexa.com/" .. hexcode
    vim.fn.system({ "open", url })
    print("Opened HEX colour " .. url)
    return
  end

  local project = word:match("[0-9a-zA-Z-]+/[0-9a-zA-Z-%.]+")
  if project then
    url = "https://github.com/" .. project
    vim.fn.system({ "open", url })
    print("Opened GitHub project: " .. project)
    return
  end

  -- Cheat for keyword
  local ft = vim.bo.filetype
  url = "https://cheat.sh/" .. ft .. "/" .. word
  vim.fn.termopen("curl -s " .. url)
  print("Opened Cheat " .. url)
end

-- Jump to Vim Help page for word under cursor
function M.jump_help_page()
  local word = vim.fn.expand("<cword>")
  vim.cmd("help " .. word)
end

-- Delete whitespace at end of lines
function M.delete_trailing_whitespace()
  local pos = vim.fn.getpos(".")
  vim.cmd([[%s/\s*$//e]])
  vim.fn.setpos(".", pos)
end

-- Expose functions globally for keymaps
_G.custom_keymaps = M

-- Jump keymaps
map("n", "<Leader>jh", function() M.jump_help_page() end, { desc = "Jump to vim help" })
map("n", "<Leader>jj", function() M.jump_to_selection() end, { desc = "Jump to URL/hex/github" })

-- Terminal mode navigation
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
