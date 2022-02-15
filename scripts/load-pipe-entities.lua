local names = require("__logistics-pipes__/tools.lua").names
for k,v in pairs(names) do
    local name,mark = v:match("(.+)/(.+)")
    if not name then name = v end
    if mark then mark = "/"..mark.."/" end
    mark = mark or "/"
    local markname
    if mark ~= "/" then markname = mark:match("/(.+)/") end
    require("__logistics-pipes__/prototypes/entities/pipes/"..name..mark..(markname or name))
end