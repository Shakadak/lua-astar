local aStar = require "AStar"
local HOF   = require "HOF"

-- Here we define our graph. A simple table pointing containing for each key (node)
-- an array of node
local graph = {}
graph["A"] = {"B", "C"}
graph["B"] = {"D"}
graph["C"] = {"A", "E"}
graph["E"] = {"C", "D"}

-- So we currently have the followin representation
