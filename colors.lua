local pallete = require("palletes." .. os.getenv("SYSTEM_THEME"))

local M = {}

-- https://wezfurlong.org/wezterm/config/appearance.html
M.colors = {
    ansi = {
        pallete.base02,
        pallete.red,
        pallete.green,
        pallete.yellow,
        pallete.base0,
        pallete.violet,
        pallete.cyan,
        pallete.base2,
    },
    brights = {
        pallete.base00,
        pallete.red,
        pallete.green,
        pallete.yellow,
        pallete.base0,
        pallete.violet,
        pallete.magenta,
        pallete.base3,
    },
    foreground = pallete.base2,
    background = pallete.base03,
    cursor_bg = pallete.base1,
    cursor_fg = pallete.base03,
    cursor_border = pallete.base1,
    selection_fg = pallete.base3,
    selection_bg = pallete.blue,
    scrollbar_thumb = pallete.base00,
    split = pallete.base00,
    compose_cursor = pallete.orange,
    copy_mode_active_highlight_bg = { Color = pallete.blue },
    copy_mode_active_highlight_fg = { Color = pallete.base3 },
    copy_mode_inactive_highlight_bg = { Color = pallete.cyan },
    copy_mode_inactive_highlight_fg = { Color = pallete.base03 },
    quick_select_label_bg = { Color = pallete.base03 },
    quick_select_label_fg = { Color = pallete.yellow },
    quick_select_match_bg = { Color = pallete.base03 },
    quick_select_match_fg = { Color = pallete.green },
    tab_bar = {
        background = pallete.base03,
        inactive_tab_edge = pallete.red,
        inactive_tab_hover = {
            bg_color = pallete.base02,
            fg_color = pallete.base1,
            italic = false,
        },
        new_tab = {
            bg_color = pallete.base03,
            fg_color = pallete.base1,
            italic = false,
        },
        new_tab_hover = {
            bg_color = pallete.base00,
            fg_color = pallete.base3,
            italic = false,
        },
    },
}

function M.get(tab, hover, mode, cwd)
    local c = M.colors

    local color = {
        id = {
            wrap = {
                outer = {
                    base = { bg = pallete.base01, fg = pallete.base03 },
                    active = { bg = pallete.cyan, fg = pallete.base03 },
                    hover = { bg = pallete.base0, fg = pallete.base03 },
                },
                inner = {
                    base = { bg = pallete.base02, fg = pallete.base01 },
                    active = { bg = pallete.base00, fg = pallete.cyan },
                    hover = { bg = pallete.base01, fg = pallete.base0 },
                },
            },
            text = {
                base = { bg = pallete.base01, fg = pallete.base0 },
                active = { bg = pallete.cyan, fg = pallete.base03 },
                hover = { bg = pallete.base0, fg = pallete.base01 },
            },
        },
        title = {
            wrap = {
                base = { bg = pallete.base03, fg = pallete.base02 },
                active = { bg = pallete.base03, fg = pallete.base00 },
                hover = { bg = pallete.base03, fg = pallete.base01 },
            },
            text = {
                base = { bg = pallete.base02, fg = pallete.base2 },
                active = { bg = pallete.base00, fg = pallete.base3 },
                hover = { bg = pallete.base01, fg = pallete.base2 },
            },
            sep = {
                base = { bg = pallete.base02, fg = pallete.base00 },
                active = { bg = pallete.base00, fg = pallete.cyan },
                hover = { bg = pallete.base01, fg = pallete.base0 },
            },
        },
        status = {
            mode = {
                ["SEARCH"] = {
                    wrap = { bg = pallete.base03, fg = pallete.blue },
                    text = { bg = pallete.blue, fg = pallete.base03 },
                },
                ["COPY"] = {
                    wrap = { bg = pallete.base03, fg = pallete.base3 },
                    text = { bg = pallete.base3, fg = pallete.base03 },
                },
                ["WINDOW"] = {
                    wrap = { bg = pallete.base03, fg = pallete.violet },
                    text = { bg = pallete.violet, fg = pallete.base03 },
                },
                ["LEADER"] = {
                    wrap = { bg = pallete.base03, fg = pallete.orange },
                    text = { bg = pallete.orange, fg = pallete.base03 },
                },
                ["NORMAL"] = {
                    wrap = { bg = pallete.base03, fg = pallete.cyan },
                    text = { bg = pallete.cyan, fg = pallete.base03 },
                },
            },
            cwd = {
                wrap = { bg = pallete.base03, fg = pallete.base02 },
                text = { bg = pallete.base02, fg = pallete.base2 },
            },
        },
    }

    if cwd then
        return color
    end

    if not mode then
        if tab.is_active then
            color.id.wrap.inner.base = { bg = color.id.wrap.inner.active.bg, fg = color.id.wrap.inner.active.fg }
            color.id.wrap.outer.base = { bg = color.id.wrap.outer.active.bg, fg = color.id.wrap.outer.active.fg }
            color.id.text.base = { bg = color.id.text.active.bg, fg = color.id.text.active.fg }
            color.title.text.base = { bg = color.title.text.active.bg, fg = color.title.text.active.fg }
            color.title.wrap.base = { bg = color.title.wrap.active.bg, fg = color.title.wrap.active.fg }
            color.title.sep.base = { bg = color.title.sep.active.bg, fg = color.title.sep.active.fg }
        elseif hover then
            color.id.wrap.inner.base = { bg = color.id.wrap.inner.hover.bg, fg = color.id.wrap.inner.hover.fg }
            color.id.wrap.outer.base = { bg = color.id.wrap.outer.hover.bg, fg = color.id.wrap.outer.hover.fg }
            color.id.text.base = { bg = color.id.text.hover.bg, fg = color.id.text.hover.fg }
            color.title.text.base = { bg = color.title.text.hover.bg, fg = color.title.text.hover.fg }
            color.title.wrap.base = { bg = color.title.wrap.hover.bg, fg = color.title.wrap.hover.fg }
            color.title.sep.base = { bg = color.title.sep.hover.bg, fg = color.title.sep.hover.fg }
        end

        return color
    end

    return color.status.mode[mode]
end

return M
