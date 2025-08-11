require("mason").setup()
-- ensure LSP's are installed
require("mason-lspconfig").setup({
    -- ensure_installed = { "taplo", "pyright", "marksman", "bash-language-server", "lua-language-server", "eslint-lsp", "eslint_d" }
    -- for some reason, eslint-lsp doesn't work woth ensure_installed.
    ensure_installed = { "taplo", "pyright", "marksman", "bash-language-server", "lua-language-server" }
})

local lspconfig = require("lspconfig")
lspconfig.gopls.setup {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
        },
    }
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Toml
lspconfig.taplo.setup {
    filetypes = { "toml" },
    on_attach = function(client, bufnr)
        vim.bo[bufnr].tabstop = 2
        vim.bo[bufnr].shiftwidth = 2
        vim.bo[bufnr].expandtab = true
    end,
    capabilities = capabilities,
}

local attach_cb = function(cl, bn)
    local opts = { noremap = true, silent = true, buffer = bn }
    vim.keymap.set('n', '<leader>LL', vim.cmd.LspLog, opts)
end

-- Lua, special case because nvim use.
lspconfig.lua_ls.setup = {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = { 'vim' } }, -- Stop "undefined global 'vim'" warning
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
    capabilities = capabilities,
    on_attach = function(cl, bn)
        local opts = { noremap = true, silent = true, buffer = bn }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        attach_cb(cl, bn)
    end,
}

-- Python
lspconfig.pyright.setup {
    capabilities = capabilities,
    on_attach = attach_cb,
}

-- Markdown
lspconfig.marksman.setup {
    capabilities = capabilities,
    on_attach = attach_cb,
}

-- Shell scripts
lspconfig.bashls.setup {
    capabilities = capabilities,
    on_attach = attach_cb,
    filetypes = { "bash", "sh", "zsh" },
}

-- JS/TS
lspconfig.eslint.setup {
    capabilities = capabilities,
    on_attach = attach_cb,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
}
