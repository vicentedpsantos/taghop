# TagHop.nvim

A lightweight Neovim plugin for developers that lets you tag and quickly navigate between files in your current workflow. TagHop allows you to mark up to 10 files as part of your active context and seamlessly jump between them with minimal keystrokes.

## Features

- Tag up to 10 files as part of your current work context
- List all tagged files in a floating window
- Jump to any tagged file with a single keypress
- Untag files from the list or while viewing them
- Optional persistence of tagged files per project
- Visual indicators for tagged files
- Simple and lightweight

## Installation

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'vicentedpsantos/taghop.nvim',
  config = function()
    require('taghop').setup()
  end
}
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'vicentedpsantos/taghop.nvim',
  config = function()
    require('taghop').setup()
  end
}
```

## Configuration

TagHop works out of the box, but you can customize it:

```lua
require('taghop').setup({
  max_tags = 10,        -- Maximum number of files that can be tagged (default: 10)
  persistent = false,   -- Whether to save tagged files between sessions (default: false)
  show_indicators = true -- Show visual indicators for tagged files (default: true)
})
```

### Persistence

When `persistent = true`, TagHop will:
- Save your tagged files when you tag/untag files and when you exit Neovim
- Restore your tagged files when you start Neovim again in the same project
- Organize saved tags by project (based on Git root or current working directory)

### Visual Indicators

When `show_indicators = true`, TagHop will:
- Display a tag icon in the sign column for tagged files
- Add a "[Tagged]" label to the statusline (must be added to your statusline configuration)

To add the tagged indicator to your statusline, insert this in your statusline setup:

```lua
-- For lualine
require('lualine').setup({
  sections = {
    lualine_c = {
      -- other components...
      { require('taghop.visual').statusline }
    }
  }
})

-- For a simple statusline
vim.opt.statusline = "%f %m %r %h %w %{%v:lua.require('taghop.visual').statusline()%} %= %l,%c %P"
```

## Usage

TagHop provides the following commands:

- `:TagHopTag` - Tag the current file
- `:TagHopUntag` - Untag the current file
- `:TagHopList` - Open the list of tagged files
- `:TagHopToggleIndicators` - Toggle visual indicators on/off

### Keymaps

You might want to add these keymaps to your config:

```lua
vim.keymap.set('n', '<leader>tt', ':TagHopTag<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tu', ':TagHopUntag<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tl', ':TagHopList<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ti', ':TagHopToggleIndicators<CR>', { noremap = true, silent = true })
```

### File List Navigation

When the file list is open:
- Press `1-9` (or `0` for the 10th file) to jump to a tagged file
- Press `u` followed by `1-9` (or `0` for the 10th file) to untag a file
- Press `q` or `<Esc>` to close the list

## Example Workflow

1. Open a file you're working on and tag it: `:TagHopTag`
2. Navigate to other related files and tag them as well
3. When you need to switch between these files, use `:TagHopList`
4. Select the file you want to jump to by pressing its number
5. When you're done with a file, untag it with `:TagHopUntag`
6. If persistence is enabled, your tagged files will be available the next time you open Neovim in the same project

## License

MIT
