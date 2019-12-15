#!/usr/bin/env lua

local pqueue = {}

function left(i)   return i*2 end
function right(i)  return i*2 + 1 end
function parent(i) return math.floor(i / 2) end

local entry = {}
function entry:__lt(other)
   return self.count < other.count or
      (self.count == other.count) and self.f(self.value) < other.f(other.value)
end

function entry:__gt(other)
   return self.count > other.count or
      (self.count == other.count) and self.f(self.value) > other.f(other.value)
end

function entry.new(count, f, value)
   local e = {count = count; f = f; value = value}
   setmetatable(e, entry)
   return e
end

function pqueue:pop()
   min = self[1]
   self[1] = self[#self]
   self[#self] = nil
   
   self:min_heapify(1)

   return min
end

function pqueue:push(v)
   self[#self+1] = v
   local i = #self
   while i >= 2 and self[parent(i)] > self[i] do
      self[parent(i)], self[i] = self[i], self[parent(i)]
      i = parent(i)
   end
end

function pqueue:min_heapify(i)
   local l, r = left(i), right(i)
   local m = i

   if l <= #self and self[l] < self[i] then m = l end
   if r <= #self and self[r] < self[m] then m = r end

   if m ~= i then
      self[i], self[m] = self[m], self[i]
      pqueue:min_heapify(m)
   end
end

function pqueue:clear()
   for k in ipairs(self) do
      pqueue[k] = nil
   end
end

function neighbours(grid, h, w, x, y)
   local n = {}

   if x-1 > 0  and not grid[x-1][y] then n[#n+1] = {x-1, y} end
   if x+1 <= h and not grid[x+1][y] then n[#n+1] = {x+1, y} end
   if y-1 > 0  and not grid[x][y-1] then n[#n+1] = {x, y-1} end
   if y+1 <= w and not grid[x][y+1] then n[#n+1] = {x, y+1} end

   return n
end

function recreate_path(previous, goal)
   local node = goal
   local path = {}

   while node do
      table.insert(path, 1, node)
      local x, y = node[1], node[2]
      node = previous[x][y]
   end

   return path
end

function a_star(grid, heuristic, start, goal, h, w)
   local count = 0
   pqueue:clear()
   pqueue:push(entry.new(count, heuristic, start))

   local goal_x, goal_y = goal[1], goal[2]

   local reached = {}
   for i = 1, h do reached[i] = {} end
   reached[start[1]][start[2]] = 0

   local previous = {}
   for i = 1, h do previous[i] = {} end

   while #pqueue > 0 do
      local node = pqueue:pop().value
      local x, y = node[1], node[2]

      if x == goal_x and y == goal_y then

	 return recreate_path(previous, goal)
      end

      local nbs = neighbours(grid, h, w, x, y)

      for _, n in ipairs(nbs) do
	 local n_x, n_y = n[1], n[2]

	 local cost = reached[x][y] + 1

	 if (not reached[n_x][n_y]) or (cost < reached[n_x][n_y]) then
	    if not reached[n_x][n_y] then pqueue:push(entry.new(count, heuristic, n)) end
	    reached[n_x][n_y] = cost
	    previous[n_x][n_y] = {x, y}
	    pqueue:push(entry.new(count, heuristic, n))
	 end
      end

      count = count + 1
   end

   return nil
end

return a_star
