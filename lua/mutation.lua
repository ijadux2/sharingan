local M = {}

local snacks = require("snacks")

-- namespace for safety
local ns = vim.api.nvim_create_namespace("mutation")

-------------------------------------------------------
-- 1️⃣ Extract All Functions In Current Buffer
-------------------------------------------------------

local function get_functions()
	local ok, parser = pcall(vim.treesitter.get_parser, 0)
	if not ok or not parser then
		vim.notify("No Treesitter parser", vim.log.levels.WARN)
		return {}
	end

	local tree = parser:parse()[1]
	local root = tree:root()

	local functions = {}

	local function walk(node)
		local node_type = node:type()

		if node_type:match("function") or node_type:match("method") then
			local start_row, _, end_row, _ = node:range()

			-- Try to extract name
			local name = "anonymous"

			for child in node:iter_children() do
				if
					child:type():match("identifier")
					or child:type():match("property_identifier")
					or child:type():match("word")
				then
					name = vim.treesitter.get_node_text(child, 0)
					break
				end
			end

			table.insert(functions, {
				name = name,
				start_row = start_row,
				end_row = end_row,
			})
		end

		for child in node:iter_children() do
			walk(child)
		end
	end

	walk(root)

	return functions
end

-------------------------------------------------------
-- 2️⃣ Generate Mutations (Simple MVP)
-------------------------------------------------------

local function generate_mutations(code)
	local variants = {}

	table.insert(variants, {
		label = "Add memoization",
		code = code .. "\n-- memoized version",
	})

	table.insert(variants, {
		label = "Convert to functional style",
		code = code:gsub("for", "while"),
	})

	table.insert(variants, {
		label = "Add logging",
		code = code .. "\nprint('debug')",
	})

	return variants
end

-------------------------------------------------------
-- 3️⃣ Replace Function
-------------------------------------------------------

local function replace_function(func, new_code)
	local lines = vim.split(new_code, "\n")
	vim.api.nvim_buf_set_lines(0, func.start_row, func.end_row + 1, false, lines)
end

-------------------------------------------------------
-- 4️⃣ Mutation Picker
-------------------------------------------------------

local function mutation_picker(func)
	local code = table.concat(vim.api.nvim_buf_get_lines(0, func.start_row, func.end_row + 1, false), "\n")

	local mutations = generate_mutations(code)

	snacks.picker({
		title = "🧬 Mutations for " .. func.name,
		items = vim.tbl_map(function(m)
			return {
				text = m.label,
				mutation = m,
			}
		end, mutations),

		on_select = function(item)
			replace_function(func, item.mutation.code)
		end,
	})
end

-------------------------------------------------------
-- 5️⃣ Function Picker
-------------------------------------------------------

function M.open()
	local functions = get_functions()

	if #functions == 0 then
		vim.notify("No functions found")
		return
	end

	snacks.picker({
		title = "Select Function",
		items = vim.tbl_map(function(f)
			return {
				text = f.name,
				func = f,
			}
		end, functions),

		on_select = function(item)
			mutation_picker(item.func)
		end,
	})
end

-------------------------------------------------------
-- Setup Command
-------------------------------------------------------

vim.api.nvim_create_user_command("Mutation", function()
	M.open()
end, {})

return M
