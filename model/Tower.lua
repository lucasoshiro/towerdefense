#!/usr/bin/env lua

local Tower = {}
Tower.__index = Tower

function Tower.new(row, col)
   local self = setmetatable({}, Tower)
   self.__index = self

   self.radius = 5
   self.identifier = 'T'
   self.col = col
   self.row = row

   return self
end

return Tower
