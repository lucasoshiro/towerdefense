#!/usr/bin/env lua

local GridComponent = require '../screen_components/GridComponent'

local GameScreen = {}
local grid_component = GridComponent.new()

function GameScreen.draw()
   grid_component:draw()
end

function GameScreen.update(dt)
   grid_component:update(dt)
end

function GameScreen.mousepressed(x, y, button, istouch, presses)
   if x == 0 or y == 0 then return end
   grid_component:mousepressed(x, y)
end

return GameScreen
