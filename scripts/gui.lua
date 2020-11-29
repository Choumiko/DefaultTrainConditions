
local gui = require("__flib__.gui-beta")
local train_gui = {}

function train_gui.create(player, pdata)
    local refs = gui.build(player.gui.relative, {
        {
            type = "frame",
            style = "quick_bar_window_frame",
            --caption = "Default Conditions",
            anchor = {
                gui = defines.relative_gui_type.train_gui,
                position = defines.relative_gui_position.left
            },
            ref = {"window"},
            children = {
                {type = "frame", style = "inside_deep_frame", direction = "vertical", style_mods = {padding = 1},
                    children = {
                        {type = "sprite-button",
                            --caption = "Set default condition",
                            style = "tool_button", sprite = "dtc-paste",
                            tooltip = "Save the first stations conditions as defaults\nRight click to clear",
                            actions = {on_click = {gui = "train", action = "set_condition"}}
                        },
                    }
                }
            }
        }
    })

    pdata.gui.train = {
        refs = refs,
    }
end

function train_gui.destroy(pdata)
    pdata.gui.train.refs.window.destroy()
    pdata.gui.train = nil
end

function train_gui.handle_action(e, msg)
    local pdata = global._pdata[e.player_index]
    local gui_data = pdata.gui.train

    if msg.action == "set_train" then
        local train = msg.train
        pdata.train = train
        pdata.size = train.schedule and #train.schedule.records or 0
    elseif msg.action == "unset_train" then
        pdata.train = nil
        pdata.size = nil
    elseif msg.action == "set_condition" then
        if e.button == defines.mouse_button_type.right then
            pdata.default_conditions = nil
        else
            local train = pdata.train
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