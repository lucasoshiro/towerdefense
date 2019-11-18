#!/usr/bin/env lua

local CurrentBullets = {}
CurrentBullets.__index = CurrentBullets

function CurrentBullets.new()
   local self = setmetatable({}, CurrentBullets)
   return self
end

return CurrentBullets
