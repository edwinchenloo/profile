vim.g.mapleader = " " -- space bar is the 'leader' cha
vim.o.autoindent = true
vim.o.autowriteall = true -- save bufferes before invoking make
vim.o.autoread = true -- watch for file changes
vim.o.backspace = "indent,eol,start"
vim.o.clipboard = "unnamedplus"

-- OSC 52: route yank through the terminal emulator over SSH when no
-- native clipboard helper is available. Requires Neovim 0.10+.
-- Paste reads from Neovim's unnamed register because most terminals refuse
-- the OSC 52 read for security and the request would hang. To paste from the
-- local system clipboard, use the terminal's own paste (Shift+Insert,
-- Ctrl+Shift+V, right-click) — bracketed paste handles indentation.
if vim.env.SSH_TTY and vim.fn.executable("xclip") == 0 and vim.fn.executable("wl-copy") == 0 then
    local osc52 = require("vim.ui.clipboard.osc52")
    local function paste_from_unnamed()
        return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
    end
    vim.g.clipboard = {
        name = "OSC 52",
        copy  = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
        paste = { ["+"] = paste_from_unnamed, ["*"] = paste_from_unnamed },
    }
end
vim.o.completeopt = "menu,menuone,noselect,preview"
vim.o.cursorline = true -- highlight the current line
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
vim.o.undodir = os.getenv('HOME') .. '/.vim/undodir' -- directory for undo files
vim.o.undofile = true -- persist undo history across sessions
vim.o.visualbell = true -- visual flash instead of audible beep for error
vim.o.wildignore = "*.a,*.dll,*.exe,*.so,*.swp,*.o,*/bin/*,__pycache__,*/.git/*" -- ignore these when searching over wildcard files
vim.o.wildmenu = true -- menu has tab completion
vim.opt.wildoptions = "fuzzy" -- fuzzy matching for the command line (the : menu)
vim.o.winborder = "rounded"
vim.o.wrap = true -- soft wrap long lines

-- Bootstrap highlight to avoid ibl ColorScheme errors before config runs
-- Also clears any stale ibl autocmds from previous :source runs.
local ibl_bootstrap = vim.api.nvim_create_augroup("IndentBlankline", { clear = true })
vim.api.nvim_set_hl(0, "IndentBlankline", { link = "NonText" })
vim.api.nvim_create_autocmd("ColorScheme", {
    group = ibl_bootstrap,
    callback = function()
        vim.api.nvim_set_hl(0, "IndentBlankline", { link = "NonText" })
    end,
})

-- path for 'gf' to work
vim.opt.path="/usr/include/**"
if vim.env.XR_MONOREPO_ROOT then
  vim.opt.path:append(vim.env.XR_MONOREPO_ROOT)
  vim.opt.path:append(vim.env.XR_MONOREPO_ROOT .. "/cpp/libs/**")
  vim.opt.path:append(vim.env.XR_MONOREPO_ROOT .. "/cpp/apps/**")
end
if vim.env.SNAP_ROOT_DIR then
  vim.opt.path:append(vim.env.SNAP_ROOT_DIR .. "/xr-snap/src/xr/snap/**")
  vim.opt.path:append(vim.env.SNAP_ROOT_DIR .. "/ext")
end
if vim.env.TRADER_REPO_DIR then
  vim.opt.path:append(vim.env.TRADER_REPO_DIR .. "/**")
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
            vim.keymap.set("n", "<leader>gg", ":Git<CR>", { desc = "Git status interactive window" })
            vim.keymap.set("n", "<leader>gc", ":Git commit | startinsert<CR>", { desc = "Git commit" })
            vim.keymap.set("n", "<leader>gl", ":silent! Glog<CR>", { desc = "Git log" })
            vim.keymap.set("n", "<leader>gm", ":Git mergetool<CR>", { desc = "Git mergetool" })
            vim.keymap.set("n", "<leader>g|", ":Gvdiffsplit<CR>", { desc = "Git vertical diff split" })
            vim.keymap.set("n", "<leader>g-", ":Gdiffsplit<CR>", { desc = "Git horizontal diff split" })
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
            require("mason").setup()
        end,
    },
    { src = "https://github.com/neomake/neomake" }, -- run build commands asynchronously
    { src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- collection of graphical icons for terminal consoles
    {
        src = "https://github.com/nvim-lualine/lualine.nvim", -- status line
        config = function()
            require("lualine").setup({
                sections = {
                    lualine_c = { {
                        function()
                            local path = vim.fn.expand("%:p")
                            local max = math.floor(vim.o.columns * 0.4)
                            if #path > max then
                                return "…" .. path:sub(#path - max + 2)
                            end
                            return path
                        end,
                    } },
                    lualine_x = { "claudecode" , "encoding", "fileformat", "filetype" },
                },
            })
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
            -- Slightly darker indent guides based on Tokyonight palette
            local hooks = require("ibl.hooks")
            -- Clear old hooks on :source to avoid stale callbacks
            hooks.clear_all()
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                -- Derive indent color from current theme highlights
                local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
                local nontext = vim.api.nvim_get_hl(0, { name = "NonText" })
                local fg = normal.fg or nontext.fg
                local bg = normal.bg or 0x000000

                local function blend(bg_hex, fg_hex, alpha)
                    local function chan(x, shift)
                        return bit.band(bit.rshift(x, shift), 0xff)
                    end
                    local r = math.floor((chan(bg_hex, 16) * (1 - alpha)) + (chan(fg_hex, 16) * alpha) + 0.5)
                    local g = math.floor((chan(bg_hex, 8) * (1 - alpha)) + (chan(fg_hex, 8) * alpha) + 0.5)
                    local b = math.floor((chan(bg_hex, 0) * (1 - alpha)) + (chan(fg_hex, 0) * alpha) + 0.5)
                    return string.format("#%02x%02x%02x", r, g, b)
                end

                if fg then
                    -- Subtle shaded indent columns (no guide lines)
                    local indent_bg_1 = blend(bg, fg, 0.03)
                    local indent_bg_2 = blend(bg, fg, 0.05)
                    vim.api.nvim_set_hl(0, "IblIndent1", { bg = indent_bg_1 })
                    vim.api.nvim_set_hl(0, "IblIndent2", { bg = indent_bg_2 })
                    vim.api.nvim_set_hl(0, "IblWhitespace", { bg = indent_bg_1 })
                    -- Backward-compat highlight name to satisfy any defaults
                    vim.api.nvim_set_hl(0, "IndentBlankline", { bg = indent_bg_1 })
                end
            end)
            require("ibl").setup({
                indent = { highlight = { "IblIndent1", "IblIndent2" }, char = "" },
                whitespace = {
                    highlight = { "IblIndent1", "IblIndent2" },
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
                ensure_installed = { "c", "cpp", "html", "json", "lua", "python", "rust" },
                highlight = { enable = true },
                rainbow = { enable = true, extended_mode = true },
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
                fuzzy = {
                    implementation = "lua",
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
    { src = "https://github.com/sphamba/smear-cursor.nvim",
        config = function()
            require("smear_cursor").setup({
                stiffness = 0.8,
                trailing_stiffness = 0.5
            })
        end,
    },
    { src = "https://github.com/stevearc/dressing.nvim" },
    {
        src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
        config = function()
            require("render-markdown").setup({
                file_types = { "markdown" },
            })
        end,
    },
    {
        src = "https://github.com/m00qek/baleia.nvim",
        config = function()
            local baleia = require("baleia").setup()
            vim.api.nvim_create_user_command("Ansi", function()
                baleia.once(vim.api.nvim_get_current_buf())
            end, { desc = "Colorize ANSI escape sequences in current buffer" })
        end,
    },
    {
        src = "https://github.com/xTacobaco/cursor-agent.nvim",
        config = function()
            require("cursor-agent").setup({
                cmd = "cursor-agent",
                args = { "--model", "gpt-5.2-codex" },
            })

            local ca = require("cursor-agent")
            local util = require("cursor-agent.util")
            local cfg_mod = require("cursor-agent.config")

            -- Override toggle_terminal to use a vertical split instead of a float
            ca._term_state = ca._term_state or { win = nil, bufnr = nil, job_id = nil }

            ca.toggle_terminal = function()
                local st = ca._term_state

                if st.win and vim.api.nvim_win_is_valid(st.win) then
                    vim.api.nvim_win_close(st.win, true)
                    st.win = nil
                    return
                end

                local function job_is_alive(jid)
                    if not jid or jid == 0 then return false end
                    local ok, res = pcall(vim.fn.jobwait, { jid }, 0)
                    return ok and type(res) == "table" and res[1] == -1
                end

                if st.bufnr and vim.api.nvim_buf_is_valid(st.bufnr) and job_is_alive(st.job_id) then
                    vim.cmd("botright vsplit")
                    vim.api.nvim_win_set_buf(0, st.bufnr)
                    st.win = vim.api.nvim_get_current_win()
                    vim.cmd("startinsert")
                    return
                end

                local cfg = cfg_mod.get()
                local argv = util.concat_argv(util.to_argv(cfg.cmd), cfg.args)
                local root = util.get_project_root()

                vim.cmd("botright vsplit")
                st.win = vim.api.nvim_get_current_win()
                st.bufnr = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_buf_set_option(st.bufnr, "bufhidden", "hide")
                vim.api.nvim_win_set_buf(st.win, st.bufnr)

                st.job_id = vim.fn.termopen(argv, {
                    cwd = root,
                    on_exit = function(_, code)
                        if ca._term_state then ca._term_state.job_id = nil end
                        if code ~= 0 then
                            util.notify(("cursor-agent exited with code %d"):format(code), vim.log.levels.WARN)
                        end
                    end,
                })
                vim.cmd("startinsert")
            end

            vim.keymap.set("n", "<leader>ag", function() ca.toggle_terminal() end, { desc = "Cursor Agent: toggle" })
            vim.keymap.set("v", "<leader>ag", ":CursorAgentSelection<CR>", { desc = "Cursor Agent: send selection" })
            vim.keymap.set("n", "<leader>aG", "<cmd>CursorAgentBuffer<CR>", { desc = "Cursor Agent: send buffer" })
        end,
    },
    {
        src = "https://github.com/coder/claudecode.nvim",
        config = function()
            require("claudecode").setup({
                terminal_cmd = "/home/edwin.chen/.local/bin/claude --dangerously-skip-permissions",
                terminal = {
                    split_side = "right",
                    cwd_provider = function(ctx)
                        -- Prefer repo root; fallback to file's directory
                        local cwd = require("claudecode.cwd").git_root(ctx.file_dir or ctx.cwd)
                            or ctx.file_dir
                            or ctx.cwd
                        return cwd
                    end,
                },
            })

            -- Claude shortcuts: <leader>ac*
            vim.keymap.set("n", "<Leader>ac", function()
                local focused = pcall(vim.cmd, "ClaudeCodeFocus")
                if not focused then
                    vim.cmd("ClaudeCode --resume")
                end
            end, { desc = "Focus/Resume Claude" })

            -- Insert text into the Claude prompt without submitting it. Sends the
            -- string straight to the terminal job's stdin (Claude's TUI shows it in
            -- the input box). No trailing newline, so you can keep typing/editing.
            local function send_to_claude_prompt(text)
                local term = require("claudecode.terminal")
                term.ensure_visible() -- create/show the terminal if it isn't already
                local bufnr = term.get_active_terminal_bufnr()
                if not bufnr then
                    vim.notify("No active Claude terminal", vim.log.levels.WARN)
                    return
                end
                local chan = vim.b[bufnr].terminal_job_id
                if not chan then
                    vim.notify("Claude terminal has no job channel", vim.log.levels.WARN)
                    return
                end
                vim.fn.chansend(chan, text)
                local win = vim.fn.bufwinid(bufnr)
                if win ~= -1 then
                    vim.api.nvim_set_current_win(win)
                    vim.cmd("startinsert")
                end
            end

            -- Visual mode: send the highlighted selection (with file + line range)
            -- to Claude as an at-mention reference.
            vim.keymap.set("v", "<Leader>as", "<cmd>ClaudeCodeSend<CR>", { desc = "Send selection to Claude" })

            -- Normal mode: send the current buffer's full path to the Claude prompt.
            vim.keymap.set("n", "<Leader>af", function()
                local path = vim.fn.expand("%:p")
                if path == "" then
                    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
                    return
                end
                send_to_claude_prompt(path .. " ")
            end, { desc = "Send current file path to Claude prompt" })

            -- Track the most-recently-active real file buffer. We can't use the
            -- alternate-buffer register (#) for this: # is per-window, and the
            -- Claude terminal window's alternate file is frozen to whatever was
            -- showing when the terminal first loaded — switching buffers in other
            -- windows never updates it. So record it ourselves on every BufEnter.
            local last_file_group = vim.api.nvim_create_augroup("ClaudeLastFile", { clear = true })
            vim.api.nvim_create_autocmd("BufEnter", {
                group = last_file_group,
                callback = function(ev)
                    if vim.bo[ev.buf].buftype == "" then
                        local name = vim.api.nvim_buf_get_name(ev.buf)
                        if name ~= "" then
                            vim.g.claude_last_file = name
                        end
                    end
                end,
            })

            -- Terminal mode: while typing in the Claude window, insert the path of
            -- the most-recently-active file buffer into the prompt.
            vim.keymap.set("t", "<C-f>", function()
                local path = vim.g.claude_last_file
                if not path or path == "" then
                    return
                end
                local chan = vim.b.terminal_job_id
                if chan then
                    vim.fn.chansend(chan, path .. " ")
                end
            end, { desc = "Insert previous file path into Claude prompt" })

            -- Window-move shortcuts scoped to the Claude terminal only (so they
            -- don't shadow bash's Ctrl-R history search in regular terminals).
            -- Escape to Normal mode, move the window, then resume terminal insert.
            local claude_term_keys = vim.api.nvim_create_augroup("ClaudeTermKeys", { clear = true })
            vim.api.nvim_create_autocmd("TermOpen", {
                group = claude_term_keys,
                callback = function(ev)
                    if not vim.api.nvim_buf_get_name(ev.buf):lower():find("claude") then
                        return
                    end
                    vim.keymap.set("t", "<C-b>", [[<C-\><C-n><C-w>Ji]],
                        { buffer = ev.buf, silent = true, desc = "Claude: move window to bottom" })
                    vim.keymap.set("t", "<C-r>", [[<C-\><C-n><C-w>Li]],
                        { buffer = ev.buf, silent = true, desc = "Claude: move window to right" })
                end,
            })
        end,
    },
    --{
    --    src = "https://github.com/carlos-algms/agentic.nvim.git",
    --    config = function()
    --        require("agentic").setup({
    --            acp_providers = {
    --                ["claude-agent-acp"] = {
    --                    default_mode = "bypassPermissions", -- Automatically switch to this mode when a new session starts
    --                },
    --            }
    --        })
    --
    --        vim.keymap.set("n", "<leader>0", function()
    --            require("agentic").new_session()
    --        end, { desc = "Agentic restore session" })
    --    end,
    --},
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
            vim.keymap.set("n", "<leader>di", dap.pause, { desc = "Pause/Interrupt" })
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
                else
                    vim.lsp.buf.hover()
                end
            end
            vim.keymap.set({"n", "v"}, "K", dap_eval, { desc = "DAP eval / LSP hover" })
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
vim.keymap.set("n", "<leader>lb", vim.lsp.buf.format, { desc = "Beautify current file" })
vim.keymap.set("n", "<leader>lf", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = { "class", "method", "function" }, symbol_width = 100, symbol_type_width = 12, path_display = { "truncate" } }) end, { desc = "Search workspace methods and functions" })
vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>fw", function()
    local word = vim.fn.expand("<cword>")
    vim.fn.setreg("/", "\\<" .. word .. "\\>")
    vim.o.hlsearch = true
    vim.ui.input({ prompt = "Grep path: ", default = ".", completion = "dir" }, function(path)
        if path then
            require("telescope.builtin").live_grep({ search_dirs = { path }, default_text = word })
        end
    end)
end, { desc = "Grep current word recursively from prompted path" })
local build_job_id = nil
local build_efm = table.concat({
    "%f:%l:%c: %t%*[^:]: %m",
    "%f:%l: %t%*[^:]: %m",
    "%f:%l:%c: %m",
    "%f:%l: %m",
    "%+G%.%#",
}, ",")

-- Write only real, named, modified file buffers. A bare `:wall` aborts with
-- E141 on a modified no-name buffer and would also try to save terminal buffers.
local function save_all_files()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(b)
            and vim.bo[b].modified
            and vim.bo[b].buftype == ""
            and vim.api.nvim_buf_get_name(b) ~= "" then
            vim.api.nvim_buf_call(b, function() vim.cmd("silent write") end)
        end
    end
end

local function run_build(script, outfile)
    if build_job_id then vim.fn.jobstop(build_job_id) end
    vim.g.last_build_output = outfile
    save_all_files()
    vim.fn.setqflist({}, "r")
    vim.cmd("copen")

    local function process(data)
        if not data then return end
        local items = vim.fn.getqflist({ lines = data, efm = build_efm }).items
        if #items > 0 then vim.fn.setqflist(items, "a") end
    end

    build_job_id = vim.fn.jobstart(vim.fn.expand("~/bin/") .. script, {
        stdout_buffered = false,
        stderr_buffered = false,
        on_stdout = function(_, data) process(data) end,
        on_stderr = function(_, data) process(data) end,
        on_exit = function()
            build_job_id = nil
            -- Final pass: re-parse the full output file for accuracy
            local f = io.open(outfile, "r")
            if not f then return end
            local lines = {}
            for line in f:lines() do table.insert(lines, line) end
            f:close()
            vim.schedule(function()
                vim.fn.setqflist({}, "r", { lines = lines, efm = build_efm })
            end)
        end,
    })
end

vim.keymap.set("i", "<RightMouse>", '<C-r>+', { desc = "Paste from clipboard" })

vim.keymap.set("n", "<C-/>", "gcc", { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("n", "<RightMouse>", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>cd", function()
  local dir = vim.fn.expand("%:p:h")
  vim.fn.chdir(dir)
  vim.notify("cd " .. dir)
end, { desc = "Change to current file's directory" })
vim.keymap.set("n", "<leader>T", "<CMD>vsplit term://bash<CR>i", { desc = "Open terminal in vertical split and insert mode" })
vim.keymap.set("n", "<leader>q", function() save_all_files(); vim.cmd("qall!") end, { desc = "Write all and quit" })
vim.keymap.set("n", "<leader>r", function() require("telescope.builtin").oldfiles() end, { desc = "Recently opened files with preview" })
vim.keymap.set("n", "<leader>t", "<CMD>split term://bash<CR>i", { desc = "Open terminal in horizontal split and insert mode" })
vim.keymap.set("n", "<leader>w", save_all_files, { desc = "Write all" })
vim.keymap.set("n", "<leader>|", "<CMD>vsplit<CR><C-w>w", { desc = "Split vertically" })
vim.keymap.set("n", "gd", function() require("telescope.builtin").lsp_definitions() end, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>mm", function() run_build("buildm.sh", "/tmp/outm") end, { desc = "Make monorepo" })
vim.keymap.set("n", "<leader>ms", function() run_build("builds.sh", "/tmp/outs") end, { desc = "Make snap" })
vim.keymap.set("n", "<leader>mt", function() run_build("buildt.sh", "/tmp/outt") end, { desc = "Make trader-repo" })
vim.keymap.set("n", "<leader>mq", function() require("telescope.builtin").quickfix() end, { desc = "Browse build errors with preview" })
vim.keymap.set("n", "<leader>mx", function()
    if build_job_id then vim.fn.jobstop(build_job_id); build_job_id = nil end
    vim.cmd("wall!")
    vim.fn.setqflist({}, "r")
end, { desc = "Stop make jobs" })
vim.keymap.set("n", "<leader>n", "<CMD>edit $MYVIMRC<CR>", { desc = "Edit nvim's init.lua" })
vim.keymap.set("n", "<leader>N", "<CMD>update<CR> :source $MYVIMRC<CR>", { desc = "Re-read nvim's init.lua" })
vim.keymap.set("n", "<leader>o", function()
    local seen = {}
    local dirs = {}
    for _, dir in ipairs(vim.opt.path:get()) do
        dir = dir:gsub("%*%*$", ""):gsub("/$", "")
        if dir ~= "" and dir ~= "." and not seen[dir] then
            seen[dir] = true
            table.insert(dirs, dir)
        end
    end
    require("telescope.builtin").find_files({ search_dirs = dirs })
end, { desc = "Find and open file across path dirs" })

vim.keymap.set("t", "<C-Space>", "<C-\\><C-n><C-W>p", { desc = "Switch out of terminal or CClaude terminal" })
-- Enter Normal mode WITHOUT leaving the window, so you can scroll the terminal's
-- scrollback (e.g. Claude output): <C-q> then <C-u>/<C-b>/gg/etc, press i to resume.
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { desc = "Terminal: Normal mode (scroll in place)" })
--vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { desc = "Escape out of terminal mode" })

vim.keymap.set("v", "<C-/>", "gc",  { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("v", "<C-_>", "gc",  { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("v", "<RightMouse>", '"+p', { desc = "Paste from clipboard" })

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
        end, { buffer = true, desc = "Open file under cursor" })
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
        end, { buffer = true, desc = "Open file under cursor in previous window" })
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


vim.api.nvim_create_autocmd("BufWritePre", { -- trim trailing whitespace prior to saving
    pattern = { "*" },
    callback = function()
        local save_cursor = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]]) -- perform substitution
        vim.fn.winrestview(save_cursor) -- restore the cursor position
    end,
})

