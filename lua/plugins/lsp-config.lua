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
                    "black",
                    "isort",
                    "flake8",
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
                    "taplo", -- TOML
                    "lemminx", -- XML
                    "gitlab_ci_ls", -- YAML
                    "marksman", -- Markdown
                    "pylsp",
                },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup({})
                    end,

                    -- Custom handler for PyLSP
                    pylsp = function()
                        local get_flake8_exe = function()
                            local venv_path = os.getenv("VIRTUAL_ENV")
                            local flake8_exe = "flake8"
                            if venv_path ~= nil then
                                flake8_exe = os.getenv("VIRTUAL_ENV") .. "bin/flake8"
                            end
                            return flake8_exe
                        end

                        require("lspconfig").pylsp.setup({
                            ft = "python",
                            settings = {
                                pylsp = {
                                    configurationSources = "pycodestyle",
                                    plugins = {
                                        pycodestyle = {
                                            enabled = false,
                                            maxLineLength = 100,
                                            indentSize = 4,
                                            ignore = {},
                                        },
                                        flake8 = {
                                            enabled = true,
                                            maxLineLength = 100,
                                            indentSize = 4,
                                            ignore = {},
                                            executable = get_flake8_exe(),
                                        },
                                        jedi = {
                                            extra_path = { os.getenv("VIRTUAL_ENV") },
                                        },
                                        jedi_completion = {
                                            enabled = true,
                                            fuzzy = true,
                                        },
                                    },
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
