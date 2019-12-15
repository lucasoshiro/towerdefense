#!/usr/bin/env lua

local Component   = require '../screen_components/Component'
local Game        = require '../model/Game'
local Enemy       = require '../model/Enemy'
local SimpleEnemy = require '../model/SimpleEnemy'
local SimpleTower = require '../model/SimpleTower'
local dist        = require '../util/dist'

local a_star = require '../util/a_star'

local cell_side = 14
local border = 1

local GridComponent = setmetatable({}, Component)
GridComponent.__index = GridComponent

game = Game.new()
game:add_enemy(SimpleEnemy.new(1, 1, 40, 40, game.grid))

function GridComponent.new()
   local self = setmetatable(Component.new(10, 10), GridComponent)
   self.__index = GridComponent
   return self
end

function GridComponent:draw()
   self:draw_grid()
   self:draw_bullets()
   for enemy, _ in pairs(game.enemies) do
      self:draw_enemy_path(enemy)
   end
   self:draw_towers()
   self:draw_enemies()
end

function GridComponent:update(dt)
   game:update(dt)
end

function GridComponent:mousepressed(x, y)
   local col, row = self:xy_to_coord(x, y)
   game:add_tower(row, col, SimpleTower)
end

function GridComponent:xy_to_coord(x, y)
   local c_x = math.floor(self:compX(x) / cell_side)
   local c_y = math.floor(self:compY(y) / cell_side)
   return c_x, c_y
end

function GridComponent:coord_to_xy(c_x, c_y)
   local x = self:canvasX(cell_side * c_x + border)
   local y = self:canvasY(cell_side * c_y + border)

   return x, y
end

function GridComponent:draw_grid()
   love.graphics.setColor(0.2, 0.9, 1)
   g = game.grid

   for i = 1, g.height do
      for j = 1, g.width do
	 local x, y = self:coord_to_xy(i, j)
	 love.graphics.rectangle("fill", x, y,
				 cell_side - 2*border,
				 cell_side - 2*border)
      end
   end
end

function GridComponent:draw_towers()
   love.graphics.setColor(0.5, 0.5, 0.5)

   for _, tower in ipairs(game.towers) do
      local x, y = self:coord_to_xy(tower.col, tower.row)
      love.graphics.rectangle("fill", x, y,
			      2*cell_side - 2*border,
			      2*cell_side - 2*border)
   end
end

function GridComponent:draw_bullets()
   love.graphics.setColor(0.0, 0.0, 1)
   for bullet, _ in pairs(game.bullets) do
      local x, y = self:coord_to_xy(bullet.x, bullet.y)
      love.graphics.circle("fill", x, y, 5)
   end
end

function GridComponent:draw_enemies()

   for enemy, _ in pairs(game.enemies) do
      local x, y
      -- square
      love.graphics.setColor(0, 0.5, 0)
      x, y = self:coord_to_xy(math.floor(enemy.y + 0.5), math.floor(enemy.x + 0.5))
      love.graphics.rectangle("fill", x, y,
			      cell_side - 2*border,
			      cell_side - 2*border)

      love.graphics.setColor(1, 0, 0)
      x, y = self:coord_to_xy(enemy.y, enemy.x)
      x = x + cell_side/2
      y = y + cell_side/2
      love.graphics.circle("fill", x, y, cell_side/2)
 
   end
end

function GridComponent:draw_path(start, goal)
   local grid = game.grid

   local h = function(p) return dist(p, goal) end

   local path = (a_star(grid.grid,
			h, start, goal,
			grid.height, grid.width))

   love.graphics.setColor(1, 0, 0)

   for _, node in ipairs(path) do
      local x, y = self:coord_to_xy(node[2], node[1])
      love.graphics.rectangle("fill", x, y,
			      cell_side - 2*border,
			      cell_side - 2*border)
   end
end

function GridComponent:draw_enemy_path(enemy)
   love.graphics.setColor(0.3, 0, 0.5)
   for _, node in ipairs(enemy.path) do
      local x, y = self:coord_to_xy(node[2], node[1])
      love.graphics.rectangle("fill", x, y,
			      cell_side - 2*border,
			      cell_side - 2*border)
   end
end

return GridComponent
