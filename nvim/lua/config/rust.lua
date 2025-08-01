vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr)
            local opts = { noremap=true, silent=true, buffer=bufnr }
            local buf = function(mode, key, cmd)
                vim.keymap.set(mode, key, cmd, opts)
            end
            buf('n', 'gd', vim.lsp.buf.definition)
            buf('n', 'K', vim.lsp.buf.hover)
            buf('n', '<leader>f', vim.lsp.buf.format)
            -- diagnostic show.
            buf('n', '<leader>ds', vim.diagnostic.open_float)
            -- diagnostic quickfix.
            buf('n', '<leader>dq', vim.diagnostic.setloclist)
            -- Specific bind for RustLsp
            vim.keymap.set('n', '<leader>EE', function()
                vim.cmd.RustLsp('explainError')
            end, opts)
            vim.keymap.set('n', '<leader>EM', function()
                vim.cmd.RustLsp('expandMacro')
            end, opts)
            -- suggesteds, not sure if we'll need these
            vim.keymap.set('n', '<leader>rr', function()
                vim.cmd.RustLsp('runnables')
            end, opts)
    
            vim.keymap.set('n', '<leader>rd', function()
                vim.cmd.RustLsp('debuggables')
            end, opts)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                -- toggle inlay hints
                vim.keymap.set('n', '<leader>ih', function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end, opts)
            end
        end,
        settings = {
            ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                check = { command = "clippy" },
                procMacro = { enable = true },
                inlayHints = {
                    parameterHints = { enable = true },
                    chainingHints = { enable = true },
                    typeHints = {
                        enable = true,
                        hideNamedConstructor = false,
                        hideClosureInitialization = false,
                    },
                },
            }
        }
    }
}
