#!/usr/bin/env lua

local Component = {}
Component.__index = Component

function Component.new(offset_x, offset_y)
   local self = setmetatable({}, Component)
   self.__index = self

   self.offset_x = offset_x
   self.offset_y = offset_y

   return self
end

function Component:canvasX(x)
   return self.offset_x + x
end

function Component:canvasY(y)
   return self.offset_y + y
end

function Component:compX(x)
   return x - self.offset_x
end

function Component:compY(y)
   return y - self.offset_y
end

return Component
