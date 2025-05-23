local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local whitelist = {
    ["Spotify"] = true
}

-- MiniPlayer constants
local PADDING = 5
local HEIGHT = 80
local HEIGHT_BEFORE = 0

-- Helper function to create media items
local function setup_media_items()
    local media_icon = sbar.add("item", {
        position = "right",
        display = 1,
        background = {
            padding_left = PADDING,
            border_width = 0,
            border_color = colors.bar.border,
            width = "dynamic",
        },
        align = "right",
        label = {
            padding_left = settings.paddings,
            padding_right = settings.paddings,
            drawing = false,
        },
        icon = {
            padding_left = 10,
            padding_right = 15,
            drawing = true,
            string = icons.media.icon,
            color = colors.primary,
            font = {
                size = 16,
            },
        },
        drawing = true,
        updates = true,
        popup = {
            display = 1,
            drawing = false, -- Initially hidden
            y_offset = 10,
            align = "center",
            horizontal = true,
            height = HEIGHT_BEFORE,
        },
    })

    local media_cover = sbar.add("item", {
        position = "popup." .. media_icon.name,
        background = {
            padding_left = 10,
            padding_right = 5,
            image = {
                margin = 20,
                string = "media.artwork",
                scale = 2,
            },

            height = HEIGHT,
        },
        drawing = true,
        updates = true,
    })

    local media_artist = sbar.add("item", {
        position = "popup." .. media_icon.name,
        align = "left",
        padding_right = 0,
        padding_left = 0,
        label = {
            y_offset = 0,
            align = "left",
            position = "left",
            color = colors.red,
            max_chars = 20,
            font = {
                size = 14,
            },
        },
        drawing = true,
    })

    local media_title = sbar.add("item", {
        position = "popup." .. media_icon.name,
        padding_right = 20,
        padding_left = 0,
        y_offset = 0,
        label = {
            align = "left",
            position = "left",
            max_chars = 20,
            font = {
                size = 14,
            },
        },
        drawing = true,
    })

    return media_icon, media_cover, media_artist, media_title
end

-- Setup MiniPlayer items
local media_icon, media_cover, media_artist, media_title = setup_media_items()

-- Add playback controls (hidden by default)
local controls = {}
local function create_controls()
    local control_items = {
        { icon = icons.media.forward,    action = "nowplaying-cli next" },
        { icon = icons.media.play_pause, action = "nowplaying-cli togglePlayPause" },
        { icon = icons.media.back,       action = "nowplaying-cli previous" },
    }

    for i, control in ipairs(control_items) do
        local control_item = sbar.add("item", {
            display = 1,
            padding_right = 0,
            padding_left = 10,
            align = "right",
            position = "right",
            width = 0,
            background = {
                padding_left = 10,
                padding_right = 10,
                color = colors.transparent,
                height = 22,
                border_width = 0,
            },
            icon = {
                align = "center",
                position = "right",
                color = colors.primary,
                string = control.icon,
                font = { size = 12 },
            },
            click_script = control.action,
            drawing = false, -- Initially hidden
        })
        table.insert(controls, control_item)
    end
end

-- Create controls
create_controls()

-- Track visibility state of controls
local controls_visible = false

-- Function to toggle playback controls
local function toggle_controls()
    controls_visible = not controls_visible
    for i, control in ipairs(controls) do
        sbar.animate("elastic", 15, function()
            control:set({ drawing = controls_visible, width = 35, padding_right = 5, padding_left = 5, })
        end)
    end
end

-- Track visibility state of popup
local popup_visible = false

-- Function to toggle popup visibility
local function toggle_popup(visible)
    if popup_visible ~= visible then
        popup_visible = visible
        sbar.animate("elastic", 15, function()
            media_icon:set({
                popup = {
                    drawing = visible,
                    height = visible and HEIGHT or 0,
                    y_offset = visible and 30 or 0,
                },
            })
        end)
    end
end

-- Media change event for the popup (Shows on song change or playback start)
media_icon:subscribe("media_change", function(env)
    if whitelist[env.INFO.app] then
        local is_playing = (env.INFO.state == "playing")

        -- Update media details
        media_cover:set({ drawing = is_playing })
        media_artist:set({ drawing = is_playing, label = env.INFO.artist })
        media_title:set({ drawing = is_playing, label = env.INFO.title })

        -- Show popup when media starts or changes, auto-hide after 5 seconds
        if is_playing then
            sbar.animate("elastic", 15, function()
                toggle_popup(true)
                sbar.delay(10, function() toggle_popup(false) end)
            end)
        else
            toggle_popup(false)
        end
    end
end)

-- Mouse clicked event for toggling controls
media_icon:subscribe("mouse.entered", function(env)
    sbar.animate("elastic", 15, function()
        toggle_controls() -- Show/hide controls on click
    end)
end)

return media_icon
