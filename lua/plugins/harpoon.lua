return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        harpoon:setup({
            settings = {
                save_on_toggle = true,
                sync_on_ui_close = false,
            },
        })

        -- Keymappings
        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end, { desc = "Set Harpoon Mark" })
        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Open harpoon window" })

        vim.keymap.set("n", "<leader>ha", function()
            harpoon:list():select(1)
        end, { desc = "Go to 1st Harpoon Buffer" })
        vim.keymap.set("n", "<leader>hs", function()
            harpoon:list():select(2)
        end, { desc = "Go to 2nd Harpoon Buffer" })
        vim.keymap.set("n", "<leader>hd", function()
            harpoon:list():select(3)
        end, { desc = "Go to 3rd Harpoon Buffer" })
        vim.keymap.set("n", "<leader>hf", function()
            harpoon:list():select(4)
        end, { desc = "Go to 4th Harpoon Buffer" })

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<C-p>", function()
            harpoon:list():prev()
        end, { desc = "Go to Next Harpoon Buffer" })
        vim.keymap.set("n", "<C-n>", function()
            harpoon:list():next()
        end, { desc = "Go to Prev Harpoon Buffer" })
    end,
}
