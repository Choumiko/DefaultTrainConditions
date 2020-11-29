local event = require("__flib__.event")
local gui = require("__flib__.gui-beta")
local migration = require("__flib__.migration")

local train_gui = require("scripts.gui")
local global_data = require("scripts.global-data")
local player_data = require("scripts.player-data")

--EVENT HANDLERS

--BOOTSTRAP

 event.on_init(function()
   global_data.init()
   for i, player in pairs(game.players) do
       local pdata = player_data.init(i)
       player_data.refresh(player, pdata)
   end
end)

event.on_configuration_changed(function(e)
    if migration.on_config_changed(e, {}) then
    end
end)

--GUI

gui.hook_events(function(e)
    local msg
    if e.gui_type == defines.gui_type.entity and e.entity.type == "locomotive" then
        msg = {
            gui = "train",
            action = e.name == defines.events.on_gui_opened and "set_train" or "unset_train",
            train = e.entity.train
        }
    else
        msg = gui.read_action(e)
    end

    if msg then
        if msg.gui == "train" then
            train_gui.handle_action(e, msg)
        end
    end
end)

event.on_train_schedule_changed(function(e)
    if not e.player_index then return end
    local pdata = global._pdata[e.player_index]
    local train = e.train
    if not (train.state == defines.train_state.manual_control and pdata.train == train) then return end
    if train.schedule then
        local schedule = train.schedule
        local records = schedule and schedule.records
        local c_records = #records
        if c_records > pdata.size then
            records[c_records].wait_conditions = pdata.default_conditions
            train.schedule = schedule
        end
        pdata.size = c_records
    else
        pdata.size = 0
    end
end)

-- PLAYER

event.on_player_created(function(e)
    player_data.refresh(game.get_player(e.player_index), player_data.init(e.player_index))
end)

event.on_player_removed(function(e)
    global._pdata[e.player_index] = nil
end)