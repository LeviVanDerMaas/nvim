-- Set up autocommands and a global variable to automatically update a counter
-- that tracks the number of modified buffers. 
-- When it does get fixed please test if 'buf' actually gives the buf that fired the event
-- rather than the active buf by using 
-- ':lua vim.api.nvim_create_autocmd("BufModifiedSet", { callback = function (event) print(vim.inspect(event)) end })',
-- opening a second buffer, modifying it, switching back, then using :wa 
local augroup = vim.api.nvim_create_augroup("core.count_buf_modified", { clear = true })

local function update_counter = function (event)
  -- If the flag was
end

vim.api.nvim_create_autocmd("BufModifiedSet", {
  group = augroup,
  callback = print
}) 
