vim.g.mapleader = " " -- space bar is the 'leader' char
vim.o.autoindent = true
vim.o.autowriteall = true -- save bufferes before invoking make
vim.o.autoread = true -- watch for file changes
vim.o.backspace = indent, eol, start
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,noselect"
vim.o.diffopt = filler, iwhite
vim.o.errorbells = true
vim.o.expandtab = true
vim.o.fileformats = unix
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevelstart = 25 -- don't fold a file automatically unless it has this mnay levels
vim.o.foldmethod = "syntax"
vim.o.hidden = true -- allow switching buffers without saving them
vim.o.listchars = "tab:» ,trail:·,extends:▶,precedes:◀,nbsp:‿" -- unchanged: eol, multispace, lead
vim.o.list = true
vim.o.matchtime = 5 -- blink matching chars for this number of seconds
vim.o.mouse = "a"
vim.o.number = true
vim.o.scrolloff = 5 -- keep at least 5 lines above/below
vim.o.shada = "!,'20,<50,s10,h" -- limit opened file history to 20
vim.o.shiftwidth = 4 -- spaces for each level
vim.o.signcolumn = "yes"
vim.o.softtabstop = 4
vim.o.smartindent = true
vim.o.startofline = false -- leave cursor position alone
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.visualbell = true -- visual flash instead of audible beep for error
vim.o.wildignore = "*.a,*.dll,*.exe,*.so,*.swp,*.o,*/bin/*,__pycache__,*/.git/*" -- ignore these when searching over wildcard files
vim.o.wildmenu = true -- menu has tab completion
vim.o.winborder = "rounded"
vim.o.wrap = true -- soft wrap long lines

local function setup_plugins(plugins)
    vim.pack.add(plugins)

    for _, plugin in ipairs(plugins) do
        if plugin.config then
            plugin.config() -- Second pass: run optional config functions after all plugins are loaded to avoid dealing with dependencies
        end
    end
end

setup_plugins({
    {
        src = "https://github.com/tpope/vim-fugitive",
        config = function()
            -- all git shortcuts start with 'g'
            vim.keymap.set("n", "<leader>gg", ":Git<CR>") -- Open git status in interative window (similar to lazygit)
            vim.keymap.set("n", "<leader>gs", ":Gstatus<CR>") -- Show `git status output`
            vim.keymap.set("n", "<leader>gc", ":Git commit | startinsert<CR>") -- Open commit window (creates commit after writing and saving commit msg)
            vim.keymap.set("n", "<leader>gd", ":Git difftool<CR>") -- Other tools from fugitive
            vim.keymap.set("n", "<leader>gl", ":silent! Glog<CR>")
            vim.keymap.set("n", "<leader>gm", ":Git mergetool<CR>")
            vim.keymap.set("n", "<leader>g|", ":Gvdiffsplit<CR>")
            vim.keymap.set("n", "<leader>g-", ":Gdiffsplit<CR>")
        end,
    },
    { src = "https://github.com/folke/snacks.nvim" },
    {
        src = "https://github.com/folke/tokyonight.nvim",
        config = function()
            vim.cmd([[colorscheme tokyonight-night]])
        end,
    },
    {
        src = "https://github.com/williamboman/mason.nvim", -- load all lsp, formatting, linters
        config = function()
            require("mason").setup({
                ensure_installed = { "clangd", "pylsp", "pyright", "rust_analyzer" },
            })
        end,
    },
    {
        src = "https://github.com/williamboman/mason-lspconfig.nvim", -- load all lsp tools
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd", "lua_ls", "rust_analyzer" },
            })
        end,
    },
    {
        src = "https://github.com/nvim-mini/mini.pick",
        config = function()
            require("mini.pick").setup()
        end,
    },
    {
        src = "https://github.com/lukas-reineke/indent-blankline.nvim", -- highlight indentation levels
        config = function()
            require("ibl").setup({
                indent = { highlight = { "CursorColumn", "Whitespace" }, char = "" },
                whitespace = {
                    highlight = { "CursorColumn", "Whitespace" },
                    remove_blankline_trail = false,
                },
                scope = { enabled = false },
            })
        end,
    },
    { src = "https://github.com/neomake/neomake" }, -- run build commands asynchronously
    { src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- collection of graphical icons for terminal consoles
    {
        src = "https://github.com/nvim-lualine/lualine.nvim", -- status line
        config = function()
            require("lualine").setup()
        end,
    },
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = { "c", "cpp", "html", "json", "python", "rust" },
                highlight = { enable = "true" },
                rainbow = { enable = "true", extended_mode = "true" },
                folding = { enabled = true },
                --sync_install     = false, -- only needed at first setup
                --auto_install     = true,
            })
        end,
    },
    {
        src = "https://github.com/Badhi/nvim-treesitter-cpp-tools",
        config = function()
            require("nt-cpp-tools").setup({
                header_extension = "hpp",
                source_extension = "cpp",
            })
        end,
    },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                enable = true,
                multiwindow = true,
                line_numbers = true,
            })
        end,
    },
    {
        src = "https://github.com/neovim/nvim-lspconfig", -- lsp configs
        config = function()
            vim.lsp.config("*", {
                root_markers = { ".git" },
            })

            vim.lsp.config.clangd = {
                cmd = { "clangd", "--background-index" },
                root_markers = { "compile_commands.json", "compile_flags.txt" },
                filetypes = { "c", "cpp" },
            }

            vim.lsp.config.rust_analyzer = {
                cmd = { "rust-analyzer" },
                filetypes = { "rust" },
                root_markers = { "Cargo.toml", ".git" },
                single_file_support = true,
                settings = {
                    ["rust-analyzer"] = {
                        diagnostics = { enable = false },
                        checkOnSave = { command = "clippy" },
                    },
                },
                before_init = function(init_params, config)
                    if config.settings and config.settings["rust-analyzer"] then
                        init_params.initializationOptions = config.settings["rust-analyzer"]
                    end
                end,
            }

            vim.lsp.config.lua_ls = {
                cmd = { "lua-language-server" },
                filetypes = { "lua" },
                root_markers = { ".luarc.json", ".luarc.jsonc" },
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        runtime = { version = "LuaJIT" },
                        workspace = { -- Add Neovim's Lua API to the language server's library
                            library = vim.tbl_get(vim.lsp.get_clients(), 1, "config", "workspace", "library") or {},
                            checkThirdParty = false,
                            telemetry = { enable = false },
                        },
                        signatureHelp = { enabled = true },
                    },
                },
            }

            vim.lsp.enable("clangd")
            vim.lsp.enable("lua_ls")
            vim.lsp.enable("pyright")
            vim.lsp.enable("rust_analyzer")
        end,
    },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/hrsh7th/cmp-cmdline" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    {
        src = "https://github.com/Djancyp/custom-theme.nvim", -- see what field group a colortheme supports and edit them
        config = function()
            require("custom-theme").setup()
        end,
    },
    { src = "https://github.com/stevearc/dressing.nvim" },
    {
        src = "https://github.com/coder/claudecode.nvim",
        config = function()
            require("claudecode").setup({
                terminal_cmd = "/home/edwin.chen/.local/bin/claude",
                terminal = {
                    cwd_provider = function(ctx)
                        -- Prefer repo root; fallback to file's directory
                        local cwd = require("claudecode.cwd").git_root(ctx.file_dir or ctx.cwd)
                            or ctx.file_dir
                            or ctx.cwd
                        return cwd
                    end,
                },
            })

            -- All AI shortcuts start with 'a'
            vim.keymap.set("n", "<Leader>aa", "<cmd>ClaudeCodeDiffAccept<CR>", { desc = "Accept Claude Diff" })
            vim.keymap.set("n", "<Leader>ac", "<cmd>ClaudeCode<CR>", { desc = "Toggle Claude" })
            vim.keymap.set("n", "<Leader>ad", "<cmd>ClaudeCodeDiffDeny<CR>", { desc = "Deny Claude diff" })
            vim.keymap.set("n", "<Leader>af", "<cmd>ClaudeCodeFocus<CR>", { desc = "Focus Claude" })
            vim.keymap.set("n", "<Leader>ar", "<cmd>ClaudeCode --resume<CR>", { desc = "Resume Claude" })
            vim.keymap.set("n", "<Leader>ac", "<cmd>ClaudeCode --continue<CR>", { desc = "Continue Claude" })
            vim.keymap.set("n", "<Leader>am", "<cmd>ClaudeCodeSelectModel<CR>", { desc = "Select Claude" })
            vim.keymap.set("n", "<Leader>ab", "<cmd>ClaudeCodeAdd<CR>", { desc = "Add Current Buffer to Claude" })
            vim.keymap.set("n", "<Leader>as", "<cmd>ClaudeCodeSend<CR>", { desc = "Send to Claude" })
        end,
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

vim.keymap.set("n", "<Leader>b", "<CMD>ls<CR>:b<Space>", { noremap = true, desc = "Prompt to switch to a buffer" })
vim.keymap.set("n", "<leader>d", "<CMD>Gvdiffsplit master<CR>", { desc = "Differences against what is in git master" })
vim.keymap.set("n", "<leader>e", "<CMD>Pick files<CR>", { desc = "File explorer" })
vim.keymap.set("v", "<leader>f", "zo", { desc = "Fold toggle (expand if collapsed)" })
vim.keymap.set("n", "<leader>f", "za", { desc = "Fold collapse" })
vim.keymap.set("n", "<leader>h", "<CMD>split<CR><C-w>w", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Beautify current file" })
vim.keymap.set("n", "<leader>m", "<CMD>bro o<CR>", { desc = "Most recently-opened files" })
vim.keymap.set("n", "<leader>n", "<CMD>edit $MYVIMRC<CR>", { desc = "Edit nvim's init.lua" })
vim.keymap.set("n", "<leader>N", "<CMD>update<CR> :source $MYVIMRC<CR>", { desc = "Re-read nvim's init.lua" })
vim.keymap.set("n", "<leader>q", "<CMD>wqall!<CR>", { desc = "Write all and quite" })
vim.keymap.set("n", "<leader>t", "<CMD>split term://bash<CR>i", { desc = "Open terminal in horizontal split and insert mode" })
vim.keymap.set("n", "<leader>v", "<CMD>vsplit<CR><C-w>w", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>w", "<CMD>wall!<CR>", { desc = "Write all" })
vim.keymap.set("n", "<F3>", ":/error:<CR>", { desc = "Find next error in currente quickfix buffer" })
vim.keymap.set("n", "<F6>", "<CMD>cexpr []<CR> <CMD>NeomakeSh! ~/bin/buildt.sh<CR> <CMD>copen<CR>", { desc = "Make trader-repo" })
vim.keymap.set("n", "<F7>", "<CMD>cexpr []<CR> <CMD>NeomakeSh! ~/bin/builds.sh<CR> <CMD>copen<CR>", { desc = "Make snap" })
vim.keymap.set("n", "<F8>", "<CMD>cexpr []<CR> <CMD>NeomakeSh! ~/bin/buildm.sh<CR> <CMD>copen<CR>", { desc = "Make monorepo" })
vim.keymap.set("n", "<F9>", "<CMD>cexpr []<CR> <CMD>NeomakeCancelJobs<CR>", { desc = "Stop make jobs" })
vim.keymap.set("t", "<leader><ESC>", "<C-\\><C-n><C-w>p", { desc = "Switch out of terminal (or AI prompt)" })
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

vim.lsp.inlay_hint.enable(false)

vim.cmd(":hi statusline guibg=NONE")
vim.cmd("filetype indent on")

vim.api.nvim_create_autocmd("BufWritePre", { -- trim trailing whitespace prior to saving
    pattern = { "*" },
    callback = function()
        local save_cursor = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]]) -- rerform the substitution
        vim.fn.winrestview(save_cursor) -- restore the cursor position
    end,
})
