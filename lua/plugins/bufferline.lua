return {
    {
        "akinsho/bufferline.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local bufferline = require("bufferline")
            bufferline.setup({
                options = {
                    mode = "buffers", -- set to "tabs" to only show tabpages instead
                    diagnostics = "nvim_lsp",
                    color_icons = true,
                },
            })
            vim.keymap.set("n", "<C-q>", ":BufferLineCloseOthers<CR>")
            vim.keymap.set("n", "<C-n>", ":BufferLineCycleNext<CR>")
            vim.keymap.set("n", "<C-p>", ":BufferLineCyclePrev<CR>")
        end,
    },
}