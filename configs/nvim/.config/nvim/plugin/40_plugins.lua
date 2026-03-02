local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = vim.fn.argc(-1) > 0 and MiniDeps.now or MiniDeps.later

now(function()
	add("neovim/nvim-lspconfig")

	-- Diagnostics
	vim.diagnostic.config({
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		virtual_text = { spacing = 4, source = "if_many" },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "E",
				[vim.diagnostic.severity.WARN] = "W",
				[vim.diagnostic.severity.HINT] = "H",
				[vim.diagnostic.severity.INFO] = "I",
			},
		},
	})

	-- Global capabilities
	local capabilities = rawget(_G, "MiniCompletion") ~= nil and MiniCompletion.get_lsp_capabilities()
		or vim.lsp.protocol.make_client_capabilities()
	vim.lsp.config("*", { capabilities = capabilities })
	-- Server configs
	local servers = {
		ts_ls = {
			capabilities = {
				general = { positionEncodings = { "utf-16" } },
			},
		},

		biome = {
			capabilities = {
				general = { positionEncodings = { "utf-16" } },
			},
		},

		gopls = {
			settings = {
				gopls = {
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		},

		ruby_lsp = {},

		solargraph = {},

		lua_ls = {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim", "MiniDeps" } },
					workspace = { checkThirdParty = false },
					hint = { enable = true },
				},
			},
		},
	}

	for server, config in pairs(servers) do
		vim.lsp.config(server, config)
		vim.lsp.enable(server)
	end
end)

now(function()
	add("folke/tokyonight.nvim")
	require("tokyonight").setup({
		style = "storm",
	})
	vim.cmd("colorscheme tokyonight")
end)

now(function()
	add("mason-org/mason.nvim")
	require("mason").setup()

	local registry = require("mason-registry")

	local tools = {
		-- LSP servers
		"typescript-language-server", -- ts_ls
		"biome", -- TS/JS linter + formatter
		"gopls", -- Go
		"ruby-lsp", -- Ruby (Shopify)
		"solargraph", -- Ruby (classic)
		"lua-language-server", -- lua_ls
		-- Formatters
		"prettierd", -- TS/JS fallback formatter
		"goimports", -- Go imports + format
		"stylua", -- Lua
		"rubocop", -- Ruby
		'tree-sitter-cli',
	}

	registry.refresh(function()
		for _, name in ipairs(tools) do
			local ok, pkg = pcall(registry.get_package, name)
			if ok and not pkg:is_installed() then
				pkg:install()
			end
		end
	end)
end)

now_if_args(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	add("nvim-treesitter/nvim-treesitter-textobjects")
	local languages = {
		"bash",
		"comment",
		"css",
		"diff",
		"dockerfile",
		"editorconfig",
		"fish",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"go",
		"gomod",
		"gosum",
		"html",
		"javascript",
		"json",
		"python",
		"rbs",
		"ruby",
		"rust",
		"sql",
		"ssh_config",
		"tmux",
		"tsx",
		"typescript",
		"yaml",
		"zsh",
	}
	local isnt_installed = function(lang)
		return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
	end
	local to_install = vim.tbl_filter(isnt_installed, languages)
	if #to_install > 0 then
		require("nvim-treesitter").install(to_install)
	end

	local filetypes = {}
	for _, lang in ipairs(languages) do
		for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
			table.insert(filetypes, ft)
		end
	end
	local ts_start = function(ev)
		vim.treesitter.start(ev.buf)
	end
	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
		pattern = filetypes,
		callback = ts_start,
		desc = "Start tree-sitter",
	})
end)

later(function()
	add("stevearc/conform.nvim")
	require("conform").setup({
		formatters_by_ft = {
			javascript = { "biome", "prettierd", stop_after_first = true },
			javascriptreact = { "biome", "prettierd", stop_after_first = true },
			typescript = { "biome", "prettierd", stop_after_first = true },
			typescriptreact = { "biome", "prettierd", stop_after_first = true },
			json = { "biome", "prettierd", stop_after_first = true },
			jsonc = { "biome", "prettierd", stop_after_first = true },
			go = { "goimports", "gofmt" },
			ruby = { "rubocop" },
			lua = { "stylua" },
		},

		formatters = {
			biome = {
				require_cwd = true,
				cwd = require("conform.util").root_file({ "biome.json", "biome.jsonc" }),
			},
		},
	})
end)
