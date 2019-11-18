#!/usr/bin/env lua

local pqueue = {}

function left(i)   return i*2 end
function right(i)  return i*2 + 1 end
function parent(i) return i//2 end

pqueue.w8 = function(n) return n end

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
   while i >= 2 and pqueue.w8(self[parent(i)]) > pqueue.w8(self[i]) do
      self[parent(i)], self[i] = self[i], self[parent(i)]
      i = parent(i)
   end
end

function pqueue:min_heapify(i)
   local l, r = left(i), right(i)
   local m = i

   if l <= #self and pqueue.w8(self[l]) < pqueue.w8(self[i]) then m = l end
   if r <= #self and pqueue.w8(self[r]) < pqueue.w8(self[m]) then m = r end

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

function neighbours(grid, x, y)
   local n = {}

   for i = math.max(1, x-1), math.min(#grid, x+1) do
      for j = math.max(1, y-1), math.min(#grid[i], y+1) do
         if not(i == x and j == y) then n[#n+1] = {i, j} end
      end
   end

   return n
end

function recreate_path(previous, goal)
   local node = goal
   local path = {}

   while node do
      path[#path+1] = node
      local x, y = table.unpack(node)
      node = previous[x][y]
   end

   return path
end

function a_star(grid, cost, start, goal)
   pqueue.w8 = cost
   pqueue:clear()
   pqueue:push(start)

   local goal_x, goal_y = table.unpack(goal)

   local reached = {}
   for i = 1, #grid do reached[i] = {} end
   reached[start[1]][start[2]] = true

   local previous = {}
   for i = 1, #grid do previous[i] = {} end

   while #pqueue > 0 do
      local node = pqueue:pop()
      local x, y = table.unpack(node)

      if x == goal_x and y == goal_y then
	 return recreate_path(previous, goal)
      end

      local nbs = neighbours(grid, x, y)

      for _, n in ipairs(nbs) do
	 local n_x, n_y = table.unpack(n)

	 if not reached[n_x][n_y] then
	    reached[n_x][n_y] = true
	    previous[n_x][n_y] = {x, y}
	    pqueue:push(n)
	 end
      end
   end
end

local grid = {}
for i = 1, 10 do
   grid[i] = {}
   for j = 1, 10 do
      grid[i][j] = false
   end
end

local path = (a_star(grid,
		     function(p)
			return p[1] + p[2]
		     end, {1, 1}, {10, 10}))

for _, node in ipairs(path) do
   print(table.unpack(node))
end
