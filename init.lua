local M = {}

local config = require('ai-context.config')
local copy = require('ai-context.copy')

function M.setup(opts)
  config.setup(opts)

  vim.api.nvim_create_user_command('AIContextCopy', function()
    copy.copy_selection()
  end, { range = true, desc = 'Copy selection as AI context' })

  vim.keymap.set('x', config.options.keymap, function()
    copy.copy_selection()
  end, { desc = 'Copy selection as AI context', silent = true })

  if config.options.override_yank then
    vim.keymap.set('x', 'y', function()
      copy.copy_selection()
      vim.cmd('normal! y')
    end, { desc = 'Yank + AI context', silent = true })
  end
end

M.copy_selection = copy.copy_selection

return M
