#!/usr/bin/env lua

local Bullet = {}
Bullet.__index = Bullet

function Bullet.new(x, y, angle, vel)
   local self = setmetatable({}, Bullet)
   self.distance = 0
   self.damage = 0

   self.origin_x = x
   self.origin_y = y

   self.x = x
   self.y = y
   self.vel_x = vel * math.cos(angle)
   self.vel_y = vel * math.sin(angle)

   return self
end

function Bullet.alive(self)
   local delta_x, delta_y = self.x - self.origin_x, self.y - self.origin_y
   return math.sqrt((delta_x * delta_x) + (delta_y * delta_y)) <= self.distance
end

function Bullet.update(self, dt)
   self.x = self.x + self.vel_x * dt
   self.y = self.y + self.vel_y * dt
end

return Bullet
