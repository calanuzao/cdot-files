-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Add key bindings for pane management
config.keys = {
    -- Split panes (fixed directions)
    { key = "h", mods = "CMD|SHIFT", action = wezterm.action.SplitPane({
        direction = "Right",
        size = { Percent = 50 },
    })},
    { key = "v", mods = "CMD|SHIFT", action = wezterm.action.SplitPane({
        direction = "Down",
        size = { Percent = 50 },
    })},
    
    -- Close pane (removed confirmation)
    { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
    
    -- Navigate between panes
    { key = "LeftArrow", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Right") },
    { key = "UpArrow", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Up") },
    { key = "DownArrow", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Down") },
    
    -- Swap/Move panes
    { key = "LeftArrow", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
    { key = "RightArrow", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
    { key = "UpArrow", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
    { key = "DownArrow", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
    
    -- Resize panes
    { key = "=", mods = "CMD", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
    { key = "-", mods = "CMD", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
    
    -- File explorer in new pane using ranger
    { 
        key = "e", 
        mods = "CMD", 
        action = wezterm.action.SplitPane({
            direction = "Left",
            size = { Percent = 25 },
            command = { args = { "ranger" } },  -- Using PATH to find ranger
        }),
    },
    
    -- AI Chat in new pane
    { 
        key = "k",
        mods = "CMD", 
        action = wezterm.action.SplitPane({
            direction = "Right",
            size = { Percent = 40 },
            command = { 
                args = { "bash", "-c", "OPENAI_API_KEY=$METHIX_API_KEY aichat" }
            },
        }),
    },
}

-- Color scheme configuration
config.colors = {
    foreground = "#E6E6FA",    -- Light lavender foreground
    background = "#110022",    -- Deep purple background
    cursor_bg = "#7B68EE",     -- Metallic purple cursor
    cursor_border = "#7B68EE", -- Metallic purple cursor border
    cursor_fg = "#110022",     -- Dark background for cursor text
    selection_bg = "#4D6CFA",  -- Electric blue selection
    selection_fg = "#110022",  -- Dark background for selected text
    ansi = {
        "#110022",  -- black (background)
        "#FF3366",  -- red
        "#4D6CFA",  -- green (using decepticon blue)
        "#7B68EE",  -- yellow (using metallic purple)
        "#4D6CFA",  -- blue
        "#9B30FF",  -- magenta (decepticon purple)
        "#7B68EE",  -- cyan (using metallic accent)
        "#E6E6FA",  -- white
    },
    brights = {
        "#1E0030",  -- bright black
        "#FF6B88",  -- bright red
        "#668AFF",  -- bright green (lighter blue)
        "#9B88FF",  -- bright yellow (lighter metallic)
        "#668AFF",  -- bright blue
        "#B355FF",  -- bright magenta
        "#9B88FF",  -- bright cyan
        "#FFFFFF",  -- bright white
    },
}

-- Font configuration
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16

-- Tab bar configuration
config.enable_tab_bar = true
config.tab_max_width = 64

-- Tab bar colors
config.colors.tab_bar = {
    background = "#110022",    -- Deep purple background
    active_tab = {
        bg_color = "#1E0030",  -- Slightly lighter purple for active tab
        fg_color = "#7B68EE",  -- Metallic purple text
    },
    inactive_tab = {
        bg_color = "#110022",  -- Deep purple background
        fg_color = "#4D6CFA",  -- Electric blue text
    },
    inactive_tab_hover = {
        bg_color = "#1E0030",  -- Slightly lighter purple on hover
        fg_color = "#9B30FF",  -- Bright decepticon purple
    },
}

-- Cursor configuration
config.cursor_thickness = 2
config.cursor_blink_rate = 500

-- Window configuration
config.window_decorations = "RESIZE"
config.window_background_opacity = 1.0
config.macos_window_background_blur = 0

-- Terminal configuration
config.term = "xterm-256color"

-- Environment variables
config.set_environment_variables = {}

-- Return the configuration
return config