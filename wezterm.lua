local wezterm = require("wezterm")
local pallete = require("palletes." .. os.getenv("SYSTEM_THEME"))
local colors = require("colors")
local icons = require("icons")

local config = {}

config = {
    colors = colors.colors,
    font = wezterm.font("monospace"),
    font_size = 10,
    initial_cols = 200,
    initial_rows = 50,
    window_decorations = "RESIZE",
    window_background_opacity = 0.95,
    text_background_opacity = 1.0,
    window_padding = {
        top = 0,
        bottom = 0,
        left = 0,
        right = 0,
    },
    -- window_frame = {
    --     border_left_width = "4px",
    --     border_right_width = "4px",
    --     border_bottom_height = "4px",
    --     border_top_height = "4px",
    --     border_left_color = pallete.red,
    --     border_right_color = pallete.red,
    --     border_bottom_color = pallete.red,
    --     border_top_color = pallete.red,
    -- },
    term = "wezterm",
    animation_fps = 60,
    quick_select_alphabet = "fjdkslaruvmgheiwoxqpbnz",
    inactive_pane_hsb = {
        brightness = 0.6,
        hue = 1.0,
        saturation = 1.0,
    },
    use_fancy_tab_bar = false,
    hide_tab_bar_if_only_one_tab = false,
    tab_bar_at_bottom = true,
    tab_max_width = 50,
    tab_bar_style = {
        new_tab_hover = wezterm.format({
            { Background = { Color = pallete.base03 } },
            { Foreground = { Color = pallete.base00 } },
            { Text = string.format(" %s", icons.wrap.left) },
            { Background = { Color = pallete.base00 } },
            { Foreground = { Color = pallete.base3 } },
            { Text = icons.new_tab },
            { Background = { Color = pallete.base03 } },
            { Foreground = { Color = pallete.base00 } },
            { Text = icons.wrap.right },
        }),
        new_tab = wezterm.format({
            { Background = { Color = pallete.base03 } },
            { Foreground = { Color = pallete.base02 } },
            { Text = string.format(" %s", icons.wrap.left) },
            { Background = { Color = pallete.base02 } },
            { Foreground = { Color = pallete.base3 } },
            { Text = icons.new_tab },
            { Background = { Color = pallete.base03 } },
            { Foreground = { Color = pallete.base02 } },
            { Text = icons.wrap.right },
        }),
    },
}

require("status-bar")
require("keys").setup(config)

return config
