--tools for network creation
local baseNetworkFilter = require("__logistics-pipes__/tools.lua").baseNetworkFilter
local api = require("__logistics-pipes__/api.lua")

local sidesIterator = {
    {0,-1},
    {-1,0},
    {0,1},
    {1,0}
}

local function get2DarraySquareWH(array)
    local minx, maxx = math.huge, -math.huge
    local miny,maxy = math.huge, -math.huge
    for x,yList in pairs(array) do
        minx, maxx = math.min(minx, x), math.max(maxx, x)
        for y,_ in pairs(yList) do
            miny, maxy = math.min(miny, y), math.max(maxy, y)
        end
    end
    return {w=math.abs(minx)+maxx,h=math.abs(miny)+maxy,d=1}
end


local function flood(entity)
    log("flood start")
    local flood_internal
    local positiveSourceCount = 0
    function flood_internal(entity,visited,visited_junctions,maxid,src)
        log("flooded")
        if not visited then visited = api.array_manipulation.create2Darray() end
        if not visited_junctions then visited_junctions = api.array_manipulation.create2Darray() end
        if not maxid then maxid = -math.huge end
        local positionVector = entity.position
        for k,v in pairs(sidesIterator) do
            local relPos = {x=positionVector.x+v[1],y=positionVector.y+v[2]}
            if not visited[relPos.x][relPos.y] and not visited_junctions[relPos.x][relPos.y] then
                local filter = api.util.table.deepcopy(baseNetworkFilter)
                filter.position = relPos
                local nextEntities = entity.surface.find_entities_filtered(filter)
                for k,entity in pairs(nextEntities or {}) do
                    if entity.name == "logistics-power-junction" or entity.name == "logistics-power-junction-dummy" then
                        if entity.energy > 2000001 then
                            positiveSourceCount = positiveSourceCount + 1
                        end
                        visited_junctions[relPos.x][relPos.y] = true
                        if entity.unit_number > maxid then src = entity end
                        maxid = math.max(maxid,entity.unit_number)
                    else
                        visited[relPos.x][relPos.y] = true
                    end
                    flood_internal(entity,visited,visited_junctions,maxid,src)
                end
            end
        end
        return visited,maxid
    end
    local out,maxid,src = flood_internal(entity)
    log("flood end")
    return out,positiveSourceCount,maxid,src
end


return {
    get2DarraySquareWH=get2DarraySquareWH,
    flood=flood
}