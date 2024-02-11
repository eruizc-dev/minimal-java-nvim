-- Bootstrap plugin manager (lazy.nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Some nice to haves
vim.cmd[[set expandtab tabstop=4 softtabstop=0 shiftwidth=0 smartindent]]

-- Install required plugins
require("lazy").setup({
    {
        'williamboman/mason.nvim',
        cmd = { 'Mason', 'MasonLog', 'MasonInstall' },
        opts = {}
    },
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
        dependencies = 'saadparwaiz1/cmp_luasnip',
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        version = false,
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
        },
        opts = function()
            return {
                snippet = {
                    expand = function(args)
                        require'luasnip'.lsp_expand(args.body)
                    end
                },
                mapping = {
                    ['<C-c>'] = require'cmp'.mapping.abort(),
                    ['<CR>'] = require'cmp'.mapping.confirm(),
                    ['<C-j>'] = require'cmp'.mapping.select_next_item(),
                    ['<C-k>'] = require'cmp'.mapping.select_prev_item(),
                },
                sources = {
                    { name = 'nvim_lsp' }
                },
            }
        end
    },
    {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'antoinemadec/FixCursorHold.nvim',
            'nvim-treesitter/nvim-treesitter',
            'rcasia/neotest-java',
        },
        opts = function()
            return {
                adapters = {
                    require'neotest-java',
                }
            }
        end
    },
    {
        'rcarriga/nvim-dap-ui',
        dependencies = 'mfussenegger/nvim-dap',
        config = function(_, opts)
            require'dapui'.setup(opts)
        end
    }
})
