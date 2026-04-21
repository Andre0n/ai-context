local util = require('ai-context.util')

describe('ai-context.util', function()
  describe('format_range', function()
    it('returns single line as string', function()
      assert.equals('12', util.format_range(12, 12))
    end)

    it('returns range when lines differ', function()
      assert.equals('12-34', util.format_range(12, 34))
    end)

    it('handles line 1', function()
      assert.equals('1', util.format_range(1, 1))
      assert.equals('1-5', util.format_range(1, 5))
    end)
  end)

  describe('relative_path', function()
    local tmpfile
    local bufnr

    before_each(function()
      tmpfile = vim.fn.tempname()
      vim.fn.writefile({ 'x' }, tmpfile)
      vim.cmd('edit ' .. tmpfile)
      bufnr = vim.api.nvim_get_current_buf()
    end)

    after_each(function()
      vim.cmd('bdelete! ' .. bufnr)
      vim.fn.delete(tmpfile)
    end)

    it('returns [No Name] for unnamed buffer', function()
      local nobuf = vim.api.nvim_create_buf(false, true)
      assert.equals('[No Name]', util.relative_path(nobuf))
      vim.api.nvim_buf_delete(nobuf, { force = true })
    end)

    it('returns path relative to cwd when inside cwd', function()
      local cwd = vim.fn.tempname()
      vim.fn.mkdir(cwd, 'p')
      local file = cwd .. '/sub/foo.lua'
      vim.fn.mkdir(cwd .. '/sub', 'p')
      vim.fn.writefile({ '' }, file)

      local prev = vim.loop.cwd()
      vim.cmd('cd ' .. cwd)
      vim.cmd('edit ' .. file)
      local b = vim.api.nvim_get_current_buf()

      assert.equals('sub/foo.lua', util.relative_path(b))

      vim.cmd('cd ' .. prev)
      vim.cmd('bdelete! ' .. b)
      vim.fn.delete(cwd, 'rf')
    end)

    it('returns ~ path when outside cwd', function()
      local home = vim.fn.expand('$HOME')
      local path = home .. '/.ai_context_test_file.lua'
      vim.fn.writefile({ '' }, path)

      local other = vim.fn.tempname()
      vim.fn.mkdir(other, 'p')
      local prev = vim.loop.cwd()
      vim.cmd('cd ' .. other)

      vim.cmd('edit ' .. path)
      local b = vim.api.nvim_get_current_buf()
      local result = util.relative_path(b)

      assert.truthy(result:match('^~/'))

      vim.cmd('cd ' .. prev)
      vim.cmd('bdelete! ' .. b)
      vim.fn.delete(path)
      vim.fn.delete(other, 'rf')
    end)
  end)
end)
