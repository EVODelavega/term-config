-- Telescope
vim.api.nvim_set_keymap('n','<leader>ff','<cmd>Telescope find_files<CR>',{noremap=true,silent=true})
vim.api.nvim_set_keymap('n','<leader>fg','<cmd>Telescope live_grep<CR>',{noremap=true,silent=true})
vim.api.nvim_set_keymap('n','<leader>fb','<cmd>Telescope buffers<CR>',{noremap=true,silent=true})
-- Nvim-tree toggle
vim.api.nvim_set_keymap('n','<leader>e','<cmd>NvimTreeToggle<CR>',{noremap=true,silent=true})

-- Gitsigns
require('gitsigns').setup()

-- Comment.nvim
require('Comment').setup()

-- Lualine for statusline
require('lualine').setup {
  options = { theme = 'gruvbox' }
}
