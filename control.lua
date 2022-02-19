local api = require("__logistics-pipes__/api.lua")
local flood = require("__logistics-pipes__/networks/net-creator.lua")
local baseNetworkFilter = require("__logistics-pipes__/tools.lua").baseNetworkFilter
local namesLookup = require("__logistics-pipes__/tools.lua").namesLookup
-- require('__debugadapter__/debugadapter.lua')

script.on_init(function()
    if not global.power_junctions then
        global.power_junctions = api.array_manipulation.create3Darray()
        global.networks = api.array_manipulation.create2Darray()
        global.junction_power_levels = api.array_manipulation.create3Darray()
        for k,v in pairs(game.surfaces) do
            local powerJunctionsSurface = v.find_entities_filtered({
                name="logistics-power-junction",
            })
            for k,junction in pairs(powerJunctionsSurface) do
                global.power_junctions[junction.surface.index][junction.position.x][junction.position.y] = junction
            end
        end
    end
end)

script.on_load(function()
    global.power_junctions = api.array_manipulation.create3Darray(global.power_junctions)
    global.networks = api.array_manipulation.create2Darray(global.networks)
    global.junction_power_levels = api.array_manipulation.create3Darray(global.junction_power_levels)
end)

local powerJunctionConnectorBase = {
    {
        sprite="logistics-pipe-connection-powered-top",
        visible=false,
        target={}
    },
    {
        sprite="logistics-pipe-connection-powered-right",
        visible=false,
        target={}
    },
    {
        sprite="logistics-pipe-connection-powered-bottom",
        visible=false,
        target={}
    },
    {
        sprite="logistics-pipe-connection-powered-left",
        visible=false,
        target={}
    }
}

local sidesIterator = {
    {0,-1},
    {-1,0},
    {0,1},
    {1,0}
}

local function update_networks_data(dimension,cordinates)
    local function update_networks_dataInternal(dimension,cordinates)
        local junction = dimension.find_entity("logistics-power-junction",cordinates)
        for k,v in pairs(sidesIterator) do
            local relCords = {x=cordinates.x+v[1],y=cordinates.y+v[2]}
            global.networks[junction.unit_number][k] = {
                tempflood={},
                grid={},
                pipes={},
                actions={},
                src=junction,
                srcCounts={}
            }
            local filter = api.util.table.deepcopy(baseNetworkFilter)
            filter.position = relCords
            local ent = dimension.find_entities_filtered(filter)[1]
            if ent then
                local net,srcCount = flood.flood(ent)
                if global.networks[junction.unit_number][k].srcCounts.cur then global.networks[junction.unit_number][k].srcCounts.cur = srcCount end
                if not global.networks[junction.unit_number][k].srcCounts.prev then global.networks[junction.unit_number][k].srcCounts.prev = math.huge end
                for x,yList in pairs(net) do
                    for y,bool in pairs(yList) do
                        local filt = api.util.table.deepcopy(baseNetworkFilter)
                        filt.position = {x=x,y=y}
                        game.print("got here 1")
                        local out = dimension.find_entities_filtered(filt or {})
                        for k,data in pairs(out or {}) do
                            game.print("got here 2")
                            if global.networks[junction.unit_number][k].srcCounts.prev ~= srcCount then
                                local name = data.name
                                local surface = dimension
                                if srcCount > 0 then
                                    data.destroy()
                                    surface.create_entity({
                                        name=name.."-powered",
                                        position = filter.position,
                                        force="neutral",
                                        create_build_effect_smoke=false
                                    })
                                else
                                    data.destroy()
                                    log(name:gsub("%-powered",""))
                                    surface.create_entity({
                                        name=name:gsub("%-powered",""),
                                        position = filter.position,
                                        force="neutral",
                                        create_build_effect_smoke=false
                                    })
                                end
                            end
                        end
                    end
                end
                global.networks[junction.unit_number][k].srcCounts.prev = srcCount
            end
        end
    end
    update_networks_dataInternal(dimension,cordinates)
end

local function addNewPowerJunction(entity)
    game.print("new junction added")
    entity.energy = 0
    update_networks_data(entity.surface,entity.position)
    local connectors = {}
    for k,v in pairs(sidesIterator) do
        local curDat = api.util.table.deepcopy(powerJunctionConnectorBase[k])
        curDat.target.x,curDat.target.y = entity.position.x+v[1],entity.position.y+v[2]
        curDat.surface = entity.surface.index
        table.insert(connectors,rendering.draw_sprite(curDat))
    end
    global.power_junctions[entity.surface.index][entity.position.x][entity.position.y] = {
        connectors=connectors,
        entity=entity
    }
end

local function removePowerJunction(entity)
    game.print("removed junction")
    update_networks_data(entity.surface,entity.position)
    for k,connectionID in pairs(global.power_junctions[entity.surface.index][entity.position.x][entity.position.y].connectors) do
        rendering.destroy(connectionID)
    end
    global.power_junctions[entity.surface.index][entity.position.x][entity.position.y] = nil
end

local function onPlace(event)
    game.print("onPlace")
    local entity = event.created_entity or event.entity or event.destination
    if entity.name == "logistics-power-junction" then addNewPowerJunction(entity) end
end
i=0
local function onDestroy(event)
    game.print("onDestroy")
    local entity = api.util.table.deepcopy(event.entity)
    -- local player = game.get_player(event.player_index)
    if entity.name == "logistics-power-junction-dummy" then removePowerJunction(entity) end
    --[[if namesLookup[entity.name] then
        local surface = entity.surface
        local position = entity.position
        entity.destroy()
        for k,v in pairs(sidesIterator) do
        end
    end]]
end

local function updatePowerJunctionConnections()
    for surface,xList in pairs(global.power_junctions) do
        for x,yList in pairs(xList) do
            for y,data in pairs(yList) do
                local entity = data.entity
                if entity.valid then
                    local connectors = data.connectors
                    local x,y = entity.position.x,entity.position.y
                    for indice,v in pairs(sidesIterator) do
                        local relPos = {x=x+v[1],y=y+v[2]}
                        if entity.surface.find_entity("basic-logistics-pipe",relPos) or entity.surface.find_entity("basic-logistics-pipe-powered",relPos) then
                            rendering.set_visible(connectors[indice],true)
                        else
                            rendering.set_visible(connectors[indice],false)
                        end
                    end
                else
                    removePowerJunction(entity)
                end
            end
        end
    end
end

script.on_event(defines.events.on_built_entity, onPlace)
script.on_event(defines.events.on_entity_cloned, onPlace)
script.on_event(defines.events.on_robot_built_entity, onPlace)
script.on_event(defines.events.script_raised_built, onPlace)
script.on_event(defines.events.script_raised_revive, onPlace)

script.on_event(defines.events.on_player_mined_entity,onDestroy)
script.on_event(defines.events.on_entity_died,onDestroy)
script.on_event(defines.events.on_robot_mined_entity,onDestroy)
script.on_event(defines.events.script_raised_destroy,onDestroy)

script.on_nth_tick(10,function()
    updatePowerJunctionConnections()
end)

script.on_nth_tick(60,function()
    for surface,xList in pairs(global.power_junctions) do
        for x,yList in pairs(xList) do
            for y,data in pairs(yList) do
                if not global.junction_power_levels[surface][x][y] then global.junction_power_levels[surface][x][y] = {cur=0} end
                global.junction_power_levels[surface][x][y] = {
                    prev = global.junction_power_levels[surface][x][y].cur or 0,
                    cur = data.entity.energy
                }
                if global.junction_power_levels[surface][x][y].prev < 2000001 and global.junction_power_levels[surface][x][y].cur > 2000001 then
                    update_networks_data(data.entity.surface,data.entity.position)
                end
                if global.junction_power_levels[surface][x][y].prev > 2000001 and global.junction_power_levels[surface][x][y].cur < 2000001 then
                    update_networks_data(data.entity.surface,data.entity.position)
                end
            end
        end
    end
end)

script.on_event("lp-on-entity-click",function(event)
    local player = game.get_player(event.player_index)

    if player.selected then
        if event.input_name == "lp-on-entity-click" and player.selected.prototype.type == "wall" then
            game.print("clicked")
        end
    end
end)
