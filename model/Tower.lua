#!/usr/bin/env lua

local Tower = {}
Tower.__index = Tower

function Tower.new(row, col)
   local self = setmetatable({}, Tower)
   self.__index = self

   self.radius = 5
   self.identifier = 'T'
   self.col = col
   self.row = row

   return self
end

function Tower:near_enemies()
   return game:get_enemies_on_radius(self.col, self.row, self.radius)
end

function Tower:try_shoot()
   local t = love.timer.getTime()
   if t - self.last_shoot < self.shoot_interval then return {} end
   self.last_shoot = t

   return self:shoot()
end

function Tower:shoot()

end

return Tower
