local M = {}

local function get_branches(all_branches, callback)
	local args = all_branches and { "git", "branch", "-a" } or { "git", "branch" }
	vim.system(args, { text = true }, function(obj)
		if obj.code ~= 0 then
			vim.schedule(function()
				callback("Error: " .. obj.stderr)
			end)
			return
		end

		local branches = {}
		for _, line in ipairs(vim.split(obj.stdout, "\n")) do
			local trimmed = vim.trim(line)
			if trimmed ~= "" then
				local is_current = trimmed:match("^%*")
				local name = trimmed:gsub("^%*%s*", ""):gsub("^%s*", "")
				if name ~= "" and not name:match("^%(HEAD detached") then
					table.insert(branches, {
						name = name,
						current = is_current ~= "",
					})
				end
			end
		end

		vim.schedule(function()
			callback(branches)
		end)
	end)
end

local function get_current_branch(callback)
	vim.system({ "git", "branch", "--show-current" }, { text = true }, function(obj)
		vim.schedule(function()
			callback(vim.trim(obj.stdout))
		end)
	end)
end

local function checkout_branch(branch, callback)
	vim.system({ "git", "status", "--porcelain" }, { text = true }, function(status_obj)
		local has_changes = status_obj.stdout and status_obj.stdout ~= ""
		
		local function do_checkout()
			vim.system({ "git", "checkout", branch }, { text = true }, function(obj)
				vim.schedule(function()
					if obj.code == 0 then
						if has_changes then
							vim.system({ "git", "stash", "pop" }, { text = true }, function()
								callback(true, obj.stdout, obj.stderr)
							end)
						else
							callback(true, obj.stdout, obj.stderr)
						end
					else
						callback(false, obj.stdout, obj.stderr)
					end
				end)
			end)
		end
		
		if has_changes then
			vim.system({ "git", "stash", "push", "-m", "stashed by nvim-git-picker" }, { text = true }, function(stash_obj)
				if stash_obj.code == 0 then
					do_checkout()
				else
					vim.schedule(function()
						callback(false, stash_obj.stdout, stash_obj.stderr)
					end)
				end
			end)
		else
			do_checkout()
		end
	end)
end

local function get_log(callback)
	vim.system({ "git", "log", "--oneline", "-20" }, { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				callback(nil, obj.stderr)
				return
			end
			callback(obj.stdout, nil)
		end)
	end)
end

local function get_status(callback)
	vim.system({ "git", "status", "--porcelain" }, { text = true }, function(obj)
		vim.schedule(function()
			callback(obj.stdout)
		end)
	end)
end

local function commit_to_branch(branch, message, callback)
	vim.system({ "git", "checkout", branch }, { text = true }, function(checkout_obj)
		if checkout_obj.code ~= 0 then
			vim.schedule(function()
				callback(false, "Failed to checkout: " .. checkout_obj.stderr)
			end)
			return
		end

		vim.system({ "git", "add", "-A" }, { text = true }, function(add_obj)
			if add_obj.code ~= 0 then
				vim.schedule(function()
					callback(false, "Failed to stage: " .. add_obj.stderr)
				end)
				return
			end

			vim.system({ "git", "commit", "-m", message }, { text = true }, function(commit_obj)
				vim.schedule(function()
					if commit_obj.code == 0 then
						callback(true, "Committed to: " .. branch)
					else
						callback(false, "Failed to commit: " .. commit_obj.stderr)
					end
				end)
			end)
		end)
	end)
end

local function show_log()
	get_log(function(stdout, stderr)
		if stderr then
			vim.notify("Error: " .. stderr, vim.log.levels.ERROR)
			return
		end

		local lines = vim.split(stdout, "\n")
		if #lines == 0 or (lines[1] and vim.trim(lines[1]) == "") then
			vim.notify("No commits yet", vim.log.levels.WARN)
			return
		end

		local buf_name = "git-log"
		local existing_buf = vim.fn.bufnr(buf_name)
		if existing_buf ~= -1 then
			vim.api.nvim_buf_delete(existing_buf, { force = true })
		end

		local buf = vim.api.nvim_create_buf(true, false)
		vim.api.nvim_buf_set_name(buf, buf_name)
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

		local win = vim.api.nvim_open_win(buf, true, {
			relative = "editor",
			width = math.floor(vim.o.columns * 0.7),
			height = math.floor(vim.o.lines * 0.6),
			col = math.floor(vim.o.columns * 0.15),
			row = math.floor(vim.o.lines * 0.2),
			border = "rounded",
		})

		vim.api.nvim_win_set_option(win, "wrap", true)
		vim.api.nvim_win_set_option(win, "cursorline", true)
		vim.api.nvim_buf_set_option(buf, "filetype", "git")
		vim.api.nvim_buf_set_option(buf, "modifiable", false)

		vim.keymap.set("n", "q", function()
			vim.api.nvim_win_close(win, true)
		end, { buffer = buf, silent = true })

		vim.keymap.set("n", "<Esc>", function()
			vim.api.nvim_win_close(win, true)
		end, { buffer = buf, silent = true })
	end)
end

function M.pick()
	get_current_branch(function(current)
		get_branches(false, function(branches)
			if type(branches) == "string" then
				vim.notify(branches, vim.log.levels.ERROR)
				return
			end

			local items = {
				{
					text = "Switch Branch",
					icon = "󰊢",
					action = "switch",
				},
				{
					text = "Show Git Log",
					icon = "󰟔",
					action = "log",
				},
				{
					text = "Commit to Branch",
					icon = "󰜧",
					action = "commit",
				},
			}

			require("snacks").picker({
				title = "Git (current: " .. (current or "none") .. ")",
				items = items,
				format = function(item, _)
					return {
						{ item.icon, "SnacksPickerIcon" },
						{ " " },
						{ item.text, "SnacksPickerTitle" },
					}
				end,
				layout = { preset = "default" },
				confirm = function(self, item)
					if not item then
						return
					end

					if item.action == "switch" then
						self:close()
						M.switch_branch()
					elseif item.action == "log" then
						self:close()
						show_log()
					elseif item.action == "commit" then
						self:close()
						M.commit()
					end
				end,
			})
		end)
	end)
end

function M.switch_branch()
	get_current_branch(function(current)
		get_branches(true, function(branches)
			if type(branches) == "string" then
				vim.notify(branches, vim.log.levels.ERROR)
				return
			end

			local items = {}
			for _, b in ipairs(branches) do
				table.insert(items, {
					text = b.name,
					branch = b,
				})
			end

			require("snacks").picker({
				title = "Switch Branch (current: " .. (current or "none") .. ")",
				items = items,
				format = function(item, _)
					local icon = "󰊢"
					local hl = "SnacksPickerTitle"
					if item.branch.current then
						icon = "󰜤"
						hl = "SnacksPickerActive"
					elseif item.branch.name:match("^remotes/") then
						icon = "󰤤"
						hl = "SnacksPickerComment"
					end
					return {
						{ icon, "SnacksPickerIcon" },
						{ " " },
						{ item.text, hl },
					}
				end,
				layout = { preset = "default" },
				confirm = function(self, item)
					if item and item.branch then
						self:close()
						checkout_branch(item.branch.name, function(success, stdout, stderr)
							if success then
								vim.notify("Switched to: " .. item.branch.name, vim.log.levels.INFO)
								show_log()
							else
								vim.notify("Error: " .. (stderr or stdout), vim.log.levels.ERROR)
							end
						end)
					end
				end,
			})
		end)
	end)
end

function M.commit()
	get_branches(false, function(branches)
		if type(branches) == "string" then
			vim.notify(branches, vim.log.levels.ERROR)
			return
		end

		get_status(function(status)
			if status == "" then
				vim.notify("No changes to commit", vim.log.levels.WARN)
				return
			end

			local items = {}
			for _, b in ipairs(branches) do
				table.insert(items, {
					text = b.name,
					branch = b,
				})
			end

			require("snacks").picker({
				title = "Commit to Branch",
				items = items,
				format = function(item, _)
					return {
						{ "󰜤", "SnacksPickerIcon" },
						{ " " },
						{ item.text, "SnacksPickerTitle" },
					}
				end,
				layout = { preset = "default" },
				confirm = function(self, item)
					if item and item.branch then
						self:close()
						vim.ui.input({ prompt = "Commit message: " }, function(msg)
							if not msg or msg == "" then
								return
							end
							commit_to_branch(item.branch.name, msg, function(success, output)
								if success then
									vim.notify(output, vim.log.levels.INFO)
									show_log()
								else
									vim.notify(output, vim.log.levels.ERROR)
								end
							end)
						end)
					end
				end,
			})
		end)
	end)
end

function M.log()
	show_log()
end

return M
