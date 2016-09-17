# lua-astar
A simple implementation of the A* pathfinding algorithm

# How to use it
The `aStar` function expect a few more arguments than most other implementations available anywhere.  
Here is a reproduction of the `example.lua` file:

```lua
local aStar = require "AStar"
```
Here we define our graph. A simple table pointing containing for each key (node)
an array of node.
```lua
local graph = {}
graph["A"] = {"B", "C"}
graph["B"] = {"D"}
graph["C"] = {"A", "E"}
graph["E"] = {"C", "D"}
graph["D"] = {"E", "F"}
graph["F"] = {"D", "G"}
graph["G"] = {"F", "H", "E"}
graph["H"] = {"E"}
```
So we currently have the following representation:
```
A ↔ C ↔ E ← H
↓     ⤢   ↖ ↕
B → D ↔ F ↔ G
```
First we need to define a function that, given a node, returns an array `{node} / {index = node } / {key = node}`
of the nodes linked to the given node.
Since our graph is simply defined, it will be straightforward
```lua
local function expand(n)
    return graph[n]
end
```
Now we need to define a function that, given two nodes, return the cost of going
from the first to the second.
Again, we want to keep it simple. Our graph does not hold these value, so we will
simply return `1` every time.
```lua
local function cost(from, to)
    return 1
end
```
Now we need to define a function that, given a node, return the estimated cost
of the path left to reach the goal.
As always, since our graph is so simple, we will content ourselves with returning `0`
every time. This will make our `aStar` equivalent to a `dijkstra`.
```lua
local function heuristic(n)
    return 0
end
```
Last, but not least, we need to define that, given a node, return whether we have
reached our goal or not. As the first example, we will want to find the path
from `A` to `D`.
```lua
local goalD = function(n)
    return n == "D"
end
```
To avoid repeated call of the same functions, we will define a `simpleAStar`
in order to concern ourselves only with the goal and the start.
```lua
local simpleAStar = aStar(expand)(cost)(heuristic)
```
Because this is the barbone version, you must pass each argument separatly.
Just make sure to apply the arguments in the correct order.

We can now ask `simpleAStar` to find the path from `A` to `D`.
```lua
local path = simpleAStar(goalD)("A")
```
The only thing left to do is display the path we found.
We do need a function to convert our path to something printable.
```lua
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
```
If everything worked fine, it should display `A → B → D`.
```lua
print(pathToString(path))
```
Now we want the path to go from `D` to `A`.
For future reuse, we will define a curryied function that simply check
if our node is in an array of node.
```lua
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
```
This time we cannot pass by B, it should display `D → E → C → A`.
```lua
print(pathToString(simpleAStar(goal({"A"}))("D")))
```
We could now considere that both `B` and `D` are point of interest,
and we want to get to one of them, we do not particularly care
but we want the one with the shorter travel. Our graph is too simple
to present something meaningful here, but by changing the starting
node, we can show how the path differe.

Starting with `C` should give us either `C → A → B` or `C → E → D`.
```lua
print(pathToString(simpleAStar(goal({"B", "D"}))("C")))
```
Starting with `A` should give us `A → B`.
```lua
print(pathToString(simpleAStar(goal({"B", "D"}))("A")))
```
Starting with `E` should give us `E → D`.
```lua
print(pathToString(simpleAStar(goal({"B", "D"}))("E")))
```

Starting with `H` should give us `H → E → D`.
```lua
print(pathToString(simpleAStar(goal({"B", "D"}))("H")))
```
Starting with `A` should give `A → B → D → F → G → H`
```lua
print(pathToString(simpleAStar(goal({"H"}))("A")))
```
