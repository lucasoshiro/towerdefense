#!/usr/bin/env lua

local SimpleEnemy = require '../model/SimpleEnemy'

local CrowdSchedule = {}
CrowdSchedule.__index = CrowdSchedule

function CrowdSchedule.new()
   local self = setmetatable({}, CrowdSchedule)

   self.interval = 2
   self.amount = 10
   self.countdown = self.amount

   return self
end

function CrowdSchedule:try_new_enemy()
   local current_liberation = love.timer.getTime()
   if (self.last_liberation and
       current_liberation - self.last_liberation < self.interval or
       self.countdown <= 0) then
      return nil
   end

   self.last_liberation = current_liberation
   self.countdown = self.countdown - 1
   return SimpleEnemy
end

return CrowdSchedule
