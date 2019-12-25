#!/usr/bin/env lua

local Grid = require '../model/Grid'
local dist = require '../util/dist'

local SimpleEnemy = require '../model/SimpleEnemy'
local CrowdSchedule = require '../model/CrowdSchedule'

local Game = {}
Game.__index = Game

function Game.new()
   local self = setmetatable({}, Game)

   self.grid = Grid.new()
   self.towers = {}
   self.bullets = {}
   self.enemies = {}
   self.schedule = CrowdSchedule.new()
   -- self:add_enemy(SimpleEnemy.new(1, 1, 40, 40, self.grid))

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

function Game:remove_bullet(bullet)
   self.bullets[bullet] = nil
end

function Game:remove_enemy(enemy)
   self.enemies[enemy] = nil
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

   local enemy_type = self.schedule:try_new_enemy()

   if enemy_type then
      self:add_enemy(enemy_type.new(1, 1, 40, 40, self.grid))
   end

   self:handle_collisions()
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

function Game:handle_collisions()
   for enemy, _ in pairs(self.enemies) do
      for bullet, __ in pairs(self.bullets) do
	 local d = dist({enemy.x, enemy.y}, {bullet.row, bullet.col})
	 local penetration = 0.05

	 if d <= (enemy.radius + bullet.radius - penetration) then
	    self:remove_bullet(bullet)

	    enemy:hurt(bullet.damage)

	    if not enemy:alive() then
	       self:remove_enemy(enemy)
	    end

	 end
      end
   end
end

function Game:schedule_push(enemy_type)
end

function Game:schedule_run()
end


return Game
