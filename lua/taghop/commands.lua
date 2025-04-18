local M = {}

function M.setup()
  vim.cmd([[
    command! TagHopTag lua require('taghop').tag_current_file()
    command! TagHopUntag lua require('taghop').untag_current_file()
    command! TagHopList lua require('taghop').list_tagged_files()
    command! TagHopToggleIndicators lua require('taghop.visual').toggle()
  ]])

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      if require('taghop').config.persistent then
        require('taghop.persistence').save_tags()
      end
    end,
  })

  -- Update visual indicators when switching between buffers
  if require('taghop').config.show_indicators then
    vim.api.nvim_create_autocmd({"BufEnter"}, {
      callback = function()
        require('taghop.visual').update_current_buffer()
      end,
    })
  end
end

return M
