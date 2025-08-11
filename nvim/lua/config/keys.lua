local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Setup vimspector keys for Rust
local vimspector_keys = {
  { mode = "n", lhs = "<F9>", rhs = "<cmd>call vimspector#Launch()<CR>" },
  { mode = "n", lhs = "<F5>", rhs = "<cmd>call vimspector#StepOver()<CR>" },
  { mode = "n", lhs = "<F8>", rhs = "<cmd>call vimspector#Reset()<CR>" },
  { mode = "n", lhs = "<F11>", rhs = "<cmd>call vimspector#StepOver()<CR>" },
  { mode = "n", lhs = "<F12>", rhs = "<cmd>call vimspector#StepOut()<CR>" },
  { mode = "n", lhs = "<F10>", rhs = "<cmd>call vimspector#StepInto()<CR>" },
  { mode = "n", lhs = "<leader>DB",  rhs = ":call vimspector#ToggleBreakpoint()<CR>" },
  { mode = "n", lhs = "<leader>DW",  rhs = ":call vimspector#AddWatch()<CR>" },
  { mode = "n", lhs = "<leader>DE",  rhs = ":call vimspector#Evaluate()<CR>" },
}

-- Setup vim-go keys for Go
local vimgo_keys = {
  { mode = "n", lhs = "<F9>", rhs = ":GoDebugStart<CR>" },       -- launch/start debug session
  { mode = "n", lhs = "<F5>", rhs = ":GoDebugNext<CR>" },        -- step over
  { mode = "n", lhs = "<F8>", rhs = ":GoDebugStop<CR>" },        -- reset/stop debug session
  { mode = "n", lhs = "<F11>", rhs = ":GoDebugNext<CR>" },       -- step over (same as F5)
  { mode = "n", lhs = "<F12>", rhs = ":GoDebugStepOut<CR>" },    -- step out (vim-go may not have this, fallback to stop)
  { mode = "n", lhs = "<F10>", rhs = ":GoDebugStep<CR>" },       -- step into
  { mode = "n", lhs = "<leader>DB",  rhs = ":GoDebugBreakpoint<CR>" }, -- toggle breakpoint
  -- vim-go does not have AddWatch or Evaluate equivalents, so omit those or map to echo for now:
  { mode = "n", lhs = "<leader>DW",  rhs = ":echo 'AddWatch not supported in vim-go'<CR>" },
  { mode = "n", lhs = "<leader>DE",  rhs = ":echo 'Evaluate not supported in vim-go'<CR>" },
}

local function set_mappings_for_buffer(keys)
  local bufnr = vim.api.nvim_get_current_buf()
  for _, key in ipairs(keys) do
    vim.keymap.set(key.mode, key.lhs, key.rhs, { noremap = true, silent = true, buffer = bufnr })
  end
end

-- Create autocmd group
local group = vim.api.nvim_create_augroup("DebugKeymaps", { clear = true })

-- Rust FileType autocmd for vimspector keys
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "rust",
  callback = function()
    set_mappings_for_buffer(vimspector_keys)
  end,
})

-- Go FileType autocmd for vim-go keys
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = "go",
  callback = function()
    set_mappings_for_buffer(vimgo_keys)
  end,
})

-- quickly comment/uncomment blocks of code.

local comment_delims = {
  tf = "// ",
  c = "// ",
  cpp = "// ",
  php = "// ",
  java = "// ",
  scala = "// ",
  go = "// ",
  javascript = "// ",
  groovy = "// ",
  rust = "// ",
  sh = "# ",
  python = "# ",
  ruby = "# ",
  bash = "# ",
  yaml = "# ",
  dockerfile = "# ",
  conf = "# ",
  make = "# ",
  sshconfig = "# ",
  dosini = ";; ",
  scheme = ";; ",
  lisp = ";; ",
  clojure = ";; ",
  gitconfig = ";; ",
  sql = "-- ",
  elm = "-- ",
  haskell = "-- ",
  erlang = "%% ",
  vim = '" ',
}

local function get_comment_delim()
  local ft = vim.bo.filetype
  return comment_delims[ft] or (vim.bo.commentstring:gsub("%%s", "") or "# ")
end

local function comment_line()
  local delim = get_comment_delim()
  vim.api.nvim_feedkeys('^i' .. delim, 'n', false)
end

local function uncomment_line()
  -- Delete comment delimiter at the beginning of line
  local delim = get_comment_delim()
  local pattern = "^%s*" .. vim.pesc(delim)
  vim.cmd(string.format("silent! execute 'normal! 0' | silent! s/%s//", pattern))
end

local function comment_visual()
  local delim = get_comment_delim()
  vim.cmd("'<,'>normal! I" .. delim)
end

-- Normal mode mappings
vim.keymap.set('n', '<leader>cc', comment_line, { desc = 'Comment line' })
vim.keymap.set('n', '<leader>uc', uncomment_line, { desc = 'Uncomment line' })

-- Visual mode mapping
vim.keymap.set('v', '<leader>cc', comment_visual, { desc = 'Comment selection' })

-- Diagnostic key mappings (global)
vim.keymap.set('n', '<leader>ds', vim.diagnostic.open_float, { desc='Show diagnostic float', noremap=true, silent=true })
