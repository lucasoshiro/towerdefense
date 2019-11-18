#!/usr/bin/env lua

local Bullet = {}
Bullet.__index = Bullet

function Bullet.new()
   local self = setmetatable({}, Bullet)
   self.distance = 0
   self.damage = 0
   return self
end

return Bullet
