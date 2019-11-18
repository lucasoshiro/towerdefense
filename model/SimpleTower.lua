#!/usr/bin/env lua

local Tower = require '../model/Tower'

local SimpleTower = {}
SimpleTower.__index = SimpleTower

function SimpleTower.new(row, col)
   local self = Tower.new(row, col)
   self.identifier = 'S'
   return self
end

return SimpleTower
