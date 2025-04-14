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

function M.simple_hash(str)
  -- Simple djb2 hash algorithm
  local hash = 5381
  for i = 1, #str do
    hash = ((hash * 33) + string.byte(str, i)) % 4294967296
  end
  return tostring(hash)
end

return M
