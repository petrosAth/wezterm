local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

function M.setup(config)
    config.disable_default_key_bindings = true
    config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 5000 }
    config.keys = {
        -- { key = "Escape", mods = "NONE", action = act.EmitEvent("user-defined-0") },
        { key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
        { key = "_", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
        { key = "=", mods = "LEADER", action = act.ResetFontSize },
        { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
        { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
        { key = "`", mods = "LEADER", action = act.ShowDebugOverlay },
        { key = "r", mods = "LEADER|CTRL", action = act.ReloadConfiguration },
        { key = "w", mods = "LEADER", action = act.ShowTabNavigator },
        { key = "Space", mods = "LEADER", action = act.ActivateCommandPalette },
        { key = "r", mods = "LEADER", action = act.ShowLauncher },
        {
            key = "w",
            mods = "LEADER|CTRL",
            action = act.ActivateKeyTable({ name = "window_mode", one_shot = false }),
        },
        {
            key = "Escape",
            mods = "LEADER",
            action = act.ActivateCopyMode,
        },
        { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
        { key = "f", mods = "LEADER", action = act.QuickSelect },
        {
            key = "Escape",
            mods = "NONE",
            action = wezterm.action_callback(function(window, pane)
                local has_selection = window:get_selection_text_for_pane(pane) ~= ""
                if has_selection then
                    window:perform_action(act.ClearSelection, pane)
                else
                    window:perform_action(act.SendKey({ key = "Escape", mods = "NONE" }), pane)
                end
            end),
        },
        { key = "/", mods = "LEADER", action = act.Search({ CaseInSensitiveString = "" }) },
        { key = "t", mods = "LEADER|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
        { key = "t", mods = "LEADER", action = wezterm.action.SpawnCommandInNewTab({ cwd = "~" }) },
        { key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
        { key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
        { key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
        { key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
        { key = "Tab", mods = "LEADER", action = act.ActivateLastTab },
    }

    config.key_tables = {
        window_mode = {
            -- Resize panes
            { key = "<", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 1 }) },
            { key = ">", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 1 }) },
            { key = "+", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
            { key = "-", action = act.AdjustPaneSize({ "Down", 1 }) },

            -- Navigate through panes
            { key = "h", action = act.ActivatePaneDirection("Left") },
            { key = "l", action = act.ActivatePaneDirection("Right") },
            { key = "k", action = act.ActivatePaneDirection("Up") },
            { key = "j", action = act.ActivatePaneDirection("Down") },
            { key = "w", action = act.PaneSelect },
            { key = "m", action = act.PaneSelect({ mode = "SwapWithActive" }) },

            -- Split panes
            { key = "v", action = act.SplitHorizontal({ cwd = "~" }) },
            { key = "s", action = act.SplitVertical({ cwd = "~" }) },
            { key = "v", mods = "CTRL", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
            { key = "s", mods = "CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

            -- Manipulate panes
            {
                key = "t",
                mods = "NONE",
                action = wezterm.action_callback(function(win, pane)
                    local tab, window = pane:move_to_new_tab()
                end),
            },
            { key = "m", mods = "NONE", action = act.PaneSelect({ mode = "SwapWithActive" }) },

            -- Leave mode using Esc
            { key = "Escape", action = "PopKeyTable" },
        },
        search_mode = {
            { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
            { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
            { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
            { key = "N", mods = "CTRL|SHIFT", action = act.CopyMode("PriorMatch") },
            { key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
            { key = "w", mods = "CTRL", action = act.CopyMode("ClearPattern") },
        },
        copy_mode = {
            { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
            { key = "/", mods = "NONE", action = act.Search({ CaseInSensitiveString = "" }) },
            { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
            { key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
            { key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
            { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
            { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
            { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
            { key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
            { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
            { key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
            { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
            { key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
            { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
            { key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
            { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
            { key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
            { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
            { key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
            { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
            { key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
            { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
            { key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
            { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
            { key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
            { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
            { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
            { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
            { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
            { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
            { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
            { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
            { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
            { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
            { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
            { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
            { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
            { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
            { key = "q", mods = "NONE", action = act.CopyMode("Close") },
            { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
            { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
            { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
            { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
            { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
            {
                key = "y",
                mods = "NONE",
                action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
            },
        },
    }

    for i = 1, 8 do
        table.insert(config.keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) })
    end
end

return M
