-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#706b4e",
	selection_fg = "#f3d9c4",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16

-- Enable the tab bar and customize tab size
config.enable_tab_bar = true
config.tab_max_width = 64 -- Increase the maximum tab width

-- Customize tab appearance to match your terminal colors
config.colors.tab_bar = {
    background = "#011423",  -- Use the terminal background color
    active_tab = {
        bg_color = "#011423", -- Match the terminal background
        fg_color = "#CBE0F0", -- Match the terminal foreground
    },
    inactive_tab = {
        bg_color = "#011423", -- Match the terminal background
        fg_color = "#707070", -- Use a slightly dimmed color for inactive tabs
    },
    inactive_tab_hover = {
        bg_color = "#011423", -- Match the terminal background
        fg_color = "#CBE0F0", -- Match the terminal foreground
    },
}

-- Cursor
config.cursor_thickness = 2  -- Adjust this value as needed
config.cursor_blink_rate = 500  -- Cursor blinking rate in milliseconds

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 8

-- and finally, return the configuration to wezterm
return config