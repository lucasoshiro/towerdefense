#!/usr/bin/env lua

local Component   = require '../screen_components/Component'
local dist        = require '../util/dist'
local SimpleTower = require '../model/SimpleTower'
local a_star      = require '../util/a_star'

local cell_side = 14
local border = 1

local GridComponent = setmetatable({}, Component)
GridComponent.__index = GridComponent

function GridComponent.new()
   local self = setmetatable(Component.new(10, 10), GridComponent)
   self.__index = GridComponent
   return self
end

function GridComponent:draw()
   self:draw_grid()
   self:draw_source_and_goal()
   self:draw_towers()
   self:draw_enemies()
   self:draw_bullets()
   self:draw_life()
   self:draw_hlighted()
end

function GridComponent:update(dt)
   game:update(dt)
end

function GridComponent:mousepressed(x, y)
   local col, row = self:xy_to_coord(x, y)
   game:add_tower(row, col, SimpleTower)
end

function GridComponent:mousemoved(x, y, dx, dy)
   local col, row = self:xy_to_coord(x, y)
   local w, h = game.grid.width, game.grid.height
   if (col >= 1 and col < w and  row >= 1 and row < h) then
      self.hlighted_col = col
      self.hlighted_row = row
   else
      self.hlighted_col = nil
      self.hlighted_row = nil
   end
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

function GridComponent:vdim_to_dim(v_dim)
   return v_dim * (cell_side + 2 * border)
end

function GridComponent:draw_grid()
   love.graphics.setColor(0.8, 0.9, 0.8)
   local g = game.grid

   for i = 1, g.height do
      for j = 1, g.width do
	 self:draw_grid_cell(i, j)
      end
   end
end

function GridComponent:draw_towers()
   for _, tower in ipairs(game.towers) do
      local x, y
      love.graphics.setColor(0.5, 0.5, 0.5)
      x, y = self:coord_to_xy(tower.col, tower.row)
      love.graphics.rectangle("fill", x, y,
			      2*cell_side - 2*border,
			      2*cell_side - 2*border)

      x, y = x + cell_side, y + cell_side
      love.graphics.setColor(0, 0, 00)
      love.graphics.circle("line", x, y, cell_side / 2)
   end
end

function GridComponent:draw_bullets()
   love.graphics.setColor(0.0, 0.0, 1)
   for bullet, _ in pairs(game.bullets) do
      local x, y = self:coord_to_xy(bullet.col, bullet.row)
      local radius = self:vdim_to_dim(bullet.radius)
      x = x + radius
      y = y + radius
      love.graphics.circle("fill", x, y, radius)
   end
end

function GridComponent:draw_enemies()
   for enemy, _ in pairs(game.enemies) do
      local x, y = self:coord_to_xy(enemy.y, enemy.x)
      local inner_radius = self:vdim_to_dim(enemy.radius - 0.15)
      local outer_radius = self:vdim_to_dim(enemy.radius)

      x = x + outer_radius
      y = y + outer_radius
      love.graphics.setColor(0.5, 0.25, 0)
      love.graphics.circle("fill", x, y, outer_radius)
      love.graphics.setColor(1, 0.5, 0)
      love.graphics.circle("fill", x, y, inner_radius)
   end
end

function GridComponent:draw_hlighted()
   local col, row = self.hlighted_col, self.hlighted_row
   local tower_type = game.selected_tower_type

   if not tower_type then return end

   local radius = tower_type.radius
   if not (col and row) then return end

   local x, y = self:coord_to_xy(col, row)

   love.graphics.setColor(0.5, 0.6, 0.8, 0.8)
   love.graphics.rectangle("fill", x, y,
			   2*cell_side - 2*border,
			   2*cell_side - 2*border)

   x, y = x + cell_side, y + cell_side
   love.graphics.setColor(0, 0, 0, 0.8)
   love.graphics.circle("line", x, y, cell_side / 2)

   x, y = self:coord_to_xy(col+1, row+1)
   love.graphics.setColor(0.6, 0.2, 0.2, 0.6)
   love.graphics.circle("fill", x, y, radius * cell_side)
end

function GridComponent:draw_enemy_path(enemy)
   love.graphics.setColor(0.3, 0, 0.5)
   for _, node in ipairs(enemy.path) do
      self:draw_grid_cell(node[2], node[1])
   end
end

function GridComponent:draw_source_and_goal()
   local x, y

   love.graphics.setColor(1, 0, 0)
   self:draw_grid_cell(game.source_col, game.source_row)

   love.graphics.setColor(0, 1, 0)
   self:draw_grid_cell(game.goal_col, game.goal_row)
end

function GridComponent:draw_life()
   for enemy, _ in pairs(game.enemies) do
      local x, y = self:coord_to_xy(enemy.y - 0.25, enemy.x + 1.5)
      local life = enemy.life / enemy.max_life

      love.graphics.setColor(0.0, 0.5, 0)
      love.graphics.rectangle("fill", x, y,
			      1.5 * cell_side * life,
			      0.3 * cell_side)
   end
end

function GridComponent:draw_grid_cell(col, row)
   local x, y = self:coord_to_xy(col, row)
   love.graphics.rectangle("fill", x, y,
                           cell_side - 2*border,
                           cell_side - 2*border)
end

return GridComponent
