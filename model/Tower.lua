#!/usr/bin/env lua

local Tower = {}
Tower.__index = Tower

function Tower.new(row, col)
   local self = setmetatable({}, Tower)

   self.radius = 5
   self.identifier = 'T'
   self.cow = col
   self.row = row

   return self
end

function Tower.shoot()
end

return Tower
