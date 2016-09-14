-- Priority Queue
-- Heap Based
-- Array Version

local PQ = {}

PQ.new = function ()
    local queue = {
        n      = 0,
        pop    = PQ.pop,
        insert = PQ.insert
    }
    return queue
end

PQ.insert = function (self, priority, elem)
    local n = self.n + 1
    self.n = n
    self[n] = {p=priority,v=elem}
    local i = n
    while i >= 2 do
        local j = math.floor(i / 2)
        if self[i].p < self[j].p then
            self[i], self[j] = self[j], self[i]
        end
        i = j
    end
end

PQ.lookup = function(self, value)
    for p, v in pairs(self) do
        if v == value then return p, v end
    end
    return nil, nil
end

PQ.pop = function (self)
    if self.n == 0 then return nil end
    local ret = self[1]
    local n   = self.n
    self[1], self[n] = self[n], nil
    self.n = n - 1
    local i = 1
    while i < self.n do
        local left = 2 * i
        local right = 2 * i + 1
        local current = i
        if left <= self.n then
            if self[left].p < self[i].p then
                i = left
            end
        end
        if right <= self.n then
            if self[right].p < self[i].p then
                i = right
            end
        end
        if current == i then break
        else
            self[current], self[i] = self[i], self[current]
        end
    end
    return ret.v
end

return PQ
