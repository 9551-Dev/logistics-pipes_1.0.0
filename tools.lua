local api = require("__logistics-pipes__/api.lua")

local names = {
    "basic",
    "bee-analyzer",
    "beeSink",
    "builder-supplier",
    "chassis/mk1",
    "chassis/mk2",
    "chassis/mk3",
    "chassis/mk4",
    "chassis/mk5",
    "crafting/mk1",
    "crafting/mk2",
    "crafting/mk3",
    "firewall",
    "inventory-system-connector",
    "provider/mk1",
    "provider/mk2",
    "remote-orderer",
    "request/mk1",
    "request/mk2",
    "satelite",
    "system-destination",
    "system-entrance"
}

local namesCopy = api.util.table.deepcopy(names)
local namesLookup = {}
for k,v in pairs(names) do
    namesLookup[v:gsub("/","-").."-logistics-pipe"] = true
end

local lookUpDeepCopy = api.util.table.deepcopy(namesLookup)
lookUpDeepCopy["logistics-power-junction"] = true
local names = {}
for k,v in pairs(lookUpDeepCopy) do
    table.insert(names,k)
    table.insert(names,k.."-powered")
end

local baseNetworkFilter = {
    name=names
}

local fullPipeLookUp = {}
for k,v in pairs(api.util.table.deepcopy(namesLookup)) do
    fullPipeLookUp[k] = true
    fullPipeLookUp[k.."-powered"] = true
end


return {
    names=namesCopy,
    namesLookup=fullPipeLookUp,
    baseNetworkFilter=baseNetworkFilter
}
