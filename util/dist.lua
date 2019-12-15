#!/usr/bin/env lua

function dist(a, b)
   local delta_x = a[1] - b[1]
   local delta_y = a[2] - b[2]
   return math.sqrt(delta_x^2 + delta_y^2)
end

return dist

