#!/usr/bin/env lua

local GameScreen = {}
local Grid = require '../model/Grid'
local Tower = require '../model/Tower'

local grid_offx, grid_offy = 10, 10
local cell_side = 14
local border = 1

g = Grid.new()

function GameScreen.draw()
   love.graphics.setColor(0.2, 0.9, 1)

   for i = 1, g.height do
      for j = 1, g.width do
	 love.graphics.rectangle("fill",
				 grid_offx + cell_side * i + border,
				 grid_offy + cell_side * j + border,
				 cell_side - 2*border, cell_side - 2*border)
      end
   end

   love.graphics.setColor(0.5, 0.5, 0.5)

   for _, tower in ipairs(g.towers) do
      love.graphics.rectangle("fill",
			      grid_offx + cell_side * tower.col + border,
			      grid_offy + cell_side * tower.row + border,
			      2*cell_side - 2*border, 2*cell_side - 2*border)

   end
end

function GameScreen.mousepressed(x, y, button, istouch, presses)
   local col, row = xy_to_coord(x, y)
   g:add_tower(row, col, Tower)
end

function xy_to_coord(x, y)
   local c_x = math.floor((x - grid_offx) / cell_side)
   local c_y = math.floor((y - grid_offy) / cell_side)
   return c_x, c_y
end

return GameScreen
