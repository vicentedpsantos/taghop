local M = {}

function M.get_display_name(file_path, short_only)
  local filename = vim.fn.fnamemodify(file_path, ':t')
  local short_path = vim.fn.fnamemodify(file_path, ':~:.')
  
  if short_only then
    return short_path
  else
    return filename .. " (" .. short_path .. ")"
  end
end

return M
