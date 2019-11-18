#!/usr/bin/env lua

local Grid = require '../model/Grid'

local Game = {}
Game.__index = Game

function Game.new()
   local self = setmetatable({}, Game)

   self.grid = Grid.new()
   self.towers = {}
   self.bullets = {}

   return self
end

function Game.add_tower(self, row, col, tower_type)
   if not self.grid:has_space_for_tower(row, col) then return end

   local tower = tower_type.new(row, col)
   self.towers[#self.towers + 1] = tower
   self.grid:add_tower(row, col, tower)

   return true
end

function Game.add_bullet(self, bullet)
   self.bullets[bullet] = true
end

function Game.update(self, dt)
   for bullet, _ in pairs(self.bullets) do
      if not bullet:alive() then self.bullets[bullet] = nil end
      bullet:update(dt)
   end
end

return Game
