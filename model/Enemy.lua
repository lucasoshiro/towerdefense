#!/usr/bin/env lua

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, vel, life)
   local self = setmetatable({}, Enemy)
   self.__index = self

   self.x = x
   self.y = y

   self.vel_x = vel
   self.vel_y = 0

   self.life = life

   return self
end

function Enemy:update(dt)
   self.x = self.x + self.vel_x * dt
   self.y = self.y + self.vel_y * dt
end

function Enemy:alive()
   return self.life > 0
end

function Enemy:hurt(hurt)
   self.life = self.life - hurt
end

return Enemy
