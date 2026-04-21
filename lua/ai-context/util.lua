local M = {}

function M.relative_path(bufnr)
  local full = vim.api.nvim_buf_get_name(bufnr)
  if full == '' then
    return '[No Name]'
  end
  local cwd = vim.loop.cwd() or ''
  if cwd ~= '' and vim.startswith(full, cwd) then
    return full:sub(#cwd + 2)
  end
  return vim.fn.fnamemodify(full, ':~')
end

function M.format_range(start_line, end_line)
  if start_line == end_line then
    return tostring(start_line)
  end
  return start_line .. '-' .. end_line
end

return M
