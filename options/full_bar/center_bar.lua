local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

local mission = require("items.widgets.mission_control")
local spaces = require("items.widgets.spaces")
local add_space = require("items.widgets.add_space")



local mission_control_bracket = sbar.add(
    "bracket",
    "mission_control.bracket",
    { mission.name },
    {
        position = "center",
        width = "dynamic",
        background = {
            color = colors.transparent,
        },
    }
)

local spaces_bracket = sbar.add(
    "bracket",
    "spaces.bracket",
    { spaces.name },
    {
        position = "center",
        width = "dynamic",
        padding_left = 10,
        padding_right = 10,
        icon = { padding_left = 5, padding_right = 5 },
        background = {
            color = colors.transparent,
        },
    }
)
local add_space_bracket = sbar.add(
    "bracket",
    "add_space.bracket",
    { add_space.name },
    {
        position = "center",
        width = "dynamic",
        padding_left = 10,
        padding_right = 10,
        background = {
            color = colors.transparent,
        },
    }
)

-- Create the bracket and include the items
local center_bar = sbar.add(
    "bracket",
    "center_bar.bracket",
    { add_space_bracket.name, spaces_bracket.name, mission_control_bracket.name },
    {
        shadow = false, -- Shadow is false for bar-full.lua
        position = "center",
        width = "dynamic",
        background = {
            padding_left = 10,
            padding_right = 10,
            corner_radius = 6,
            height = 28,
            color = colors.bar.bg
        },
    }
)



return center_bar
