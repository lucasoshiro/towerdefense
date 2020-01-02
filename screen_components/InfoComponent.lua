#!/usr/bin/env lua

local Component = require '../screen_components/Component'

local InfoComponent = setmetatable({}, Component)
InfoComponent.__index = InfoComponent

function InfoComponent.new()
   local self = setmetatable(Component.new(600, 10), InfoComponent)
   return self
end

function InfoComponent:draw()
   love.graphics.setColor(1, 1, 1)
   love.graphics.setLineWidth(2)
   love.graphics.rectangle("line", self:canvasX(0), self:canvasY(0), 375, 200)

   love.graphics.setColor(0, 0, 0)
   love.graphics.print('Life: ' .. game.life,
		       self:canvasX(10), self:canvasY(10))
   love.graphics.print('Credits: ' .. game.credits,
		       self:canvasX(10), self:canvasY(30))

end

function InfoComponent:update(dt)
end

return InfoComponent
