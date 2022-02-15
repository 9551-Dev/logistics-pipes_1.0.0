--[[ giving pipes additional propperties ]]--
local lookup = require("__logistics-pipes__/tools.lua").namesLookup
for _, wall in pairs(data.raw["wall"]) do
    if lookup[wall.name] then
        wall.visual_merge_group = 9551
        wall.subgroup = "logistics-pipes-item-subgroup"
    end
end