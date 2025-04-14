local M = {}

function M.get_project_root()
  local cwd = vim.fn.getcwd()

  local git_dir = vim.fn.finddir('.git', cwd .. ';')
  if git_dir ~= "" then
    return vim.fn.fnamemodify(git_dir, ':h')
  end

  return cwd
end

function M.get_storage_path()
  local data_path = vim.fn.stdpath('data')
  local taghop_dir = data_path .. '/taghop'

  if vim.fn.isdirectory(taghop_dir) == 0 then
    vim.fn.mkdir(taghop_dir, 'p')
  end

  local project_root = M.get_project_root()
  local project_id = vim.fn.substitute(project_root, '/', '_', 'g')
  project_id = vim.fn.substitute(project_id, ':', '_', 'g')

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

  local file = io.open(storage_path, 'r')
  if not file then
    return
  end

  local content = file:read('*all')
  file:close()

  if content and content ~= '' then
    local success, decoded = pcall(vim.fn.json_decode, content)
    if success and type(decoded) == 'table' then
      tags.tagged_files = decoded
    end
  end
end

return M
