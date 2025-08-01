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
