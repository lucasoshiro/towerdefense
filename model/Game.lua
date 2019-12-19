#!/usr/bin/env lua

local Grid = require '../model/Grid'
local dist = require '../util/dist'

local Game = {}
Game.__index = Game

function Game.new()
   local self = setmetatable({}, Game)

   self.grid = Grid.new()
   self.towers = {}
   self.bullets = {}
   self.enemies = {}

   return self
end

function Game:add_tower(row, col, tower_type)
   if not self.grid:has_space_for_tower(row, col) then return end

   local tower = tower_type.new(row, col)
   self.towers[#self.towers + 1] = tower
   self.grid:add_tower(row, col, tower)

   return true
end

function Game:add_bullet(bullet)
   self.bullets[bullet] = true
end

function Game:add_enemy(enemy)
   self.enemies[enemy] = true
end

function Game:update(dt)
   for bullet, _ in pairs(self.bullets) do
      if not bullet:alive() then self.bullets[bullet] = nil end
      bullet:update(dt)
   end

   for enemy, _ in pairs(self.enemies) do
      if not enemy:alive() then self.enemy[enemy] = nil end
      enemy:update(dt)
   end

   for _, tower in ipairs(self.towers) do
      for __, bullet in ipairs(tower:try_shoot()) do
         self:add_bullet(bullet)
      end
   end
end

function Game:get_enemies_on_radius(col, row, radius)
   local tower = {col + 1, row + 1}
   local near_enemies = {}
   for enemy, _ in pairs(self.enemies) do
      if dist(tower, {enemy.y, enemy.x}) < radius then
         near_enemies[#near_enemies + 1] = enemy
      end
   end
   return near_enemies
end

return Game
