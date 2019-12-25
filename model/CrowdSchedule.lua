#!/usr/bin/env lua

local SimpleEnemy = require '../model/SimpleEnemy'
local Crowd = require '../model/Crowd'

local CrowdSchedule = {}
CrowdSchedule.__index = CrowdSchedule

function CrowdSchedule.new()
   local self = setmetatable({}, CrowdSchedule)
   self.__index = self

   self.initial_delay = 5

   self.interval = 1
   self.crowds = {}

   self.last_liberation = love.timer.getTime()


   self:push_crowd(Crowd.new(SimpleEnemy, 10))
   self:push_crowd(Crowd.new(SimpleEnemy, 10))
   return self
end

function CrowdSchedule:push_crowd(crowd)
   self.crowds[#self.crowds + 1] = crowd
end

function CrowdSchedule:pop_crowd()
   local crowd = table.remove(self.crowds, 1)
   return crowd
end

function CrowdSchedule:try_new_enemy()
   local current_liberation = love.timer.getTime()
   local delta_t = current_liberation - self.last_liberation
   local delta_t_crowd = (self.current_crowd_start and
			  current_liberation - self.current_crowd_start)

   if self.initial_delay then
      if delta_t >= self.initial_delay then
	 self.initial_delay = nil
      else
	 return nil
      end
   end

   if (not self.current_crowd or
       delta_t_crowd and delta_t_crowd >= self.current_crowd.duration) then
      local crowd = self:pop_crowd()
      if not crowd then return nil end
      self.current_crowd = crowd
      self.countdown = self.current_crowd.amount
      self.current_crowd_start = current_liberation
   end

   if delta_t < self.interval or self.countdown <= 0 then
      return nil
   end

   self.last_liberation = current_liberation
   self.countdown = self.countdown - 1
   return SimpleEnemy
end

return CrowdSchedule
