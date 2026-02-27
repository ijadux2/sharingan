local M = {}

M.cache = {}

-- ---------- Utils ----------

local function run_cmd(cmd)
	local handle = io.popen(cmd)
	if not handle then
		return {}
	end
	local result = handle:read("*a")
	handle:close()
	return vim.split(result, "\n", { trimempty = true })
end

local function detect_lang()
	local ft = vim.bo.filetype
	if ft == "python" then
		return "python"
	elseif ft == "go" then
		return "go"
	elseif ft == "rust" then
		return "rust"
	elseif ft == "lua" then
		return "lua"
	else
		return "generic"
	end
end

local function cache_key(term)
	return detect_lang() .. "::" .. term
end

-- ---------- Providers ----------

local providers = {}

providers.man = function(term)
	local out = run_cmd("man -k " .. term .. " 2>/dev/null")
	local items = {}
	for _, line in ipairs(out) do
		table.insert(items, {
			text = "[man] " .. line,
			kind = "man",
		})
	end
	return items
end

providers.nvim = function(term)
	vim.cmd("silent helpgrep " .. term)
	local qf = vim.fn.getqflist()
	local items = {}
	for _, item in ipairs(qf) do
		table.insert(items, {
			text = "[nvim] " .. item.text,
			kind = "nvim",
			tag = item.text:match("%S+"),
		})
	end
	return items
end

providers.python = function(term)
	local out = run_cmd("python -m pydoc " .. term .. " 2>/dev/null")
	return {
		{
			text = "[python] " .. term,
			kind = "python",
			content = table.concat(out, "\n"),
		},
	}
end

providers.go = function(term)
	local out = run_cmd("go doc " .. term .. " 2>/dev/null")
	return {
		{
			text = "[go] " .. term,
			kind = "go",
			content = table.concat(out, "\n"),
		},
	}
end

providers.rust = function(term)
	local out = run_cmd("rustup doc --std 2>/dev/null")
	return {
		{
			text = "[rust] std docs",
			kind = "rust",
			content = table.concat(out, "\n"),
		},
	}
end

-- ---------- Search ----------

function M.search(term)
	if term == "" then
		return
	end

	local key = cache_key(term)
	if M.cache[key] then
		return M.open_picker(M.cache[key])
	end

	local results = {}

	for _, provider in pairs(providers) do
		local ok, items = pcall(provider, term)
		if ok and items then
			for _, item in ipairs(items) do
				table.insert(results, item)
			end
		end
	end

	M.cache[key] = results
	M.open_picker(results)
end

-- ---------- Snacks Picker ----------

function M.open_picker(results)
	local snacks = require("snacks")

	local items = {}

	for _, item in ipairs(results) do
		local buf = vim.api.nvim_create_buf(false, true)

		if item.content then
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(item.content, "\n"))
			pcall(vim.treesitter.start, buf)
		else
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, { item.text })
		end

		table.insert(items, {
			text = item.text,
			buf = buf,
			_doc_item = item, -- store original
		})
	end

	snacks.picker({
		title = "DocVim",
		items = items,

		confirm = function(picker, selected)
			local item = selected._doc_item
			M.open_item(item)
			picker:close()
		end,
	})
end

-- ---------- Open Handlers ----------

function M.open_item(item)
	if item.kind == "man" then
		local page = item.text:match("%[man%]%s+([^%s]+)")
		vim.cmd("Man " .. page)
	elseif item.kind == "nvim" then
		vim.cmd("help " .. item.tag)
	elseif item.content then
		vim.cmd("new")
		vim.bo.buftype = "nofile"
		vim.bo.bufhidden = "wipe"
		vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(item.content, "\n"))

		-- Tree-sitter highlight
		pcall(vim.treesitter.start)
	end
end

-- ---------- Command ----------

vim.api.nvim_create_user_command("Doc", function(opts)
	M.search(opts.args)
end, { nargs = 1 })

return M
