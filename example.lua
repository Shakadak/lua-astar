local aStar = require "AStar"
local HOF   = require "HOF"

-- Here we define our graph. A simple table pointing containing for each key (node)
-- an array of node
local graph = {}
graph["A"] = {"B", "C"}
graph["B"] = {"D"}
graph["C"] = {"A", "E"}
graph["E"] = {"C", "D"}
graph["D"] = {"E"}

-- So we currently have the following representation
-- A ↔ C ↔ E
-- ↓     ⤢
-- B → D

-- First we need to define a function that, given a node, returns an array/table of node
-- Since our graph is simply defined, it will be straightforward
local function expand(n)
    return graph[n]
end

-- Now we need to define a function that, given two nodes, return the cost of going
-- from the first to the second
-- Again, we want to keep it simple. Our graph does not hold these value, so we will
-- simply return `1` every time
local function cost(from, to)
    return 1
end

-- Now we need to define a function that, given a node, return the estimated cost
-- of the path left to reach the goal
-- As always, since our graph is so simple, we will content ourselves with returning `0`
-- every time. This will make our `aStar` equivalent to a `dijkstra`.
local function heuristic(n)
    return 0
end

-- Last, but not least, we need to define that, given a node, return whether we have
-- reached our goal or not. As the first example, we will want to find the path
-- from `A` to `D`
local goalD = function(n)
    return n == "D"
end

-- To avoid repeated call of the same function, we will define a `simpleAStar`
-- in order to concern ourselves only with the goal and the start.
local simpleAStar = aStar(expand, cost, heuristic)
-- You may call aStar in whichever way you want
-- aStar(expand)(cost)(heuristic) is just as valid
-- just make sure to apply the arguments in the correct order

-- We can now ask `simpleAStar` to find the path from `A` to `D`
local path = simpleAStar(goalD, "A")

-- The only thing left to do is display the path we found
-- We do need a function to convert our path to something printable
local function pathToString(path)
    if path == nil then
        return "No path found"
    else
        local ret = table.remove(path, 1)
        for _, n in ipairs(path) do
            ret = ret .. " → " .. n
        end
        return ret
    end
end

-- If everything worked fine, it should display `A → B → D`
print(pathToString(path))

-- Now we want the path to go from `D` to `A`
-- For future reuse, we will define a curryied function that simply check
-- if our node is in an array of node
local function goal(targets)
    return function(current)
        for _, target in pairs(targets) do
            if current == target then
                return true
            end
        end
        return false
    end
end

-- this time we cannot pass by B, it should display `D → E → C → A`
print(pathToString(simpleAStar(goal({"A"}), "D")))
