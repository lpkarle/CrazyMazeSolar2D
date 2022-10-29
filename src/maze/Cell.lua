Cell = {}
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

    if self.visited then
        display.newRect(self.parent, x + self.width / 2, y + self.width / 2, self.width / 6, self.width / 6)
    end
end


--[[
    
    
x = 0,
    y = 0,
    width = 0,
    visited   = false,
    wallNorth = true,
    wallEast  = true,
    wallSouth = true,
    wallWest  = true,
    parent    = nil

Cell = {
    x = 0,
    y = 0,
    width = 0,
    visited = false,
    walls = {
        NORTH = true,
        EAST = true,
        SOUTH = true,
        WEST = true
    },
    parent = nil
}

function Cell:new()
    t = {
        x = 0,
        y = 0,
        width = 0,
        visited = false,
        walls = {
            NORTH = true,
            EAST = true,
            SOUTH = true,
            WEST = true
        },
        parent = nil
    }

    setmetatable(t, self)
    self.__index = self
    return t
end

function Cell:removeWall(wall)
    self.walls[wall] = false
end

-- draw should not be in here
function Cell:draw()

    print("Draw (" .. self.x .. "," .. self.y .. ") wallamount: " .. #self.walls)

    local x = self.x * self.width - self.width
    local y = self.y * self.width - self.width

    print(x .. "," .. y)

    print(self.walls)

    if self.walls['NORTH'] then
        print("NORTH")
        local lineNorth = display.newLine(self.parent, x, y, x + self.width, y)
        lineNorth.strokeWidth = 5
        physics.addBody(lineNorth, 'static', {
            desity = 3,
            friction = 0.5,
            bounce = 0.3
        })
    end

    if self.cell.walls['EAST'] then
        print("EAST")

        local lineEast = display.newLine(self.parent, x + self.width, y, x + self.width, y + self.width)
        lineEast:setStrokeColor(1, 0, 0)
        lineEast.strokeWidth = 5
        physics.addBody(lineEast, 'static', {
            desity = 3,
            friction = 0.5,
            bounce = 0.3
        })
    end

    if self.cell.walls['SOUTH'] then
        print("SOUTH")

        local lineSouth = display.newLine(self.parent, x + self.width, y + self.width, x, y + self.width)

        lineSouth:setStrokeColor(0, 1, 0)
        lineSouth.strokeWidth = 5
        physics.addBody(lineSouth, 'static', {
            desity = 3,
            friction = 0.5,
            bounce = 0.3
        })
    end

    if self.cell.walls['WEST'] then
        print("WEST")

        local lineWest = display.newLine(self.parent, x, y + self.width, x, y)

        lineWest:setStrokeColor(0, 0, 1)
        lineWest.strokeWidth = 5
        physics.addBody(lineWest, 'static', {
            desity = 3,
            friction = 0.5,
            bounce = 0.3
        })
    end

    if self.visited then
        display.newRect(self.parent, x + self.width / 2, y + self.width / 2, self.width / 6, self.width / 6)
    end
end
]]