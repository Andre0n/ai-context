local plenary_dirs = {
  os.getenv('PLENARY_PATH'),
  vim.fn.stdpath('data') .. '/lazy/plenary.nvim',
  vim.fn.stdpath('data') .. '/site/pack/vendor/start/plenary.nvim',
  vim.fn.stdpath('data') .. '/plugged/plenary.nvim',
  '/tmp/plenary.nvim',
}

local function ensure_plenary()
  for _, dir in ipairs(plenary_dirs) do
    if dir and vim.fn.isdirectory(dir) == 1 then
      vim.opt.rtp:prepend(dir)
      return
    end
  end
  local target = '/tmp/plenary.nvim'
  if vim.fn.isdirectory(target) == 0 then
    vim.fn.system({
      'git',
      'clone',
      '--depth=1',
      'https://github.com/nvim-lua/plenary.nvim',
      target,
    })
  end
  vim.opt.rtp:prepend(target)
end

ensure_plenary()

vim.opt.rtp:prepend(vim.fn.getcwd())
vim.cmd('runtime plugin/plenary.vim')
