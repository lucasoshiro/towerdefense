#!/usr/bin/env lua

local Tower        = require '../model/Tower'
local SimpleBullet = require '../model/SimpleBullet'

local SimpleTower = setmetatable({}, Tower)
SimpleTower.__index = SimpleTower

function SimpleTower.new(row, col)
   local self = setmetatable(Tower.new(row, col), SimpleTower)
   self.__index = SimpleTower
   self.identifier = 'S'
   self.bullet_type = SimpleBullet
   self.col = col
   self.row = row
   return self
end

function SimpleTower:shoot()
   return {
      SimpleBullet.new(self.col+1, self.row+1, 0),
      SimpleBullet.new(self.col+1, self.row+1, 0.25 * math.pi),
      SimpleBullet.new(self.col+1, self.row+1, 0.5  * math.pi),
      SimpleBullet.new(self.col+1, self.row+1, 0.75 * math.pi),
      SimpleBullet.new(self.col+1, self.row+1,        math.pi),
      SimpleBullet.new(self.col+1, self.row+1, 1.25 * math.pi),
      SimpleBullet.new(self.col+1, self.row+1, 1.5  * math.pi),
      SimpleBullet.new(self.col+1, self.row+1, 1.75 * math.pi),
      SimpleBullet.new(self.col+1, self.row+1, 2    * math.pi),
   }
end

return SimpleTower
