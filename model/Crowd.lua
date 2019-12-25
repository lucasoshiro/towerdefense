#!/usr/bin/env lua

local Crowd = {}
Crowd.__index = Crowd

function Crowd.new(enemy_type, amount)
   local self = setmetatable({}, CrowdSchedule)
   self.__index = self
   self.enemy_type = enemy_type
   self.amount = amount
   self.duration = 20

   return self
end

return Crowd
