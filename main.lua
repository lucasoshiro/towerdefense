#!/usr/bin/env lua

local GameScreen = require 'screens/GameScreen'

local current_screen = GameScreen

function love.load()
   x, y, w, h = 20, 20, 60, 20
end
 
function love.update(dt)
    
end
 
function love.draw()
   current_screen.draw()
end
