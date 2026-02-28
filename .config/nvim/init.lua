vim.g.mapleader = " " -- space bar is the 'leader' cha
vim.o.autoindent = true
vim.o.autowriteall = true -- save bufferes before invoking make
vim.o.autoread = true -- watch for file changes
vim.o.backspace = "indent,eol,start"
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menu,menuone,noselect"
vim.o.pumwidth = 40
vim.o.diffopt = "filler,iwhite"
vim.o.errorbells = true
vim.o.expandtab = true
vim.o.fileformats = "unix"
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevelstart = 25 -- don't fold a file automatically unless it has this mnay levels
vim.o.foldmethod = "expr"
vim.o.hidden = true -- allow switching buffers without saving them
vim.o.listchars = "tab:» ,trail:·,extends:▶,precedes:◀,nbsp:‿" -- unchanged: eol, multispace, lead
vim.o.list = true
vim.o.matchtime = 5 -- blink matching chars for this number of seconds
vim.o.mouse = "a"
vim.o.number = true
vim.o.scrolloff = 5 -- keep at least 5 lines above/below
vim.o.shada = "!,'25,<50,s10,h" -- limit opened file history to 25
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

-- path for 'gf' to work
vim.opt.path="/usr/include/**"
.. "," .. vim.env.XR_MONOREPO_ROOT
.. "," .. vim.env.XR_MONOREPO_ROOT .. "/cpp/libs/**"
.. "," .. vim.env.XR_MONOREPO_ROOT .. "/cpp/apps/**"
.. "," .. vim.env.SNAP_ROOT_DIR    .. "/xr-snap/src/xr/snap/**"
.. "," .. vim.env.SNAP_ROOT_DIR    .. "/ext"
if vim.env.TRADER_REPO_DIR ~= nil then
  vim.opt.path:append("," .. vim.env.TRADER_REPO_DIR  .. "/**")
end



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
            vim.keymap.set("n", "<leader>gc", ":Git commit | startinsert<CR>") -- Open commit window (creates commit after writing and saving commit msg)
            vim.keymap.set("n", "<leader>gl", ":silent! Glog<CR>")
            vim.keymap.set("n", "<leader>gm", ":Git mergetool<CR>")
            vim.keymap.set("n", "<leader>g|", ":Gvdiffsplit<CR>")
            vim.keymap.set("n", "<leader>g-", ":Gdiffsplit<CR>")
            vim.keymap.set("n", "<leader>gd", "<CMD>Gvdiffsplit master<CR>", { desc = "Differences against what is in git master" })
            vim.keymap.set("n", "<leader>gs", function() require("telescope.builtin").git_status() end, { desc = "Git status with preview" })
        end,
    },
    {
        src = "https://github.com/folke/tokyonight.nvim",
        config = function()
            vim.cmd([[colorscheme tokyonight-night]])
        end,
    },
    {
        src = "https://github.com/kevinhwang91/nvim-bqf",
        ft = 'qf',
        config = function()
            require("bqf").setup({
                preview = {
                    wrap = true,
                }
            })
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
    { src = "https://github.com/neomake/neomake" }, -- run build commands asynchronously
    { src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- collection of graphical icons for terminal consoles
    {
        src = "https://github.com/nvim-lualine/lualine.nvim", -- status line
        config = function()
            require("lualine").setup()
        end,
    },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim",
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_strategy = "vertical",
                    layout_config = {
                        vertical = {
                            preview_height = 0.5,
                            preview_cutoff = 0,
                        },
                        width = 0.9,
                        height = 0.9,
                    },
                },
            })
            vim.api.nvim_set_hl(0, "TelescopePreviewMatch", { bg = "#ff9e64", fg = "#1a1b26", bold = true })
            vim.api.nvim_create_autocmd("User", {
                pattern = "TelescopePreviewerLoaded",
                callback = function() vim.wo.number = true end,
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
                cmd = { "clangd", "--background-index", "--compile-commands-dir=" .. vim.env.XR_MONOREPO_ROOT },
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
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
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
    {
        src = "https://github.com/williamboman/mason-lspconfig.nvim", -- load all lsp tools
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd", "lua_ls", "rust_analyzer" },
            })
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
        src = "https://github.com/saghen/blink.cmp",
        config = function()
            require("blink.cmp").setup({
                keymap = { preset = "super-tab" },
                completion = {
                    documentation = { auto_show = true },
                },
                sources = {
                    default = { "lsp", "path", "buffer" },
                },
            })
        end,
    },
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
                terminal_cmd = "/home/edwin.chen/.local/bin/claude --dangerously-skip-permissions",
                terminal = {
                    split_side = "bottom",
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
            vim.keymap.set("n", "<Leader>ad", "<cmd>ClaudeCodeDiffDeny<CR>", { desc = "Deny Claude diff" })
            vim.keymap.set("n", "<Leader>af", function()
                local focused = pcall(vim.cmd, "ClaudeCodeFocus")
                if not focused then
                    vim.cmd("ClaudeCode --resume")
                end
            end, { desc = "Focus/Resume Claude" })
            vim.keymap.set("n", "<Leader>am", "<cmd>ClaudeCodeSelectModel<CR>", { desc = "Select Claude" })
        end,
    },
    { src = "https://github.com/nvim-neotest/nvim-nio" }, -- async IO library (required by nvim-dap-ui)
    {
        src = "https://github.com/mfussenegger/nvim-dap",
       config = function()
            local dap = require("dap")

            -- GDB adapter (requires GDB 14+ with DAP support)
            -- -nx skips .gdbinit (its output corrupts the DAP protocol stream)
            -- .gdbinit settings are replicated in setupCommands below
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "-nx", "--interpreter=dap" },
            }

            -- C/C++ configurations
            -- Persist last debug inputs across restarts
            local dap_cache_file = vim.fn.stdpath("data") .. "/dap_last_inputs.json"
            local function load_dap_cache()
                local f = io.open(dap_cache_file, "r")
                if f then
                    local ok, data = pcall(vim.json.decode, f:read("*a"))
                    f:close()
                    if ok and data then return data end
                end
                return {}
            end
            local function save_dap_cache(prog, args, cwd)
                local f = io.open(dap_cache_file, "w")
                if f then
                    f:write(vim.json.encode({ program = prog, args = args, cwd = cwd }))
                    f:close()
                end
            end
            local cache = load_dap_cache()
            local last_program = cache.program or (vim.env.XR_MONOREPO_ROOT .. "/bazel-bin/")
            local last_args = cache.args or ""
            local last_cwd = cache.cwd or (vim.env.XR_MONOREPO_ROOT .. "/")

            dap.configurations.cpp = {
                {
                    name = "Launch (GDB)",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        last_program = vim.fn.input("Executable: ", last_program, "file")
                        save_dap_cache(last_program, last_args, last_cwd)
                        return last_program
                    end,
                    args = function()
                        last_args = vim.fn.input("Arguments: ", last_args)
                        save_dap_cache(last_program, last_args, last_cwd)
                        return vim.split(last_args, " ", { trimempty = true })
                    end,
                    cwd = function()
                        last_cwd = vim.fn.input("Working directory: ", last_cwd, "dir")
                        save_dap_cache(last_program, last_args, last_cwd)
                        return last_cwd
                    end,
                    stopAtBeginningOfMainSubprogram = true,
                    console = "integratedTerminal",
                    setupCommands = {
                        { text = "set print pretty on" },
                        { text = "set print elements 64" },
                        { text = "set print array-indexes on" },
                        { text = "set print static off" },
                        { text = "set python print-stack full" },
                        { text = "set breakpoint pending on" },
                        { text = "break __sanitizer::Die" },
                        { text = "break __asan::ReportGenericError" },
                        { text = "skip -rfu ^std::" },
                        { text = "skip -rfu ^assemblies::AssemblyBase" },
                        { text = "source " .. vim.env.XR_MONOREPO_ROOT .. "/misc/gdb/pretty-printers/bootstrap.py" },
                        --{ text = "python\nimport sys\nsys.path.insert(0, '/home/edwin.chen/.gdb/printers/python')\nfrom libstdcxx.v6.printers import register_libstdcxx_printers\nregister_libstdcxx_printers(None)\nend" },
                    },
                },
            }
            dap.configurations.c = dap.configurations.cpp

            -- Open the integrated terminal (program stdout) at the bottom
            dap.defaults.fallback.terminal_win_cmd = "belowright new"

            -- Session control
            vim.keymap.set("n", "<leader>dl", dap.continue, { desc = "Start/Continue Debugging" })

            -- Stepping
            vim.keymap.set("n", "<C-Down>", dap.step_over, { desc = "Step Over" })
            vim.keymap.set("n", "<C-Right>", dap.step_into, { desc = "Step Into" })
            vim.keymap.set("n", "<C-Left>", dap.step_out, { desc = "Step Out" })
            vim.keymap.set("n", "<C-Up>", dap.continue, { desc = "Continue" })

            -- Stack frame navigation
            vim.keymap.set("n", "<leader>du", dap.up, { desc = "Frame Up" })
            vim.keymap.set("n", "<leader>dd", dap.down, { desc = "Frame Down" })
            vim.keymap.set("n", "<leader>ds", function()
                require("dapui").float_element("stacks", { enter = true })
            end, { desc = "Open Stacks (float)" })

            -- Breakpoints
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>dB", function()
                dap.set_breakpoint(vim.fn.input("Condition: "))
            end, { desc = "Conditional Breakpoint" })
            vim.keymap.set("n", "<leader>dp", function()
                dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
            end, { desc = "Logpoint" })

        end,
    },
    {
        src = "https://github.com/rcarriga/nvim-dap-ui",
        config = function()
            local dapui = require("dapui")
            dapui.setup({
                layouts = {
                    {   -- Right sidebar: repl for GDB commands
                        elements = {
                            { id = "repl", size = 1.0 },
                        },
                        size = 60,
                        position = "right",
                    },
                    {   -- Bottom panel: stacks + scopes side by side
                        elements = {
                            { id = "stacks", size = 0.5 },
                            { id = "scopes", size = 0.5 },
                        },
                        size = 15,
                        position = "bottom",
                    },
                },
            })

            -- Auto open/close UI when debugging starts/stops
            local dap = require("dap")
            dap.listeners.before.attach.dapui_config = function() dapui.open() end
            dap.listeners.before.launch.dapui_config = function() dapui.open() end
            dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
            dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

            vim.keymap.set("n", "<leader>dx", function()
                require("dap").terminate()
                dapui.close()
            end, { desc = "Stop debugger and close UI" })

            -- Eval variable under cursor during debug (only when a session is active)
            local function dap_eval()
                if require("dap").session() then
                    dapui.eval()
                end
            end
            vim.keymap.set({"n", "v"}, "K", dap_eval, { desc = "Eval variable under cursor" })
            vim.keymap.set({"n", "v"}, "<leader>dh", dap_eval, { desc = "Eval variable under cursor" })
        end,
    },
})

-- blink.cmp handles LSP completion; do not enable vim.lsp.completion

vim.keymap.set("n", "<Leader>b", function() require("telescope.builtin").buffers() end, { desc = "Switch buffer with preview" })
vim.keymap.set("n", "<leader>e", ":/error:<CR>", { desc = "Find next error in current quickfix buffer" })
vim.keymap.set("v", "<leader>f", "zo", { desc = "Fold toggle (expand if collapsed)" })
vim.keymap.set("n", "<leader>-", "<CMD>split<CR><C-w>w", { desc = "Split horizontally" })
vim.keymap.set("n", "<leader>f", "za", { desc = "Fold collapse" })
vim.keymap.set("n", "<leader>lc", function() require("telescope.builtin").lsp_workspace_symbols({ symbols = "class" }) end, { desc = "Search workspace classes" })
vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Beautify current file" })
vim.keymap.set("n", "<leader>ls", function() require("telescope.builtin").lsp_workspace_symbols() end, { desc = "Search workspace symbols" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>tf", function()
    local word = vim.fn.expand("<cword>")
    vim.fn.setreg("/", "\\<" .. word .. "\\>")
    vim.o.hlsearch = true
    vim.ui.input({ prompt = "Grep path: ", default = ".", completion = "dir" }, function(path)
        if path then
            require("telescope.builtin").live_grep({ search_dirs = { path }, default_text = word })
        end
    end)
end, { desc = "Grep current word recursively from prompted path" })
vim.keymap.set("n", "<leader>mm", "<CMD>wall!<CR> <CMD>cexpr []<CR> <CMD>NeomakeSh! ~/bin/buildm.sh<CR> <CMD>copen<CR>", { desc = "Make monorepo" })
vim.keymap.set("n", "<leader>ms", "<CMD>wall!<CR> <CMD>cexpr []<CR> <CMD>NeomakeSh! ~/bin/builds.sh<CR> <CMD>copen<CR>", { desc = "Make snap" })
vim.keymap.set("n", "<leader>mt", "<CMD>wall!<CR> <CMD>cexpr []<CR> <CMD>NeomakeSh! ~/bin/buildt.sh<CR> <CMD>copen<CR>", { desc = "Make trader-repo" })
vim.keymap.set("n", "<leader>mq", function() require("telescope.builtin").quickfix() end, { desc = "Browse build errors with preview" })
vim.keymap.set("n", "<leader>mx", "<CMD>wall!<CR> <CMD>cexpr []<CR> <CMD>NeomakeCancelJobs<CR>", { desc = "Stop make jobs" })
vim.keymap.set("n", "<leader>n", "<CMD>edit $MYVIMRC<CR>", { desc = "Edit nvim's init.lua" })
vim.keymap.set("n", "<leader>N", "<CMD>update<CR> :source $MYVIMRC<CR>", { desc = "Re-read nvim's init.lua" })
vim.keymap.set("n", "<leader>o", function()
    local dirs = {}
    for _, dir in ipairs(vim.opt.path:get()) do
        dir = dir:gsub("%*%*$", ""):gsub("/$", "")
        if dir ~= "" and dir ~= "." then
            table.insert(dirs, dir)
        end
    end
    require("telescope.builtin").find_files({ search_dirs = dirs })
end, { desc = "Find and open file across path dirs" })
vim.keymap.set("n", "<leader>q", "<CMD>wqall!<CR>", { desc = "Write all and quit" })
vim.keymap.set("n", "<leader>r", function() require("telescope.builtin").oldfiles() end, { desc = "Recently opened files with preview" })
vim.keymap.set("n", "<leader>t", "<CMD>split term://bash<CR>i", { desc = "Open terminal in horizontal split and insert mode" })
vim.keymap.set("n", "<leader>T", "<CMD>vsplit term://bash<CR>i", { desc = "Open terminal in vertical split and insert mode" })
vim.keymap.set("n", "<leader>w", "<CMD>wall!<CR>", { desc = "Write all" })
vim.keymap.set("n", "<leader>|", "<CMD>vsplit<CR><C-w>w", { desc = "Split vertically" })
vim.keymap.set("t", "<C-Space>", "<C-\\><C-n><C-W>p", { desc = "Switch out of terminal or CClaude terminal" })
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "gd", function() require("telescope.builtin").lsp_definitions() end, { desc = "Go to definition" })
vim.keymap.set("i", "<RightMouse>", '<C-r>+')
vim.keymap.set("v", "<RightMouse>", '"+p')
vim.keymap.set("n", "<RightMouse>", '"+p')

vim.api.nvim_create_user_command("LspStatus", function()
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        print(client.name .. " | root: " .. (client.config.root_dir or "nil") .. " | status: " .. (vim.lsp.status() or "idle"))
    end
    if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then
        print("No LSP clients attached to this buffer")
    end
end, { desc = "Show LSP client status for current buffer" })

vim.cmd(":hi statusline guibg=NONE")
vim.cmd("filetype indent on")

vim.api.nvim_create_autocmd("BufLeave", { -- autosave when leaving a buffer (e.g. switching to Claude terminal)
    callback = function()
        if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
            vim.cmd("silent! write")
        end
    end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, { -- detect external file changes (i.e. whn Claude updates init.lua or some source code)
    command = "checktime",
})

vim.api.nvim_create_autocmd("BufWritePost", { -- auto-reload init.lua on save
    pattern = vim.fn.stdpath("config") .. "/init.lua",
    callback = function()
        vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
        vim.notify("init.lua reloaded", vim.log.levels.INFO)
    end,
})

vim.api.nvim_create_autocmd("FileType", { -- make gf in quickfix open file in previous window
    pattern = "qf",
    callback = function()
        vim.wo.wrap = true
        local function parse_file_and_line()
            local line = vim.api.nvim_get_current_line()
            local file, lnum = line:match("(/[%w_.%-/]+):(%d+)")
            if not file or vim.fn.filereadable(file) ~= 1 then
                file = line:match("(/[%w_.%-/]+)")
                lnum = nil
            end
            if not file or vim.fn.filereadable(file) ~= 1 then
                file = vim.fn.expand("<cfile>")
                lnum = nil
            end
            return file, lnum and tonumber(lnum)
        end
        vim.keymap.set("n", "gf", function()
            local file, lnum = parse_file_and_line()
            if file == "" then return end
            vim.cmd("edit " .. vim.fn.fnameescape(file))
            if lnum then
                vim.schedule(function()
                    pcall(vim.api.nvim_win_set_cursor, 0, { lnum, 0 })
                    vim.cmd("normal! zz")
                end)
            end
        end, { buffer = true })
        vim.keymap.set("n", "gF", function()
            local file, lnum = parse_file_and_line()
            if file == "" then return end
            vim.cmd("wincmd p") -- open it in a regular window
            vim.cmd("edit " .. vim.fn.fnameescape(file))
            if lnum then
                vim.schedule(function()
                    pcall(vim.api.nvim_win_set_cursor, 0, { lnum, 0 })
                    vim.cmd("normal! zz")
                end)
            end
        end, { buffer = true })
    end,
})

vim.api.nvim_create_autocmd("FileType", { -- auto-scroll quickfix to bottom as new lines are added
    pattern = "qf",
    callback = function(ev)
        vim.api.nvim_buf_attach(ev.buf, false, {
            on_lines = function()
                vim.schedule(function()
                    local qf_winid = vim.fn.bufwinid(ev.buf)
                    if qf_winid ~= -1 then
                        local line_count = vim.api.nvim_buf_line_count(ev.buf)
                        pcall(vim.api.nvim_win_set_cursor, qf_winid, { line_count, 0 })
                    end
                end)
            end,
        })
    end,
})

vim.api.nvim_create_autocmd("User", { -- reload full build output into quickfix after Neomake finishes
    pattern = "NeomakeFinished",
    callback = function()
        local f = io.open("/tmp/outt", "r")
        if not f then return end
        local lines = {}
        for line in f:lines() do
            table.insert(lines, line)
        end
        f:close()
        local efm = table.concat({
            "%f:%l:%c: %t%*[^:]: %m",
            "%f:%l: %t%*[^:]: %m",
            "%f:%l:%c: %m",
            "%f:%l: %m",
            "%+G%.%#",
        }, ",")
        vim.fn.setqflist({}, "r", { lines = lines, efm = efm })
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", { -- trim trailing whitespace prior to saving
    pattern = { "*" },
    callback = function()
        local save_cursor = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]]) -- perform substitution
        vim.fn.winrestview(save_cursor) -- restore the cursor position
    end,
})

