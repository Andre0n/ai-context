local M = {}

function M.get_visual_selection()
  local mode = vim.fn.mode()
  local is_visual = mode == 'v' or mode == 'V' or mode == '\22'

  local start_pos, end_pos
  if is_visual then
    vim.cmd 'normal! "\27"'
    start_pos = vim.fn.getpos "'<"
    end_pos = vim.fn.getpos "'>"
  else
    start_pos = vim.fn.getpos "'<"
    end_pos = vim.fn.getpos "'>"
  end

  local s_line, s_col = start_pos[2], start_pos[3]
  local e_line, e_col = end_pos[2], end_pos[3]

  if s_line == 0 or e_line == 0 then
    return nil
  end

  local lines = vim.fn.getline(s_line, e_line)
  if type(lines) == 'string' then
    lines = { lines }
  end
  if #lines == 0 then
    return nil
  end

  local last_mode = vim.fn.visualmode()
  if last_mode ~= 'V' then
    lines[#lines] = string.sub(lines[#lines], 1, e_col)
    lines[1] = string.sub(lines[1], s_col)
  end

  return {
    text = table.concat(lines, '\n'),
    start_line = s_line,
    end_line = e_line,
  }
end

return M
