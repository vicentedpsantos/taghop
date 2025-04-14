local M = {}

function M.list_tagged_files()
  local tags = require('taghop.tags')
  local utils = require('taghop.utils')
  
  if #tags.tagged_files == 0 then
    vim.notify("No files are currently tagged.", vim.log.levels.INFO)
    return
  end
  
  local lines = {"TagHop - Tagged Files:", ""}
  for i, file in ipairs(tags.tagged_files) do
    table.insert(lines, i .. ". " .. utils.get_display_name(file))
  end
  table.insert(lines, "")
  table.insert(lines, "Press number to jump to file, 'u' followed by number to untag, or 'q' to close")
  
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.6)
  height = math.max(height, #lines + 2)
  
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded"
  }
  
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  
  vim.api.nvim_win_set_option(win, 'winblend', 10)
  vim.api.nvim_win_set_option(win, 'cursorline', true)
  
  M.setup_keymaps(buf)
end

function M.setup_keymaps(buf)
  local tags = require('taghop.tags')
  
  local function set_keymap(key, action)
    vim.api.nvim_buf_set_keymap(buf, 'n', key, action, {
      noremap = true,
      silent = true,
      nowait = true
    })
  end
  
  for i = 1, math.min(9, #tags.tagged_files) do
    set_keymap(tostring(i), string.format([[<cmd>lua require('taghop').jump_to_file(%d)<CR>]], i))
  end
  
  if #tags.tagged_files >= 10 then
    set_keymap('0', [[<cmd>lua require('taghop').jump_to_file(10)<CR>]])
  end
  
  for i = 1, math.min(9, #tags.tagged_files) do
    set_keymap('u' .. tostring(i), string.format([[<cmd>lua require('taghop').untag_file_by_index(%d)<CR>]], i))
  end
  
  if #tags.tagged_files >= 10 then
    set_keymap('u0', [[<cmd>lua require('taghop').untag_file_by_index(10)<CR>]])
  end
  
  set_keymap('q', [[<cmd>q<CR>]])
  set_keymap('<Esc>', [[<cmd>q<CR>]])
end

return M
