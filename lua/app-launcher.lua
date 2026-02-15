local M = {}

local app_cache = {}

local function parse_desktop_file(file_path)
	local app = {
		name = "",
		exec = "",
		icon = "󰣆",
	}

	for line in io.lines(file_path) do
		local name = line:match("^Name=([^%[]+)")
		if name and app.name == "" then
			app.name = name
		end

		local exec = line:match("^Exec%s*=%s*(.+)")
		if exec then
			app.exec = exec:gsub("%%.-", ""):gsub("%s+.*", "")
		end

		local icon_line = line:match("^Icon%s*=%s*(.+)")
		if icon_line then
			app.icon = icon_line
		end
	end

	if not app.name or app.name == "" then
		return nil
	end
	if not app.exec or app.exec == "" then
		return nil
	end
	if not app.icon or app.icon == "" then
		app.icon = "󰣆"
	end

	return app
end

local function scan_applications()
	app_cache = {}

	local dirs = {
		"/usr/share/applications",
		"/usr/local/share/applications",
		vim.fn.expand("~/.local/share/applications"),
	}

	local apps = {}
	for _, dir in ipairs(dirs) do
		local handle = io.popen('ls -1 "' .. dir .. '" 2>/dev/null')
		if handle then
			for file in handle:lines() do
				if file:match("%.desktop$") then
					local app = parse_desktop_file(dir .. "/" .. file)
					if app and app.name and app.name ~= "" and app.exec and app.exec ~= "" then
						app.text = app.name
						table.insert(apps, app)
					end
				end
			end
			handle:close()
		end
	end

	table.sort(apps, function(a, b)
		return a.name:lower() < b.name:lower()
	end)

	app_cache = apps
	return apps
end

local function launch_app(app)
	local cmd = app.exec
	if cmd and cmd ~= "" then
		vim.fn.jobstart({ "sh", "-c", "setsid -f " .. cmd .. " &" })
	end
end

function M.pick()
	local apps = scan_applications()

	local items = {}
	for _, app in ipairs(apps) do
		table.insert(items, {
			text = app.name,
			exec = app.exec,
			icon = app.icon,
		})
	end

	require("snacks").picker({
		title = "󰣆 Applications",
		items = items,
		format = function(item, _)
			return {
				{ item.icon or "󰣆", "SnacksPickerIcon" },
				{ " " },
				{ item.text, "SnacksPickerTitle" },
			}
		end,
		layout = { preset = "default" },
		confirm = function(self, item)
			if item and item.exec then
				launch_app(item)
				self:close()
			end
		end,
	})
end

return M
