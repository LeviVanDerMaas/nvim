-- SEARCH HIGHLIGHTS
vim.keymap.set('', '<leader>h',
  function ()
    if vim.v.hlsearch == 0 then
    -- Setting this also sets v:hlsearch to 1.
      vim.o.hlsearch = true
    else
      -- Disable highlights but not 'hlsearch' option
      vim.v.hlsearch = 0
    end
  end,
  { silent = true; desc = 'Toggle search highlights' }
)

vim.keymap.set('', '<leader>H',
  function ()
    vim.o.hlsearch = not vim.o.hlsearch
    local hl_str = (vim.o.hlsearch and "Enabled") or "Disabled"
    vim.notify(string.format("%s search highlighting ('hlsearch')"), hl_str)
  end,
  { desc = "Toggle 'hlsearch' option" }
)

-- TEXT OBJECTS:
vim.keymap.set({'v', 'o'}, 'aa',
  function()
    vim.cmd [[
      exec "normal! \e"
      normal! gg0vG$
    ]]
  end,
  { silent = true, desc = '[a]ll' }
)

vim.keymap.set({'v', 'o'}, 'ia',
  function ()
    vim.cmd [[
      exec "normal! \e"
      normal! gg0
      call search('\S', 'c')
      normal! 0vG$
      call search('\S', 'bc')
    ]]
  end,
  { silent = true, desc = '[a]ll, trim blank lines' }
)
