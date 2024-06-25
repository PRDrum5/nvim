return {
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sorces = {
                    -- Python
                    null_ls.builtins.diagnostics.mypy,
                },
            })

            vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
        end,
    },
}
