#!/usr/bin/env lua

local Grid = require '../model/Grid'
local dist = require '../util/dist'

local SimpleEnemy   = require '../model/SimpleEnemy'
local SimpleTower   = require '../model/SimpleTower'
local CrowdSchedule = require '../model/CrowdSchedule'

local Game = {}
Game.__index = Game

function Game.new()
   local self = setmetatable({}, Game)

   self.grid = Grid.new()
   self.towers = {}
   self.bullets = {}
   self.enemies = {}

   self.source_row, self.source_col = 20, 1
   self.goal_row,   self.goal_col = 20, 40

   self.credits = 50
   self.selected_tower_type = SimpleTower

   self.life = 10

   self.schedule = CrowdSchedule.new()
   return self
end

function Game:enough_credits_for_tower()
   return self.credits >= self.selected_tower_type.price
end

function Game:game_over()
   return self.life <= 0
end

function Game:add_tower(row, col, tower_type)
   if not self.grid:has_space_for_tower(row, col) then return end

   if not self:enough_credits_for_tower() then return end

   local tower = tower_type.new(row, col)
   self.towers[#self.towers + 1] = tower
   self.grid:add_tower(row, col, tower)

   self.credits = self.credits - self.selected_tower_type.price

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
   self:update_bullets(dt)
   self:update_enemies(dt)
   self:update_towers()
   self:handle_collisions()

   if self:game_over() then os.exit(0) end
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
	 end
      end
   end
end

function Game:update_bullets(dt)
   for bullet, _ in pairs(self.bullets) do
      if not bullet:alive() then self.bullets[bullet] = nil end
      bullet:update(dt)
   end
end

function Game:update_enemies(dt)
   for enemy, _ in pairs(self.enemies) do
      if not enemy:alive() then
	 -- Enemy died
	 self.credits = self.credits + enemy.reward
	 self:remove_enemy(enemy)
      elseif (math.floor(enemy.x) == self.goal_row and
	       math.floor(enemy.y) == self.goal_col) then
	 -- Enemy reached the goal
	 self.life = self.life - 1
	 self:remove_enemy(enemy)
      end

      enemy:update(dt)
   end

   local enemy_type = self.schedule:try_new_enemy()
   if enemy_type then
      self:add_enemy(enemy_type.new(self.source_row, self.source_col,
				    self.goal_row, self.goal_col, self.grid))
   end
end

function Game:update_towers()
   for _, tower in ipairs(self.towers) do
      for __, bullet in ipairs(tower:try_shoot()) do
         self:add_bullet(bullet)
      end
   end
end


return Game
