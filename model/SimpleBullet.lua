#!/usr/bin/env lua

local Bullet = require '../model/Bullet'

local SimpleBullet = setmetatable({}, Bullet)
SimpleBullet.__index = SimpleBullet
SimpleBullet.distance = 5

function SimpleBullet.new(col, row, angle)
   local self = setmetatable(Bullet.new(col, row, angle, 10, 0.3),
			     SimpleBullet)
   self.__index = SimpleBullet
   self.damage = 1
   self.distance = SimpleBullet.distance
   return self
end

return SimpleBullet
