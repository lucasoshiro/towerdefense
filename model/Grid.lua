#!/usr/bin/env lua

local Tower = require '../model/Tower'
local SimpleTower = require '../model/SimpleTower'

local Grid = {}
Grid.__index = Grid

function Grid.new(init)
  local self = setmetatable({}, Grid)

  self.height, self.width = 40, 40
  self.grid = {}
  self.towers = {}

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

function Grid.add_tower(self, row, col, tower_type)
   local tower = tower_type.new(row, col)

   self.towers[#self.towers + 1] = tower

   self.grid[row][col]     = tower
   self.grid[row][col+1]   = tower
   self.grid[row+1][col]   = tower
   self.grid[row+1][col+1] = tower
end

return Grid
