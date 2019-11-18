#!/usr/bin/env lua

local Tower = require '../model/Tower'

local SimpleTower = {}
SimpleTower.__index = SimpleTower

function SimpleTower.new()
   local self = Tower.new()
   self.identifier = 'S'
   return self
end

return SimpleTower
