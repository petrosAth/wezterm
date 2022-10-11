local wezterm = require("wezterm")
return {
	font = wezterm.font("JetBrainsMono Nerd Font"),
	color_scheme = "nord",
	color_schemes = {
		nord = {
			background = "#2e3440",
		},
	},
	window_background_opacity = 0.9,
	text_background_opacity = 1.0,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
}
