describe('ai-context.copy', function()
  local copy
  local orig_selection
  local orig_notify
  local notified

  before_each(function()
    package.loaded['ai-context.selection'] = nil
    package.loaded['ai-context.copy'] = nil
    orig_selection = require('ai-context.selection')
    orig_notify = vim.notify
    notified = {}
    vim.notify = function(msg, level)
      table.insert(notified, { msg = msg, level = level })
    end
    vim.fn.setreg('+', '')
    vim.fn.setreg('"', '')
  end)

  after_each(function()
    vim.notify = orig_notify
    package.loaded['ai-context.selection'] = orig_selection
    package.loaded['ai-context.copy'] = nil
  end)

  local function stub_selection(sel)
    package.loaded['ai-context.selection'] = {
      get_visual_selection = function()
        return sel
      end,
    }
    package.loaded['ai-context.copy'] = nil
    copy = require('ai-context.copy')
  end

  it('warns and returns when no selection', function()
    stub_selection(nil)
    copy.copy_selection()
    assert.equals(1, #notified)
    assert.equals(vim.log.levels.WARN, notified[1].level)
    assert.matches('no selection', notified[1].msg)
    assert.equals('', vim.fn.getreg('+'))
  end)

  it('writes formatted payload to + and " registers', function()
    local tmp = vim.fn.tempname() .. '.lua'
    vim.fn.writefile({ 'line1', 'line2', 'line3' }, tmp)
    vim.cmd('edit ' .. tmp)
    vim.bo.filetype = 'lua'

    stub_selection({
      text = 'line1\nline2',
      start_line = 1,
      end_line = 2,
    })

    copy.copy_selection()

    local plus = vim.fn.getreg('+')
    local unnamed = vim.fn.getreg('"')

    assert.equals(plus, unnamed)
    assert.matches('```lua', plus)
    assert.matches('line1\nline2', plus)
    assert.matches('1%-2', plus)
    assert.truthy(plus:match('`[^`]+:1%-2`'))

    vim.fn.delete(tmp)
  end)

  it('uses single line in range when start == end', function()
    local tmp = vim.fn.tempname() .. '.lua'
    vim.fn.writefile({ 'only' }, tmp)
    vim.cmd('edit ' .. tmp)
    vim.bo.filetype = 'lua'

    stub_selection({
      text = 'only',
      start_line = 7,
      end_line = 7,
    })

    copy.copy_selection()
    local plus = vim.fn.getreg('+')
    assert.truthy(plus:match('`[^`]+:7`'))
    assert.is_nil(plus:match('7%-7'))

    vim.fn.delete(tmp)
  end)

  it('emits info notify on copy', function()
    local tmp = vim.fn.tempname() .. '.lua'
    vim.fn.writefile({ 'x' }, tmp)
    vim.cmd('edit ' .. tmp)
    vim.bo.filetype = 'lua'

    stub_selection({ text = 'x', start_line = 1, end_line = 1 })
    copy.copy_selection()

    assert.equals(1, #notified)
    assert.equals(vim.log.levels.INFO, notified[1].level)
    assert.matches('copied', notified[1].msg)

    vim.fn.delete(tmp)
  end)
end)
