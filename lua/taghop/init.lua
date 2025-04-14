local M = {}

M.config = {
  max_tags = 10,
  persistent = false
}

function M.setup(opts)
  opts = opts or {}

  if opts.max_tags then
    M.config.max_tags = opts.max_tags
  end

  if opts.persistent ~= nil then
    M.config.persistent = opts.persistent
  end

  require('taghop.commands').setup()

  if M.config.persistent then
    require('taghop.persistence').load_tags()
  end

  return M
end

function M.tag_current_file()
  require('taghop.tags').tag_current_file()
end

function M.untag_current_file()
  require('taghop.tags').untag_current_file()
end

function M.list_tagged_files()
  require('taghop.ui').list_tagged_files()
end

function M.jump_to_file(index)
  require('taghop.tags').jump_to_file(index)
end

function M.untag_file_by_index(index)
  require('taghop.tags').untag_file_by_index(index)
end

return M
