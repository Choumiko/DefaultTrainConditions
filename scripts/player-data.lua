local train_gui = require("scripts.gui")

local player_data = {}

function player_data.init(player_index)
    global._pdata[player_index] = {
        gui = {},
    }
    return global._pdata[player_index]
end

function player_data.refresh(player, pdata)
    if pdata.gui.train then
        train_gui.destroy(pdata)
    end
    train_gui.create(player, pdata)
end

return player_data
