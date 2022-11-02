Cell = {}
Cell.__index = Cell

function Cell:new( x, y )
    
    local obj = setmetatable({}, Cell)
  
    obj.x = x
    obj.y = y
    obj.visited = false
    obj.wallNorth = true
    obj.wallEast  = true
    obj.wallSouth = true
    obj.wallWest  = true
  
    return obj
    
end
