#!/usr/bin/env lua

local GameScreen = require 'screens/GameScreen'
local Game       = require 'model/Game'

local current_screen = GameScreen

function love.load()
   x, y, w, h = 20, 20, 60, 20
   game = Game.new()
   love.window.setMode(1000, 700)
   love.graphics.setBackgroundColor(0.8, 0.8, 0.8)
end
 
function love.update(dt)
   current_screen.update(dt)
end
 
function love.draw()
   current_screen.draw()
end

function love.mousepressed(x, y, button, istouch, presses)
   current_screen.mousepressed(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
   current_screen.mousemoved(x, y, dx, dy, istouch)
end
