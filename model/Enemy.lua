#!/usr/bin/env lua

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, vel, life, radius)
   local self = setmetatable({}, Enemy)
   self.__index = self

   self.vel = vel

   self.x, self.y = x, y

   self.vel_x = 0
   self.vel_y = self.vel

   self.life = life
   self.radius = radius

   return self
end

function Enemy:update(dt)
   local x = self.x
   local y = self.y

   self.x = self.x + self.vel_x * dt
   self.y = self.y + self.vel_y * dt

   if (math.floor(self.x + 0.5) ~= math.floor(x + 0.5) or
       math.floor(self.y + 0.5) ~= math.floor(y + 0.5)) then

      self:refresh_path()
      self:refresh_vel()
   end
end

function Enemy:refresh_path()
end

function Enemy:refresh_vel()
end


function Enemy:alive()
   return self.life > 0
end

function Enemy:hurt(hurt)
   self.life = self.life - hurt
end

return Enemy
