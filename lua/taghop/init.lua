-- lua/taghop/init.lua
-- Main module for TagHop plugin

local M = {}

-- Store for tagged files
M.tagged_files = {}
M.max_tags = 10

-- Tag the current buffer
function M.tag_current_file()
  local current_file = vim.fn.expand('%:p')
  
  -- Check if file is already tagged
  for _, file in ipairs(M.tagged_files) do
    if file == current_file then
      vim.notify("File already tagged!", vim.log.levels.INFO)
      return
    end
  end
  
  -- Check if we've reached the maximum number of tags
  if #M.tagged_files >= M.max_tags then
    vim.notify("Maximum tags reached (" .. M.max_tags .. "). Untag a file first.", vim.log.levels.WARN)
    return
  end
  
  -- Add the file to tagged_files
  table.insert(M.tagged_files, current_file)
  vim.notify("Tagged: " .. vim.fn.fnamemodify(current_file, ':~:.'), vim.log.levels.INFO)
end

-- Untag the current buffer
function M.untag_current_file()
  local current_file = vim.fn.expand('%:p')
  
  -- Find and remove the file from tagged_files
  for i, file in ipairs(M.tagged_files) do
    if file == current_file then
      table.remove(M.tagged_files, i)
      vim.notify("Untagged: " .. vim.fn.fnamemodify(current_file, ':~:.'), vim.log.levels.INFO)
      return
    end
  end
  
  vim.notify("Current file is not tagged!", vim.log.levels.WARN)
end

-- Get a shorter display name for a file path
local function get_display_name(file_path)
  -- Get the filename only
  local filename = vim.fn.fnamemodify(file_path, ':t')
  
  -- Get a shortened path relative to cwd
  local short_path = vim.fn.fnamemodify(file_path, ':~:.')
  
  return filename .. " (" .. short_path .. ")"
end

-- Open a floating window with tagged files
function M.list_tagged_files()
  -- If no files are tagged, show a message and return
  if #M.tagged_files == 0 then
    vim.notify("No files are currently tagged.", vim.log.levels.INFO)
    return
  end
  
  -- Prepare the buffer content
  local lines = {"TagHop - Tagged Files:", ""}
  for i, file in ipairs(M.tagged_files) do
    table.insert(lines, i .. ". " .. get_display_name(file))
  end
  table.insert(lines, "")
  table.insert(lines, "Press number to jump to file, 'u' + number to untag, or 'q' to close")
  
  -- Create a new buffer for the UI
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  
  -- Set buffer options
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  
  -- Calculate window size and position
  local width = 80
  local height = #lines
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded"
  }
  
  -- Create the window
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  
  -- Set window options
  vim.api.nvim_win_set_option(win, 'winblend', 10)
  vim.api.nvim_win_set_option(win, 'cursorline', true)
  
  -- Set keymaps for the buffer
  local function set_keymap(key, action)
    vim.api.nvim_buf_set_keymap(buf, 'n', key, action, {
      noremap = true,
      silent = true,
      nowait = true
    })
  end
  
  -- Set up number keys for jumping to files
  for i = 1, math.min(9, #M.tagged_files) do
    set_keymap(tostring(i), string.format([[<cmd>lua require('taghop').jump_to_file(%d)<CR>]], i))
  end
  
  -- Add key for file 10 if we have 10 files
  if #M.tagged_files >= 10 then
    set_keymap('0', [[<cmd>lua require('taghop').jump_to_file(10)<CR>]])
  end
  
  -- Set up 'u' + number keys for untagging files
  for i = 1, math.min(9, #M.tagged_files) do
    set_keymap('u' .. tostring(i), string.format([[<cmd>lua require('taghop').untag_file_by_index(%d)<CR>]], i))
  end
  
  -- Add key for untagging file 10 if we have 10 files
  if #M.tagged_files >= 10 then
    set_keymap('u0', [[<cmd>lua require('taghop').untag_file_by_index(10)<CR>]])
  end
  
  -- Close the window with 'q' or Escape
  set_keymap('q', [[<cmd>q<CR>]])
  set_keymap('<Esc>', [[<cmd>q<CR>]])
end

-- Jump to a file by its index in the tagged files list
function M.jump_to_file(index)
  if M.tagged_files[index] then
    vim.cmd('edit ' .. vim.fn.fnameescape(M.tagged_files[index]))
  else
    vim.notify("Invalid file index", vim.log.levels.ERROR)
  end
end

-- Untag a file by its index in the tagged files list
function M.untag_file_by_index(index)
  if M.tagged_files[index] then
    local file = M.tagged_files[index]
    table.remove(M.tagged_files, index)
    vim.notify("Untagged: " .. vim.fn.fnamemodify(file, ':~:.'), vim.log.levels.INFO)
    -- Refresh the UI
    vim.cmd('q')
    M.list_tagged_files()
  else
    vim.notify("Invalid file index", vim.log.levels.ERROR)
  end
end

-- Plugin setup function
function M.setup(opts)
  opts = opts or {}
  
  -- Set max tags from config
  if opts.max_tags then
    M.max_tags = opts.max_tags
  end
  
  -- Setup commands
  vim.cmd([[
    command! TagHopTag lua require('taghop').tag_current_file()
    command! TagHopUntag lua require('taghop').untag_current_file()
    command! TagHopList lua require('taghop').list_tagged_files()
  ]])
  
  -- Return the module
  return M
end

return M
