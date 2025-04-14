local M = {}

function M.setup()
  vim.cmd([[
    command! TagHopTag lua require('taghop').tag_current_file()
    command! TagHopUntag lua require('taghop').untag_current_file()
    command! TagHopList lua require('taghop').list_tagged_files()
  ]])

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      if require('taghop').config.persistent then
        require('taghop.persistence').save_tags()
      end
    end,
  })
end

return M
