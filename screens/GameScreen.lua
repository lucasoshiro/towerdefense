#!/usr/bin/env lua

local GameScreen = {}
local Grid = require '../model/Grid'
local Tower = require '../model/Tower'

g = Grid.new()
g:add_tower(2, 4, Tower)

function GameScreen.draw()
   local x_offset, y_offset = 10, 10
   local cell_side = 14
   local border = 1

   love.graphics.setColor(0.2, 0.9, 1)

   for i = 1, g.height do
      for j = 1, g.width do
	 love.graphics.rectangle("fill",
				 x_offset + cell_side * i + border,
				 y_offset + cell_side * j + border,
				 cell_side - 2*border, cell_side - 2*border)
      end
   end

   love.graphics.setColor(0.5, 0.5, 0.5)

   for _, tower in ipairs(g.towers) do
      love.graphics.rectangle("fill",
			      x_offset + cell_side * tower.col + border,
			      y_offset + cell_side * tower.row + border,
			      2*cell_side - 2*border, 2*cell_side - 2*border)

   end

end

return GameScreen
