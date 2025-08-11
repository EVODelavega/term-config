require("mason").setup()
-- require("mason-lspconfig").setup({
--        ensure_installed = { "rust_analyzer" }
--    })
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

lspconfig.taplo.setup {
    filetypes = { "toml" },
    on_attach = function(client, bufnr)
        vim.bo[bufnr].tabstop = 2
        vim.bo[bufnr].shiftwidth = 2
        vim.bo[bufnr].expandtab = true
    end
}
