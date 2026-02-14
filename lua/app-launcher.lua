local M = {}

local app_cache = {}
local icon_cache = {}

local function get_icon_from_desktop(file_path)
    local icon_key = file_path
    if icon_cache[icon_key] then
        return icon_cache[icon_key]
    end

    local icon = "󰣆"
    for line in io.lines(file_path) do
        local icon_line = line:match("^Icon%s*=%s*(.+)")
        if icon_line then
            icon = icon_line
            break
        end
    end
    icon_cache[icon_key] = icon
    return icon
end

local function parse_desktop_file(file_path)
    local app = {
        name = "",
        exec = "",
        icon = "󰣆",
        comment = "",
        file = file_path,
    }

    for line in io.lines(file_path) do
        local name = line:match("^Name%s*=%s*(.+)")
        if name then
            app.name = name
        end

        local exec = line:match("^Exec%s*=%s*(.+)")
        if exec then
            app.exec = exec:gsub("%%.-", ""):gsub("%s+.*", "")
        end

        local comment = line:match("^Comment%s*=%s*(.+)")
        if comment then
            app.comment = comment
        end
    end

    if app.name == "" or app.exec == "" then
        return nil
    end

    app.icon = get_icon_from_desktop(file_path)
    return app
end

local function scan_applications()
    if #app_cache > 0 then
        return app_cache
    end

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
                    if app and app.name ~= "" then
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

    table.insert(items, { text = "Custom Command...", app = { exec = "", custom = true } })

    for _, app in ipairs(apps) do
        table.insert(items, {
            text = app.name,
            app = app,
        })
    end

    require("snacks").picker({
        title = "󰣆 Applications",
        items = items,
        format = function(item, _)
            if item.app.custom then
                return {
                    { ">", "SnacksPickerIcon" },
                    { " " },
                    { item.text, "SnacksPickerTitle" },
                }
            end
            return {
                { item.app.icon, "SnacksPickerIcon" },
                { " " },
                { item.text, "SnacksPickerTitle" },
            }
        end,
        layout = {
            preset = "ivy",
        },
        confirm = function(self, item)
            if item and item.app then
                if item.app.custom then
                    vim.ui.input({ prompt = "Enter command: " }, function(cmd)
                        if cmd and cmd ~= "" then
                            vim.fn.jobstart({ "sh", "-c", "setsid -f kitty -e " .. cmd .. " &" })
                        end
                    end)
                else
                    launch_app(item.app)
                end
                self:close()
            end
        end,
    })
end

return M
