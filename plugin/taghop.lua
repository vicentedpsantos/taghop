if vim.fn.has('nvim-0.7.0') == 0 then
  vim.api.nvim_err_writeln('TagHop requires at least Neovim v0.7.0')
  return
end

require('taghop')
