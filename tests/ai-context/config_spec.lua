describe('ai-context.config', function()
  local config

  before_each(function()
    package.loaded['ai-context.config'] = nil
    config = require('ai-context.config')
  end)

  it('exposes defaults', function()
    assert.equals('<leader>cc', config.defaults.keymap)
    assert.is_false(config.defaults.override_yank)
  end)

  it('initializes options with defaults', function()
    assert.equals(config.defaults.keymap, config.options.keymap)
    assert.equals(config.defaults.override_yank, config.options.override_yank)
  end)

  it('merges user opts over defaults', function()
    config.setup({ keymap = '<leader>ai' })
    assert.equals('<leader>ai', config.options.keymap)
    assert.is_false(config.options.override_yank)
  end)

  it('accepts override_yank', function()
    config.setup({ override_yank = true })
    assert.is_true(config.options.override_yank)
    assert.equals('<leader>cc', config.options.keymap)
  end)

  it('handles nil opts', function()
    config.setup()
    assert.equals('<leader>cc', config.options.keymap)
  end)

  it('does not mutate defaults across setups', function()
    config.setup({ keymap = 'x' })
    config.setup()
    assert.equals('<leader>cc', config.defaults.keymap)
  end)
end)
