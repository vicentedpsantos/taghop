local M = {}

M.namespace = nil
M.sign_name = "TagHopTag"
M.enabled = true

function M.setup()
  M.namespace = vim.api.nvim_create_namespace("taghop")

  vim.fn.sign_define(M.sign_name, {
    text = "🏷️", -- Tag emoji
    texthl = "TagHopSign",
    linehl = "",
    numhl = ""
  })

  vim.cmd([[
    highlight default TagHopSign ctermfg=142 guifg=#b8bb26
    highlight default TagHopStatusLine ctermfg=142 guifg=#b8bb26 gui=bold
  ]])

  vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    callback = function()
      M.update_current_buffer()
    end,
  })
end

function M.update_current_buffer()
  if not M.enabled then
    return
  end

  local tags = require('taghop.tags')
  local current_file = vim.fn.expand('%:p')
  local is_tagged = false

  for _, file in ipairs(tags.tagged_files) do
    if file == current_file then
      is_tagged = true
      break
    end
  end

  local bufnr = vim.api.nvim_get_current_buf()

  vim.fn.sign_unplace("", {buffer = bufnr})

  if is_tagged then
    vim.fn.sign_place(0, "", M.sign_name, bufnr, {lnum = 1})

    pcall(vim.api.nvim_buf_set_var, bufnr, "taghop_tagged", true)
  else
    pcall(vim.api.nvim_buf_del_var, bufnr, "taghop_tagged")
  end
end

function M.update_all_buffers()
  if not M.enabled then
    return
  end

  local buffers = vim.api.nvim_list_bufs()
  local tags = require('taghop.tags')

  for _, bufnr in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, 'buflisted') then
      local buf_name = vim.api.nvim_buf_get_name(bufnr)

      if buf_name ~= "" then
        local is_tagged = false

        for _, file in ipairs(tags.tagged_files) do
          if file == buf_name then
            is_tagged = true
            break
          end
        end

        vim.fn.sign_unplace("", {buffer = bufnr})

        if is_tagged then
          vim.fn.sign_place(0, "", M.sign_name, bufnr, {lnum = 1})
          pcall(vim.api.nvim_buf_set_var, bufnr, "taghop_tagged", true)
        else
          pcall(vim.api.nvim_buf_del_var, bufnr, "taghop_tagged")
        end
      end
    end
  end
end

function M.enable()
  M.enabled = true
  M.update_current_buffer()
end

function M.disable()
  M.enabled = false

  vim.fn.sign_unplace("")
end

function M.toggle()
  if M.enabled then
    M.disable()
  else
    M.enable()
  end
end

function M.statusline()
  local bufnr = vim.api.nvim_get_current_buf()

  local ok, tagged = pcall(vim.api.nvim_buf_get_var, bufnr, "taghop_tagged")
  if ok and tagged then
    return "%#TagHopStatusLine#[Tagged]%*"
  else
    return ""
  end
end

return M
