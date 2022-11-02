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




--[[Cell = {}
Cell.__index = Cell

function Cell:new( x, y, width, parent )
    local obj = setmetatable({}, Cell)
  
    obj.x = x
    obj.y = y
    obj.width   = width
    obj.parent  = parent
    obj.visited = false
    obj.wallNorth = true
    obj.wallEast  = true
    obj.wallSouth = true
    obj.wallWest  = true
  
    return obj
end


-- draw should not be in here
function Cell:draw()

    print("Draw (" .. self.x .. "," .. self.y .. ")")

    local x = self.x * self.width - self.width
    local y = self.y * self.width - self.width

    print(x .. "," .. y)


    if self.wallNorth then
        print("NORTH")
        local lineNorth = display.newLine(self.parent, x, y, x + self.width, y)
        lineNorth.strokeWidth = 5
        physics.addBody(lineNorth, 'static', {
            desity = 3,
            friction = 0.5,
            bounce = 0.3
        })
    end

    if self.wallEast then
        print("EAST")

        local lineEast = display.newLine(self.parent, x + self.width, y, x + self.width, y + self.width)
        lineEast.strokeWidth = 5
        physics.addBody(lineEast, 'static', {
            desity = 3,
            friction = 0.5,
            bounce = 0.3
        })
    end

    if self.wallSouth then
        print("SOUTH")

        local lineSouth = display.newLine(self.parent, x + self.width, y + self.width, x, y + self.width)
        physics.addBody(lineSouth, 'static', {
            desity = 3,
            friction = 0.5,
            bounce = 0.3
        })
    end

    if self.wallWest then
        print("WEST")

        local lineWest = display.newLine(self.parent, x, y + self.width, x, y)
        lineWest.strokeWidth = 5
        physics.addBody(lineWest, 'static', {
            desity = 3,
            friction = 0.5,
            bounce = 0.3
        })
    end
end
]]