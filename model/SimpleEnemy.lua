#!/usr/bin/env lua

local Enemy  = require '../model/Enemy'
local a_star = require '../util/a_star'
local dist   = require '../util/dist'

local SimpleEnemy = setmetatable({}, Enemy)
SimpleEnemy.__index = SimpleEnemy
SimpleEnemy.reward = 5

function SimpleEnemy.new(x, y, goal_x, goal_y, grid)
   local self = setmetatable(Enemy.new(x, y, goal_x, goal_y, 0.75, 20, 0.5), SimpleEnemy)
   self.__index = SimpleEnemy

   self.grid = grid
   self:refresh_path()
   self:refresh_vel()
   self.reward = SimpleEnemy.reward

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

   if not fst or not snd then return end

   local delta_x, delta_y = snd[1] - self.x, snd[2] - self.y

   self.vel_x = delta_x * self.vel
   self.vel_y = delta_y * self.vel
end

return SimpleEnemy
