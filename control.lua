local api = require("__logistics-pipes__/api.lua")
local flood = require("__logistics-pipes__/networks/net-creator.lua")
local baseNetworkFilter = require("__logistics-pipes__/tools.lua").baseNetworkFilter
local namesLookup = require("__logistics-pipes__/tools.lua").namesLookup

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
        visible=true,
        target={}
    },
    {
        sprite="logistics-pipe-connection-powered-right",
        visible=true,
        target={}
    },
    {
        sprite="logistics-pipe-connection-powered-bottom",
        visible=true,
        target={}
    },
    {
        sprite="logistics-pipe-connection-powered-left",
        visible=true,
        target={}
    }
}

local sidesIterator = {
    {0,-1},
    {-1,0},
    {0,1},
    {1,0}
}

local function getNeighboring(entity)
    local x,y = entity.position.x,entity.position.y
    local neighbors = {}
    for k,v in pairs(sidesIterator) do
        local relPos = {x=x+v[1],y=y+v[2]}
        local filter = api.util.table.deepcopy(baseNetworkFilter)
        filter.position = relPos
        neighbors[k] = entity.surface.find_entities_filtered(filter)[1]
    end
    return neighbors
end

local function updatePipeStates(entity)
    local x,y = entity.position.x,entity.position.y
    for k,v in pairs(sidesIterator) do
        local relPos = {x=x+v[1],y=y+v[2]}
        global.networks[entity.unit_number][k] = {
            data={},
            field={},
            temp_flooding={}
        }
        local filterHigh = api.util.table.deepcopy(baseNetworkFilter)
        filterHigh.position = relPos
        local ent = entity.surface.find_entities_filtered(filterHigh)[1]
        game.print("test")
        if ent then
            game.print("ran")
            global.networks[entity.unit_number][k].temp_flooding = {flood.flood(ent)}
            local filter = api.util.table.deepcopy(baseNetworkFilter)
            local flood,sources = table.unpack(global.networks[entity.unit_number][k].temp_flooding)
            for x,yList in pairs(flood or {}) do
                for y,_ in pairs(yList) do
                    filter.position = {x=x,y=y}
                    for k,v in pairs(entity.surface.find_entities_filtered(filter) or {}) do
                        game.print(sources)
                        if sources > 0 then
                            local surface = v.surface.index
                            local name = v.name:gsub("%-powered","")
                            v.destroy()
                            game.surfaces[surface].create_entity({
                                name=name.."-powered",
                                position = filter.position,
                                force="neutral",
                                create_build_effect_smoke=false
                            })
                        else
                            local surface = v.surface.index
                            local name = v.name
                            v.destroy()
                            game.surfaces[surface].create_entity({
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
    end
end

local function addNewPowerJunction(entity)
    game.print("new junction added")
    updatePipeStates(entity)
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
    updatePipeStates(entity)
    for k,connectionID in pairs(global.power_junctions[entity.surface.index][entity.position.x][entity.position.y].connectors) do
        rendering.destroy(connectionID)
    end
    global.power_junctions[entity.surface.index][entity.position.x][entity.position.y] = nil
end

local function onPlace(event)
    local entity = event.created_entity or event.entity or event.destination
    if entity.name == "logistics-power-junction" then addNewPowerJunction(entity) end
end

local function onDestroy(event)
    local entity = event.entity
    if entity.name == "logistics-power-junction" then removePowerJunction(entity) end
    if namesLookup[entity.name] then
        local surface,posVector = entity.surface,entity.position
        entity = surface.create_entity({
            name="logistics-power-junction-dummy",
            position = posVector,
            force="neutral",
            create_build_effect_smoke=false
        })
        updatePipeStates(entity)
        entity.destroy()
    end
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
                --updatePipeStates(data.entity)
            end
        end
    end
end)