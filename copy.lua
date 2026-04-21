local M = {}

local selection = require 'ai-context.selection'
local util = require 'ai-context.util'

function M.copy_selection()
  local sel = selection.get_visual_selection()
  if not sel then
    vim.notify('ai-context: no selection', vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local path = util.relative_path(bufnr)
  local lang = vim.bo[bufnr].filetype or ''
  local range = util.format_range(sel.start_line, sel.end_line)

  local payload = string.format(
    '`%s:%s`\n```%s\n%s\n```\n',
    path,
    range,
    lang,
    sel.text
  )

  vim.fn.setreg('+', payload)
  vim.fn.setreg('"', payload)
  vim.notify(
    string.format('ai-context: copied %s:%s', path, range),
    vim.log.levels.INFO
  )
end

return M
