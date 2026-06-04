vim.g.mapleader = ','
vim.g.maplocalleader = ','

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.colorcolumn = '100'
vim.opt.textwidth = 100
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.shada = "!,'10000,<50,s10,h" -- increase oldfiles max count to 10_000
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.backupcopy = 'yes'

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<c-left>', '<c-w>h')
vim.keymap.set('n', '<c-down>', '<c-w>j')
vim.keymap.set('n', '<c-up>', '<c-w>k')
vim.keymap.set('n', '<c-right>', '<c-w>l')
vim.keymap.set('n', '<Home>', '^')
vim.keymap.set('i', '<Home>', '<C-o>^')
local copy_keymap = function(mode, from_lhs, to_lhs)
  local keymap = vim.fn.maparg(from_lhs, mode, false, true)
  local rhs = keymap.callback or keymap.rhs
  vim.keymap.set(mode, to_lhs, rhs, { desc = keymap.desc })
end
copy_keymap('x', 'an', '<Tab>')
copy_keymap('x', 'in', '<S-Tab>')

vim.cmd [[cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))]]
vim.cmd [[cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))]]

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'css,scss,less',
  command = 'setl iskeyword+=-',
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    ---@param command string
    local function build(command)
      vim.print('Building ' .. ev.data.spec.name)
      vim.system(vim.split(command, ' '), { cwd = ev.data.path }):wait()
      vim.print('Built ' .. ev.data.spec.name)
    end

    if ev.data.spec.name == 'telescope-fzf-native.nvim' then
      build 'make'
    elseif ev.data.spec.name == 'blink.cmp' then
      vim.cmd.packadd 'blink.lib'
      vim.cmd.packadd 'blink.cmp'
      require('blink.cmp').build():wait(60000)
    elseif ev.data.spec.name == 'nvim-treesitter' then
      vim.cmd.packadd 'nvim-treesitter'
      vim.cmd 'TSUpdate'
    end
  end,
})

vim.pack.add { { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' } }
vim.cmd.colorscheme 'catppuccin'

vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }
local filename_with_relative_path = { 'filename', path = 1 }
require('lualine').setup {
  options = {
    theme = 'auto',
    icons_enabled = false,
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_c = { filename_with_relative_path },
  },
  inactive_sections = {
    lualine_c = { filename_with_relative_path },
  },
}

vim.pack.add { 'https://github.com/f-person/auto-dark-mode.nvim' }
require('auto-dark-mode').setup {}

vim.pack.add { 'https://github.com/tpope/vim-sleuth' } -- Detect tabstop and shiftwidth automatically
vim.pack.add { 'https://github.com/ruanyl/vim-gh-line' }
vim.pack.add { 'https://github.com/whiteinge/diffconflicts' }
vim.pack.add { 'https://github.com/stevearc/oil.nvim' }
require('oil').setup {
  view_options = {
    show_hidden = true,
  },
}
vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }
vim.pack.add { 'https://github.com/ethanholz/nvim-lastplace' }
require('nvim-lastplace').setup {}

vim.pack.add { 'https://github.com/stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = true,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 500,
        lsp_format = 'prefer',
      }
    end
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'black' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    json = { 'prettier' },
    markdown = { 'prettier' },
    css = { 'prettier' },
    html = { 'prettier' },
    nix = { 'nixfmt' },
  },
}

vim.pack.add {
  'https://github.com/saghen/blink.lib',
  'https://github.com/saghen/blink.cmp',
}

require('blink.cmp').setup {
  completion = {
    accept = {
      -- Make sure blink does not add parenthesis when completing a function
      auto_brackets = { enabled = false },
    },
  },
}

vim.pack.add { 'https://github.com/folke/todo-comments.nvim' }
require('todo-comments').setup {
  signs = false,
}

vim.pack.add { 'https://github.com/echasnovski/mini.nvim' }
require('mini.surround').setup {}
require('mini.snippets').setup {}

vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter' }
require('nvim-treesitter').setup()
require('nvim-treesitter').install {
  'bash',
  'c',
  'css',
  'diff',
  'go',
  'html',
  'html',
  'javascript',
  'json',
  'just',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'rust',
  'tsx',
  'typescript',
  'vim',
  'vim',
  'vimdoc',
}

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter.setup', {}),
  callback = function(args)
    local buf = args.buf
    local filetype = args.match

    local language = vim.treesitter.language.get_lang(filetype) or filetype
    if not vim.treesitter.language.add(language) then
      return
    end

    vim.treesitter.start(buf, language)
  end,
})

vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim', -- Dependency of telescope
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  'https://github.com/nvim-telescope/telescope-symbols.nvim',
}
local actions = require 'telescope.actions'
local telescope = require 'telescope'
telescope.setup {
  defaults = {
    layout_strategy = 'vertical',
    mappings = {
      i = {
        ['<esc>'] = actions.close,
      },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}

telescope.load_extension 'fzf'
telescope.load_extension 'ui-select'
local builtin = require 'telescope.builtin'
vim.keymap.set({ 'n', 'i' }, '<F1>', function()
  local opts = {}
  vim.fn.system 'git rev-parse --is-inside-work-tree'
  if vim.v.shell_error == 0 then
    builtin.git_files(opts)
  else
    builtin.find_files(opts)
  end
end, {})

vim.keymap.set({ 'n', 'i' }, '<F2>', function()
  builtin.buffers {
    ignore_current_buffer = true,
    sort_mru = true,
  }
end, {})

vim.keymap.set('n', '<leader>gm', function()
  builtin.symbols { sources = { 'emoji', 'kaomoji', 'gitmoji' } }
end, {})

vim.keymap.set({ 'n', 'i' }, '<F3>', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>lg', function()
  builtin.live_grep { additional_args = { '--hidden' } }
end)
vim.keymap.set({ 'n', 'v' }, '<leader>gs', function()
  builtin.grep_string { additional_args = { '--hidden' } }
end)

vim.pack.add { 'https://github.com/folke/lazydev.nvim' }
require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
}

vim.pack.add { 'https://github.com/neovim/nvim-lspconfig' }

vim.lsp.log.set_level 'info'
vim.lsp.inlay_hint.enable(true)

local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config('eslint', {
  filetypes = vim.list_extend(vim.lsp.config.eslint.filetypes, { 'css' }),

  settings = {
    nodePath = '.yarn/sdks',
    workingDirectory = {
      -- Defaults to 'auto', and eslint will look for the closest directory containing a
      -- package.json file. This breaks eslint-import-resolver-typescript because it reads the
      -- tsconfig in cwd, and there isn't any.
      -- Issue: https://github.com/neovim/nvim-lspconfig/issues/4227
      mode = 'location',
    },
  },
  on_attach = function(client, bufnr)
    if base_on_attach then
      base_on_attach(client, bufnr)
    end
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      command = 'LspEslintFixAll',
    })
  end,
})

-- Use the project-local oxfmt binary when available, so the LSP version
-- matches the project-pinned version and reads oxfmt.config.ts correctly.
vim.lsp.config('oxfmt', {
  cmd = function(dispatchers, config)
    local root = (config or {}).root_dir
    local cmd = 'oxfmt'
    if root then
      local candidates = {
        vim.fs.joinpath(root, '.yarn/sdks/oxfmt/bin-oxfmt.js'),
        vim.fs.joinpath(root, 'node_modules/.bin/oxfmt'),
      }
      for _, candidate in ipairs(candidates) do
        if vim.fn.executable(candidate) == 1 then
          cmd = candidate
          break
        end
      end
    end
    return vim.lsp.rpc.start({ cmd, '--lsp' }, dispatchers)
  end,
})

vim.pack.add { 'https://github.com/williamboman/mason.nvim' }
require('mason').setup {}

vim.pack.add { 'https://github.com/williamboman/mason-lspconfig.nvim' }
require('mason-lspconfig').setup {
  ensure_installed = {
    'lua_ls',
    'ts_ls',
    'pyright',
    'gopls',
    'rust_analyzer',
    'cssls',
    'html',
  },
}

vim.pack.add { 'https://github.com/j-hui/fidget.nvim' }
require('fidget').setup {
  notification = {
    override_vim_notify = true,
  },
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf }
    local telescope_builtins = require 'telescope.builtin'

    -- Disable formatting overhide so I can use gqq. Formatting is done via
    -- conform.nvim anyway.
    vim.bo[event.buf].formatexpr = nil

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', telescope_builtins.lsp_definitions, opts)
    vim.keymap.set('n', 'gD', telescope_builtins.lsp_type_definitions, opts)
    vim.keymap.set('n', 'gi', telescope_builtins.lsp_implementations, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', telescope_builtins.lsp_references, opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)

    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'i' }, '<c-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set({ 'n', 'v' }, 'k', vim.lsp.buf.code_action, opts)

    vim.keymap.set('n', '<leader>d', telescope_builtins.diagnostics, {})
    vim.keymap.set('n', 'l', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<c-s-n>', function()
      vim.diagnostic.jump {
        count = -1,
        float = { border = 'rounded', scope = 'line' },
      }
    end, opts)
    vim.keymap.set('n', '<c-n>', function()
      vim.diagnostic.jump {
        count = 1,
        float = { border = 'rounded', scope = 'line' },
      }
    end, opts)

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  end,
})

-- Diagnostic Config
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded' },
  virtual_lines = false,
}
vim.pack.add { 'https://github.com/rafikdraoui/jj-diffconflicts' }
