local names = require("__logistics-pipes__/tools.lua").names
for k,v in pairs(names) do
    local name,mark = v:match("(.+)/(.+)")
    if not name then name = v end
    if mark then mark = mark.."-" end
    local craftMark = ""
    if mark then craftMark = "-"..mark:gsub("-","") end
    mark = mark or ""
    log(name..mark.."logistics-pipe")
    data:extend({
        {
            type="item",
            name=name.."-"..mark.."logistics-pipe",
            subgroup="logistics-pipes-item-subgroup",
            icon="__logistics-pipes__/graphics/icons/pipes/"..name..craftMark..".png",
            icon_size=64,
            stack_size=64,
            place_result=name.."-"..mark.."logistics-pipe"
        }
    })
end