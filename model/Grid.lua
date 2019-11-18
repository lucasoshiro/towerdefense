#!/usr/bin/env lua

local Grid = {}
Grid.__index = Grid

function Grid.new(init)
  local self = setmetatable({}, Grid)

  self.height, self.width = 40, 40
  self.grid = {}

  for i = 1, self.height do
      self.grid[i] = {}
      for j = 1, self.width do
	 self.grid[i][j] = nil
      end
   end

  return self
end

function Grid.print(self)
   for i = 1, self.height do
      for j = 1, self.width do
	 if self.grid[i][j] then
	    io.write(self.grid[i][j].identifier)
	 else
	    io.write('_')
	 end
	 io.write(' ')
      end
      io.write('\n')
   end
end

function Grid.has_space_for_tower(self, row, col)
   return not (self.grid[row][col]     or
               self.grid[row][col+1]   or
               self.grid[row+1][col]   or
               self.grid[row+1][col+1])
end

function Grid.add_tower(self, row, col, tower)
   self.grid[row][col]     = tower
   self.grid[row][col+1]   = tower
   self.grid[row+1][col]   = tower
   self.grid[row+1][col+1] = tower
end

return Grid
