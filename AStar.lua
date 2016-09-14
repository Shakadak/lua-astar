local modpath = ""
for i = 1, select('#', ...) do
	if modpath == "" then
		modpath = select(i, ...):match(".+/")
	end
end

local PQ = require (modpath .. "PQ")
local HOF = require (modpath .. "HOF")

local function backtrack(last, cameFrom)
    local current = last
	local path = {}
    while current ~= nil do
        table.insert(path, 1, current)
        current = cameFrom[current]
	end
	return path
end
-- aStar:
--      - expand:   function that takes a node and return its neighbors as array/table
--                  neighbors must be values, not keys, as they are discarded
--      - cost:     function that take two nodes, `from` and `to`, and return the cost
--                  to go from `from` to `to`
--      - heuristic:function that takes a node and return the estimated cost to reach
--                  the goal
--      - goal:     function that takes a node and return whether the goal has been
--                  reached or not
--      - start:    the starting node
-- return nil in case of failure
--        the ordered path in case of success, as an array
local aStar = HOF.curry(function(expand, cost, heuristic, goal, start)
	local open = PQ.new()
	local closed = {}
	local cameFrom = {}
	local tCost = {}

	open:insert(0, start)
	cameFrom[start] = nil
	tCost[start] = 0
	for current in PQ.pop, open do
		if goal(current) then
			return backtrack(current, cameFrom)
		else
			closed[current] = true
			for _, neighbor in pairs(expand(current)) do
				if not closed[neighbor] then
					local tmpCost = tCost[current] + cost(current, neighbor)
					if tCost[neighbor] == nil or tmpCost < tCost[neighbor] then
						cameFrom[neighbor] = current
						tCost[neighbor] = tmpCost
						open:insert(tmpCost + heuristic(neighbor), neighbor)
					end
				end
			end
		end
	end
	return nil
end)

return aStar
