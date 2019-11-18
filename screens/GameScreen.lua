#!/usr/bin/env lua

local GameScreen = {}
local Grid = require '../model/Grid'
local SimpleTower = require '../model/SimpleTower'
local SimpleBullet = require '../model/SimpleBullet'
local Game = require '../model/Game'
local Enemy = require '../model/Enemy'

local grid_offx, grid_offy = 10, 10
local cell_side = 14
local border = 1

game = Game.new()
game:add_enemy(Enemy.new(0, 20, 1, 5))

function GameScreen.draw()
   draw_grid()
   draw_bullets()
   draw_enemies()
end

function GameScreen.update(dt)
   game:update(dt)
end

function GameScreen.mousepressed(x, y, button, istouch, presses)
   print(x, y)
   local col, row = xy_to_coord(x, y)
   game:add_tower(row, col, SimpleTower)
end

function xy_to_coord(x, y)
   local c_x = math.floor((x - grid_offx) / cell_side)
   local c_y = math.floor((y - grid_offy) / cell_side)
   return c_x, c_y
end

function coord_to_xy(c_x, c_y)
   local x = grid_offx + cell_side * c_x + border
   local y = grid_offy + cell_side * c_y + border

   return x, y
end

function draw_grid()
   love.graphics.setColor(0.2, 0.9, 1)
   g = game.grid

   for i = 1, g.height do
      for j = 1, g.width do
	 local x, y = coord_to_xy(i, j)
	 love.graphics.rectangle("fill", x, y,
				 cell_side - 2*border,
				 cell_side - 2*border)
      end
   end

   love.graphics.setColor(0.5, 0.5, 0.5)

   for _, tower in ipairs(game.towers) do
      local x, y = coord_to_xy(tower.col, tower.row)
      love.graphics.rectangle("fill", x, y,
			      2*cell_side - 2*border,
			      2*cell_side - 2*border)
   end
end

function draw_bullets()
   love.graphics.setColor(0.0, 0.0, 1)
   for bullet, _ in pairs(game.bullets) do
      local x, y = coord_to_xy(bullet.x, bullet.y)
      love.graphics.circle("fill", x, y, 5)
   end
end

function draw_enemies()
   love.graphics.setColor(0.5, 0.5, 0)

   for enemy, _ in pairs(game.enemies) do
      local x, y = coord_to_xy(enemy.x, enemy.y)
      love.graphics.circle("fill", x, y, 5)
   end
end

return GameScreen
