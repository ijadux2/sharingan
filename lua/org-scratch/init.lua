local M = {}

function M.setup()
  vim.api.nvim_create_user_command('Org', function()
    M.open_scratch()
  end, {
    desc = 'Open scratch buffer',
  })

  vim.api.nvim_create_user_command('OrgFile', function()
    M.open_file_scratch()
  end, {
    desc = 'Open scratch file with auto-detection',
  })

  vim.api.nvim_create_user_command('OrgSet', function()
    vim.opt_local.filetype = 'org'
  end, {
    desc = 'Set current buffer to org mode',
  })

  vim.keymap.set('n', '<leader>oo', function()
    M.open_scratch()
  end, { desc = 'Open scratch buffer' })

  vim.keymap.set('n', '<leader>of', function()
    M.open_file_scratch()
  end, { desc = 'Open scratch file' })
end

function M.open_scratch()
  local scratch = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_buf_set_name(scratch, 'scratch')
  vim.api.nvim_set_current_buf(scratch)

  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
end

function M.open_file_scratch()
  local scratch_dir = vim.fn.stdpath('data') .. '/scratch'
  if vim.fn.isdirectory(scratch_dir) == 0 then
    vim.fn.mkdir(scratch_dir, 'p')
  end

  local timestamp = os.date('%Y%m%d_%H%M%S')
  local filename = scratch_dir .. '/scratch_' .. timestamp .. '.org'

  vim.cmd('edit ' .. filename)
  vim.opt_local.wrap = true
  vim.opt_local.linebreak = true
end

return M
