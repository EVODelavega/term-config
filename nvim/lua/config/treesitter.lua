require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "rust", "lua", "vim", "bash", "markdown", "json" , "go", "gomod", "gowork", "gosum" },
    highlight = { enable = true },
    indent = { enable = true },
}
