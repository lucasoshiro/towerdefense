#!/usr/bin/env lua

local Bullet = {}
Bullet.__index = Bullet

function Bullet.new(col, row, angle, vel)
   local self = setmetatable({}, Bullet)
   self.distance = 0
   self.damage = 0

   self.origin_col = col
   self.origin_row = row

   self.col = col
   self.row = row
   self.vel_col = vel * math.cos(angle)
   self.vel_row = vel * math.sin(angle)

   return self
end

function Bullet:alive()
   local delta_col = self.col - self.origin_col
   local delta_row = self.row - self.origin_row

   return math.sqrt((delta_col * delta_col) + (delta_row * delta_row)) <= self.distance
end

function Bullet:update(dt)
   self.col = self.col + self.vel_col * dt
   self.row = self.row + self.vel_row * dt
end

return Bullet
