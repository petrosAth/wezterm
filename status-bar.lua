local wezterm = require("wezterm")
local colors = require("colors")
local pallete = require("palletes." .. os.getenv("SYSTEM_THEME"))
local icons = require("icons")

local function get_proc(tab, max_width)
    local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
    local shell = os.getenv("SHELL")

    if process_name == nil or process_name == "" then
        process_name = string.match(shell, ".*/(.*)$")
    end

    return string.format("%s %s", icons.proc, process_name)
end

local function get_cwd(uri, short)
    local cwd = uri

    if cwd == nil or cwd == "" then
        cwd = icons.empty
    else
        cwd = cwd:gsub("%w+://%w+/", "/") -- remove hostname
        cwd = cwd:sub(1, -2) -- remove last "/"

        local home = wezterm.home_dir
        if cwd == home then
            cwd = icons.home -- swap home path with "~" if at home
        end

        if string.match(cwd, "^/%w+/%w+") == home then
            cwd = cwd:gsub("^/%w+/%w+", icons.home) -- swap home path with "~" in path
        end

        if short and cwd ~= icons.home then
            cwd = string.match(cwd, ".*/(.*)$") -- keep only last directory
        end
    end

    return string.format("%s %s", icons.dir, cwd)
end

wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
    local color = colors.get(tab, hover)

    local function style_id()
        return wezterm.format({
            { Background = { Color = color.id.wrap.outer.base.bg } },
            { Foreground = { Color = color.id.wrap.outer.base.fg } },
            { Text = icons.wrap.right .. " " },
            { Background = { Color = color.id.text.base.bg } },
            { Foreground = { Color = color.id.text.base.fg } },
            { Attribute = { Intensity = "Bold" } },
            { Text = string.format("%s", tab.tab_index + 1) },
            { Foreground = { Color = color.id.wrap.inner.base.fg } },
            { Background = { Color = color.id.wrap.inner.base.bg } },
            { Text = icons.wrap.right },
        })
    end

    local function style_flag()
        local is_zoomed = tab.active_pane.is_zoomed
        local has_output = false

        for _, pane in ipairs(tab.panes) do
            if pane.has_unseen_output then
                has_output = true
            end
        end

        local function separator()
            if is_zoomed or has_output or #tab.panes > 1 then
                return wezterm.format({
                    { Background = { Color = color.title.sep.base.bg } },
                    { Foreground = { Color = color.title.sep.base.fg } },
                    { Text = string.format(" %s", icons.sep.right) },
                })
            end

            return ""
        end

        local function output_flag()
            if has_output then
                return wezterm.format({
                    { Background = { Color = color.title.text.base.bg } },
                    { Foreground = { Color = pallete.yellow } },
                    { Text = string.format(" %s", icons.output) },
                })
            end

            return ""
        end

        local function panes_flag()
            if #tab.panes > 1 then
                return wezterm.format({
                    { Background = { Color = color.title.text.base.bg } },
                    { Foreground = { Color = color.title.text.base.fg } },
                    { Text = string.format(" %s %s", icons.panes, #tab.panes) },
                })
            end

            return ""
        end

        local function zoom_flag()
            if is_zoomed then
                return wezterm.format({
                    { Background = { Color = color.title.text.base.bg } },
                    { Foreground = { Color = color.title.text.base.fg } },
                    { Text = string.format(" %s ", icons.zoom) },
                })
            end

            return ""
        end

        return wezterm.format({
            { Text = separator() },
            { Text = output_flag() },
            { Text = panes_flag() },
            { Text = zoom_flag() },
        })
    end

    local function style_title()
        return wezterm.format({
            { Background = { Color = color.title.text.base.bg } },
            { Foreground = { Color = color.title.text.base.fg } },
            { Text = " " .. get_cwd(tab.active_pane.current_working_dir, true) },
            { Background = { Color = color.title.sep.base.bg } },
            { Foreground = { Color = color.title.sep.base.fg } },
            { Text = string.format(" %s ", icons.sep.right) },
            { Background = { Color = color.title.text.base.bg } },
            { Foreground = { Color = color.title.text.base.fg } },
            { Text = get_proc(tab, max_width) },
            { Text = style_flag() },
            { Background = { Color = color.title.wrap.base.bg } },
            { Foreground = { Color = color.title.wrap.base.fg } },
            { Text = icons.wrap.right },
        })
    end

    return {
        { Text = style_id() },
        { Text = style_title() },
    }
end)

local function get_mode(window)
    local mode = {
        ["copy_mode"] = "COPY",
        ["leader"] = "LEADER",
        ["nil"] = "NORMAL",
        ["search_mode"] = "SEARCH",
        ["window_mode"] = "WINDOW",
    }

    if window:leader_is_active() then
        return mode["leader"]
    end

    return window:active_key_table() == nil and "NORMAL" or mode[window:active_key_table()]
end

wezterm.on("update-right-status", function(window, pane)
    local cwd = get_cwd(pane:get_current_working_dir())
    local mode_color = colors.get(false, false, get_mode(window))
    local cwd_color = colors.get(false, false, false, true)

    local function style_left_section_mode()
        return wezterm.format({
            { Background = { Color = mode_color.wrap.bg } },
            { Foreground = { Color = mode_color.wrap.fg } },
            { Text = icons.wrap.left },
            { Background = { Color = mode_color.text.bg } },
            { Foreground = { Color = mode_color.text.fg } },
            { Text = get_mode(window) },
            { Background = { Color = mode_color.wrap.bg } },
            { Foreground = { Color = mode_color.wrap.fg } },
            { Text = icons.wrap.right },
        })
    end

    local function style_right_section_cwd()
        return wezterm.format({
            { Background = { Color = cwd_color.status.cwd.wrap.bg } },
            { Foreground = { Color = cwd_color.status.cwd.wrap.fg } },
            { Text = icons.wrap.left },
            { Background = { Color = cwd_color.status.cwd.text.bg } },
            { Foreground = { Color = cwd_color.status.cwd.text.fg } },
            { Text = string.format("%s ", cwd) },
            { Foreground = { Color = mode_color.wrap.fg } },
            { Text = icons.wrap.left },
            { Background = { Color = mode_color.text.bg } },
            { Foreground = { Color = mode_color.text.fg } },
            { Text = " 󰇥 " },
            { Background = { Color = mode_color.wrap.bg } },
            { Foreground = { Color = mode_color.wrap.fg } },
            { Text = icons.wrap.right },
        })
    end

    window:set_left_status(style_left_section_mode())
    window:set_right_status(style_right_section_cwd())
end)
