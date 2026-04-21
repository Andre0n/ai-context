local M = {}

M.defaults = {
  keymap = '<leader>cc',
  override_yank = false,
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})
end

return M
