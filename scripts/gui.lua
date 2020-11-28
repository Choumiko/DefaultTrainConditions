
local gui = require("__flib__.gui-beta")
local train_gui = {}

function train_gui.create(player, pdata)
    local refs = gui.build(player.gui.relative, {
    {
        type = "frame",
        --caption = "Default Conditions",
        anchor = {
            gui = defines.relative_gui_type.train_gui,
            position = defines.relative_gui_position.left
        },
        ref = {"window"},
        children = {
            {type = "frame", style = "inside_shallow_frame_with_padding", direction = "vertical", children = {
                --{type = "flow", style_mods = {vertical_align = "center"}, children = {
                {type = "sprite-button", style = "tool_button", sprite = "utility/copy",
                    tooltip = "Save the first stations conditions as defaults\nRight click to clear",
                    actions = {on_click = {gui = "train", action = "set_condition"}}
                },
                -- {type = "sprite-button", style = "tool_button", sprite = "dtc-paste"},
                --}}
            }}
        }
    }
    })

    pdata.gui.train = {
        refs = refs,
        state = {}
    }
end

function train_gui.destroy(pdata)
    pdata.gui.train.refs.window.destroy()
    pdata.gui.train = nil
end

function train_gui.handle_action(e, msg)
    local player = game.get_player(e.player_index)
    local pdata = global._pdata[e.player_index]
    local gui_data = pdata.gui.train

    if msg.action == "set_train" then
        local train = msg.train
        gui_data.state.train = train
        gui_data.state.size = train.schedule and #train.schedule.records or 0
    elseif msg.action == "unset_train" then
        gui_data.state = {}
    elseif msg.action == "set_condition" then
        if e.button == defines.mouse_button_type.right then
            pdata.default_conditions = nil
        else
            local train = gui_data.state.train
            if train then
                local records = train.schedule and train.schedule.records[1]
                if records then
                    pdata.default_conditions = records.wait_conditions
                end
            end
        end
    end
end

return train_gui