#!/usr/bin/env lua

local Enemy  = require '../model/Enemy'
local a_star = require '../util/a_star'
local dist   = require '../util/dist'

local SimpleEnemy = setmetatable({}, Enemy)
SimpleEnemy.__index = SimpleEnemy

function SimpleEnemy.new(x, y, goal_x, goal_y, grid)
   local self = setmetatable(Enemy.new(x, y, 0.2, 300, 0.5), SimpleEnemy)
   self.__index = SimpleEnemy

   self.grid = grid

   self.goal_x, self.goal_y = goal_x, goal_y

   self:refresh_path()
   self:refresh_vel()

   return self
end

function SimpleEnemy:refresh_path()
   local start = {math.floor(self.x + 0.5), math.floor(self.y + 0.5)}
   local goal = {self.goal_x, self.goal_y}
   self.path = a_star(self.grid.grid,
		      function(p) return dist(p, goal) end,
		      start,
		      goal,
		      self.grid.height,
		      self.grid.width)
end

function SimpleEnemy:refresh_vel()
   local fst, snd = self.path[1], self.path[2]

   local delta_x, delta_y = snd[1] - self.x, snd[2] - self.y

   self.vel_x = delta_x * self.vel
   self.vel_y = delta_y * self.vel
end

return SimpleEnemy
