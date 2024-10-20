vim.g.python3_host_prog=vim.fn.expand("~/.virtualenvs/neovim/bin/python3") -- Pointing Neovim at Virtual Environment
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup("plugins", {
  change_detection = {
    notify = false,
  },
})

require('calanuzao.globals')
require('calanuzao.remaps')
require('calanuzao.options')
vim.cmd("colorscheme tokyonight")
vim.cmd('hi IlluminatedWordText guibg=none gui=underline')
vim.cmd('hi IlluminatedWordRead guibg=none gui=underline')
vim.cmd('hi IlluminatedWordWrite guibg=none gui=underline')

-- Arduino Configuration
vim.cmd([[
  command! TestAsync execute 'AsyncRun echo "AsyncRun is working!"'

  command! ArduinoVerify execute 'AsyncRun -raw -post=checktime echo "Starting verify..." && arduino-cli compile --fqbn esp32:esp32:esp32s3 -v %:p:h'
  command! ArduinoUpload execute 'AsyncRun -raw -post=checktime echo "Starting upload..." && arduino-cli upload -p /dev/cu.usbmodem1101 --fqbn esp32:esp32:esp32s3 -v %:p:h'
  
  augroup AsyncRunQuickfix
    autocmd!
    autocmd User AsyncRunStart call asyncrun#quickfix_toggle(8, 1)
  augroup END
  
  let g:asyncrun_status = ''
  set statusline+=%{g:asyncrun_status}
]])