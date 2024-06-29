return {
    {
        "mfussenegger/nvim-dap",
        dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
        plugin = true,
        config = function()
            local dap = require("dap")

            local dapui = require("dapui")
            dapui.setup()

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            vim.keymap.set("n", "<Leader>dc", function()
                dap.continue()
            end)
            vim.keymap.set("n", "<F5>", function()
                dap.continue()
            end)
            vim.keymap.set("n", "<Leader>ds", function()
                dap.step_over()
            end)
            vim.keymap.set("n", "<Leader>di", function()
                dap.step_into()
            end)
            vim.keymap.set("n", "<Leader>do", function()
                dap.step_out()
            end)
            vim.keymap.set("n", "<Leader>db", function()
                dap.toggle_breakpoint()
            end)
            vim.keymap.set("n", "<Leader>dB", function()
                dap.set_breakpoint()
            end)
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        -- Ensure that debugpy is installed with mason under lsp-config -> ensure_installed = {"debugpy"}, etc.
        config = function()
            local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            require("dap-python").setup(path)
        end,
    },
}
