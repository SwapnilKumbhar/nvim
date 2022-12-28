local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local nls = require("null-ls")

-- Just shorthands
local fmt = nls.builtins.formatting

-- Sources
local sources = {
	fmt.stylua,
	fmt.black,
	fmt.clang_format.with({
		args = { "--style=Mozilla" },
	}),
	fmt.eslint_d,
}

-- Setup
nls.setup({
	sources = sources,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
