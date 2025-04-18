local M = {}

function M.get_project_root()
  local cwd = vim.fn.getcwd()

  -- Try to find Git directory
  local git_dir = vim.fn.finddir('.git', cwd .. ';')
  if git_dir ~= "" then
    return vim.fn.fnamemodify(git_dir, ':h')
  end

  -- If no Git directory, use CWD as project root
  return cwd
end

function M.get_project_id(project_path)
  local project_name = vim.fn.fnamemodify(project_path, ':t')

  local utils = require('taghop.utils')
  local path_hash = utils.simple_hash(project_path)

  return project_name .. "_" .. path_hash
end

function M.get_storage_path()
  local data_path = vim.fn.stdpath('data')
  local taghop_dir = data_path .. '/taghop'

  if vim.fn.isdirectory(taghop_dir) == 0 then
    vim.fn.mkdir(taghop_dir, 'p')
  end

  -- Get absolute project root path
  local project_root = M.get_project_root()

  -- Create a unique but readable project identifier
  local project_id = M.get_project_id(project_root)

  return taghop_dir .. '/' .. project_id .. '.json'
end

function M.save_tags()
  if not require('taghop').config.persistent then
    return
  end
  
  local tags = require('taghop.tags')
  local storage_path = M.get_storage_path()
  
  local file = io.open(storage_path, 'w')
  if not file then
    vim.notify('TagHop: Failed to save tags', vim.log.levels.ERROR)
    return
  end
  
  local json_str = vim.fn.json_encode(tags.tagged_files)
  file:write(json_str)
  file:close()
end

function M.load_tags()
  local storage_path = M.get_storage_path()
  local tags = require('taghop.tags')

  tags.tagged_files = {}

  local file = io.open(storage_path, 'r')
  if not file then
    return
  end

  local content = file:read('*all')
  file:close()

  if content and content ~= '' then
    local success, decoded = pcall(vim.fn.json_decode, content)
    if success and type(decoded) == 'table' then
      -- Check if files still exist before restoring tags
      for _, file_path in ipairs(decoded) do
        if vim.fn.filereadable(file_path) == 1 then
          table.insert(tags.tagged_files, file_path)
        end
      end
    end
  end
end

return M
