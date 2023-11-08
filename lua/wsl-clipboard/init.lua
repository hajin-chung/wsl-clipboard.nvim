local M = {}

-- copied from 
--   https://neovim.discourse.group/t/function-that-return-visually-selected-text/1601
local function get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return table.concat(lines, '\n')
end

M.setup = function()
  local clipboard_group = vim.api.nvim_create_augroup('ClipBoard', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      local selection = get_visual_selection()
      os.execute(string.format('echo "%s" | clip.exe', selection))
      vim.print("copied to clipboard")
    end,
    group = clipboard_group
  })
end

return M
