#!/usr/bin/env lua

local Bullet = require './Bullet'

local SimpleBullet = {}
SimpleBullet.__index = SimpleBullet

function SimpleBullet.new()
   local self = Bullet.new()
   self.damage = 1
   return self
end

return SimpleBullet
