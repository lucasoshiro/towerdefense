#!/usr/bin/env lua

local Bullet = require '../model/Bullet'

local SimpleBullet = setmetatable({}, Bullet)
SimpleBullet.__index = SimpleBullet

function SimpleBullet.new(x, y, angle)
   local self = setmetatable(Bullet.new(x, y, angle, 4), SimpleBullet)
   self.__index = SimpleBullet
   self.damage = 1
   self.distance = 4
   return self
end

return SimpleBullet
