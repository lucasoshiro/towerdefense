#!/usr/bin/env lua

local Tower        = require '../model/Tower'
local SimpleBullet = require '../model/SimpleBullet'

local SimpleTower = setmetatable({}, Tower)
SimpleTower.__index = SimpleTower

SimpleTower.radius = 7

function SimpleTower.new(row, col)
   local self = setmetatable(Tower.new(row, col), SimpleTower)
   self.__index = SimpleTower
   self.identifier = 'S'
   self.bullet_type = SimpleBullet
   self.radius = SimpleTower.radius
   self.col = col
   self.row = row

   self.shoot_interval = 0.3
   self.last_shoot = love.timer.getTime()

   return self
end

function SimpleTower:shoot()
   local bullets = {}
   local enemies = self:near_enemies()

   for _, enemy in ipairs(enemies) do
      local row, col = enemy.x, enemy.y
      local delta_col, delta_row = col - (self.col+1), row - (self.row+1)
      local d = math.sqrt(delta_col * delta_col + delta_row * delta_row)
      local angle

      if delta_col > 0 then
	 angle = math.asin(delta_row / d)
      else
	 angle = math.pi - math.asin(delta_row / d)
      end

      bullets[#bullets+1] = SimpleBullet.new(self.col+1, self.row+1, angle)
   end

   return bullets
end

return SimpleTower
