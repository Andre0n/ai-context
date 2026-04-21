# ai-context

Neovim plugin to copy visual selections pre-formatted as context for LLMs (Claude, ChatGPT, etc.).

The selection is copied to the `+` and `"` registers in the format:

````
`path/to/file.lua:12-34`
```lua
-- selected code
```
````

Paste straight into chat without typing the path or picking the language.

## Installation

### lazy.nvim

```lua
{
  'Andre0n/ai-context',
  config = function()
    require('ai-context').setup()
  end,
}
```

### packer.nvim

```lua
use {
  'Andre0n/ai-context',
  config = function()
    require('ai-context').setup()
  end,
}
```

## Usage

1. Enter visual mode (`v`, `V`, `<C-v>`)
2. Select the code
3. `<leader>cc` (default) or `:AIContextCopy`

Paste wherever you want. Path relative to `cwd`, language from `filetype`, line range included.

## Configuration

```lua
require('ai-context').setup({
  keymap = '<leader>cc',   -- visual mode shortcut
  override_yank = false,   -- if true, `y` also copies formatted
})
```

### Defaults

| Option | Type | Default |
|--------|------|---------|
| `keymap` | `string` | `'<leader>cc'` |
| `override_yank` | `boolean` | `false` |

## Commands

| Command | Description |
|---------|-------------|
| `:AIContextCopy` | Copy formatted visual selection |

## API

```lua
require('ai-context').copy_selection()
```

## Structure

```
ai-context/
├── init.lua       -- setup, command, keymap
├── config.lua     -- defaults and option merging
├── copy.lua       -- builds payload and writes to registers
├── selection.lua  -- extracts text from visual selection
└── util.lua       -- relative path, range formatting
```

## License

MIT
