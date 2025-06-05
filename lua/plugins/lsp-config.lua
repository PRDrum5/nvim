return {
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },
    { "rafamadriz/friendly-snippets" },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()

            lsp_zero.preset("recommended")
            lsp_zero.setup()

            lsp_zero.on_attach(function(client, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)

            require("mason").setup({
                ensure_installed = {
                    "debugpy",
                },
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "bashls",
                    "clangd", -- C/C++
                    "cmake",
                    "dockerls",
                    "jsonls",
                    "taplo",    -- TOML
                    "lemminx",  -- XML
                    "marksman", -- Markdown
                    "pyright",
                    "ruff"
                },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({})
                    end,

                    -- Custom Pyright config
                    ["pyright"] = function()
                        require("lspconfig").pyright.setup({
                            settings = {
                                python = {
                                    venvPath = ".",                 -- path to where `.venv` lives
                                    venv = ".venv",                 -- name of the virtual environment
                                    analysis = {
                                        typeCheckingMode = "basic", -- or "strict"
                                        autoSearchPaths = true,
                                        useLibraryCodeForTypes = true,
                                    },
                                },
                            },
                        })
                    end,

                    -- Custom Ruff config
                    ["ruff_lsp"] = function()
                        require("lspconfig").ruff_lsp.setup({
                            init_options = {
                                settings = {
                                    args = {}, -- optional: pass ruff CLI args
                                },
                            },
                        })
                    end,
                },
            })

            lsp_zero.format_on_save({
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
                servers = {
                    ["lua_ls"] = { "lua" },
                    ["rust_analyzer"] = { "rust" },
                    ["clangd"] = { "c", "cpp" },
                },
            })

            local cmp = require("cmp")
            local cmp_format = require("lsp-zero").cmp_format({ details = true })
            require("luasnip.loaders.from_vscode").lazy_load()
            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "luasnip" },
                },
                formatting = cmp_format,
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.confirm({ select = true }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
            })

            -- LSP Mappings
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
}
