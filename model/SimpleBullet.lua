#!/usr/bin/env lua

local Bullet = require '../model/Bullet'

local SimpleBullet = {}
SimpleBullet.__index = SimpleBullet

function SimpleBullet.new(x, y)
   local self = Bullet.new(x, y, 0.5, 0.5)
   self.damage = 1
   self.distance = 10
   return self
end

return SimpleBullet
