local M = {}

M.tagged_files = {}

function M.tag_current_file()
  local current_file = vim.fn.expand('%:p')
  local utils = require('taghop.utils')
  local config = require('taghop').config

  for _, file in ipairs(M.tagged_files) do
    if file == current_file then
      vim.notify("File already tagged!", vim.log.levels.INFO)
      return
    end
  end

  if #M.tagged_files >= config.max_tags then
    vim.notify("Maximum tags reached (" .. config.max_tags .. "). Untag a file first.", vim.log.levels.WARN)
    return
  end

  table.insert(M.tagged_files, current_file)
  vim.notify("Tagged: " .. utils.get_display_name(current_file, true), vim.log.levels.INFO)

  if config.persistent then
    require('taghop.persistence').save_tags()
  end
end

function M.untag_current_file()
  local current_file = vim.fn.expand('%:p')
  local utils = require('taghop.utils')
  local config = require('taghop').config

  for i, file in ipairs(M.tagged_files) do
    if file == current_file then
      table.remove(M.tagged_files, i)
      vim.notify("Untagged: " .. utils.get_display_name(current_file, true), vim.log.levels.INFO)

      if config.persistent then
        require('taghop.persistence').save_tags()
      end

      return
    end
  end
  
  vim.notify("Current file is not tagged!", vim.log.levels.WARN)
end

function M.jump_to_file(index)
  if M.tagged_files[index] then
    vim.cmd('q')
    vim.cmd('edit ' .. vim.fn.fnameescape(M.tagged_files[index]))
  else
    vim.notify("Invalid file index", vim.log.levels.ERROR)
  end
end

function M.untag_file_by_index(index)
  local utils = require('taghop.utils')
  local config = require('taghop').config

  if M.tagged_files[index] then
    local file = M.tagged_files[index]
    table.remove(M.tagged_files, index)

    vim.cmd('q')
    require('taghop.ui').list_tagged_files()

    vim.notify("Untagged: " .. utils.get_display_name(file, true), vim.log.levels.INFO)

    if config.persistent then
      require('taghop.persistence').save_tags()
    end
  else
    vim.notify("Invalid file index", vim.log.levels.ERROR)
  end
end

return M
