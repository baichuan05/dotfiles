-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.enable_scroll_bar = true

config.keys = {
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
}

-- For example, changing the color scheme:
config.color_scheme = 'Snazzy (Gogh)'

-- and finally, return the configuration to wezterm
return config
