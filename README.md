# TagHop.nvim

A Neovim plugin that lets you quickly jump between "tagged" files in your current workflow.

## Features

- Tag up to 10 files as part of your current work context
- List all tagged files in a floating window
- Jump to any tagged file with a single keypress
- Untag files from the list or while viewing them
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
  max_tags = 10, -- Maximum number of files that can be tagged (default: 10)
})
```

## Usage

TagHop provides the following commands:

- `:TagHopTag` - Tag the current file
- `:TagHopUntag` - Untag the current file
- `:TagHopList` - Open the list of tagged files

### Keymaps

You might want to add these keymaps to your config:

```lua
vim.keymap.set('n', '<leader>tt', ':TagHopTag<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tu', ':TagHopUntag<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tl', ':TagHopList<CR>', { noremap = true, silent = true })
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

## License

MIT
