local now, later = MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later

now(function()
	require("mini.icons").setup()
end)
now(function()
	require("mini.notify").setup()
end)
now(function()
	require("mini.statusline").setup()
end)
now(function()
	require("mini.tabline").setup()
end)

-- later(function() require('mini.ai').setup() end)
later(function()
	require("mini.bufremove").setup()
end)
later(function()
	require("mini.comment").setup()
end)
later(function()
	require("mini.cmdline").setup()
end)
later(function()
	require("mini.diff").setup()
end)
later(function()
	require("mini.files").setup()
end)
later(function()
	require("mini.git").setup()
end)
later(function()
	require("mini.misc").setup()
end)
later(function()
	require("mini.pairs").setup()
end)
later(function()
	require("mini.pick").setup()
end)
later(function()
	require("mini.surround").setup()
end)
later(function()
	require("mini.trailspace").setup()
end)

later(function()
	local miniclue = require("mini.clue")
	miniclue.setup({
		triggers = {
			{ mode = { "n", "x" }, keys = "<Leader>" }, -- Leader triggers
			{ mode = "n", keys = "\\" }, -- mini.basics
			{ mode = { "n", "x" }, keys = "[" }, -- mini.bracketed
			{ mode = { "n", "x" }, keys = "]" },
			{ mode = "i", keys = "<C-x>" }, -- Built-in completion
			{ mode = { "n", "x" }, keys = "g" }, -- `g` key
			{ mode = { "n", "x" }, keys = "'" }, -- Marks
			{ mode = { "n", "x" }, keys = "`" },
			{ mode = { "n", "x" }, keys = '"' }, -- Registers
			{ mode = { "i", "c" }, keys = "<C-r>" },
			{ mode = "n", keys = "<C-w>" }, -- Window commands
			{ mode = { "n", "x" }, keys = "s" }, -- `s` key (mini.surround, etc.)
			{ mode = { "n", "x" }, keys = "z" }, -- `z` key
		},

		clues = {
			{ mode = "n", keys = "<Leader>b", desc = "+Buffer" },
			{ mode = "n", keys = "<Leader>e", desc = "+Explore/Edit" },
			{ mode = "n", keys = "<Leader>f", desc = "+Find" },
			{ mode = "n", keys = "<Leader>g", desc = "+Git" },
			{ mode = "n", keys = "<Leader>l", desc = "+Language" },
			{ mode = "n", keys = "<Leader>o", desc = "+Other" },
			{ mode = "n", keys = "<Leader>s", desc = "+Session" },
			{ mode = "n", keys = "<Leader>t", desc = "+Terminal" },
			{ mode = "n", keys = "<Leader>v", desc = "+Visits" },
			{ mode = "x", keys = "<Leader>g", desc = "+Git" },
			{ mode = "x", keys = "<Leader>l", desc = "+Language" },
			miniclue.gen_clues.builtin_completion(),
			miniclue.gen_clues.g(),
			miniclue.gen_clues.marks(),
			miniclue.gen_clues.registers(),
			miniclue.gen_clues.square_brackets(),
			miniclue.gen_clues.windows({ submode_resize = true }),
			miniclue.gen_clues.z(),
		},

		window = {
			delay = 500,
		},
	})
end)

now_if_args(function()
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(items, base, process_items_opts)
  end

  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,
      process_items = process_items,
    },
  })

  -- Set omnifunc only for buffers with active LSP
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('mini-completion', { clear = true }),
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    end,
    desc = "Set 'omnifunc' for LSP completion",
  })
end)
