#!/usr/bin/env lua

local Bullet = require '../model/Bullet'

local SimpleBullet = setmetatable({}, Bullet)
SimpleBullet.__index = SimpleBullet

function SimpleBullet.new(col, row, angle)
   local self = setmetatable(Bullet.new(col, row, angle, 30), SimpleBullet)
   self.__index = SimpleBullet
   self.damage = 1
   self.distance = 4
   return self
end

return SimpleBullet
