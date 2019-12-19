#!/usr/bin/env lua

local GridComponent = require '../screen_components/GridComponent'
local Game          = require '../model/Game'
local SimpleEnemy   = require '../model/SimpleEnemy'

local GameScreen = {}
local grid_component = GridComponent.new()

game = Game.new()
game:add_enemy(SimpleEnemy.new(1, 1, 40, 40, game.grid))

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

function GameScreen.mousemoved(x, y, dx, dy, istouch)
   grid_component:mousemoved(x, y, dx, dy)
end

return GameScreen
