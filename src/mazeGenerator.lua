------------------------------------------------------------------------
-- Randmoized depth-first search 
-- Pseudocode: https://en.wikipedia.org/wiki/Maze_generation_algorithm (visited: 2022-10-24)
------------------------------------------------------------------------

local algoritms = require( 'src.algorithms' )

local displayWidth = display.contentWidth
local displayHeight = display.contentHeight


local cellGroup = display.newGroup()
cellGroup.x = 10


local M = {}
 
local mazeWidth
local mazeHeight
local mazeArray
local visitedCount
local visitedStack

local currentCell

local cellWidth

local CellStates = {
    VISITED = 6
}

local function Cell( x, y, width ) 

    local cell = {
        x = x,
        y = y,
        width= width,
        walls = {
            NORTH = true,
            EAST  = true,
            SOUTH = true,
            WEST  = true
        } ,
        state = CellStates.EMPTY
    }

    cell.removeWall = function(wall)
        cell.walls[wall] = false
    end

    cell.draw = function()

        local x = cell.x * cell.width - cell.width
        local y = cell.y * cell.width - cell.width

        if cell.walls['NORTH'] then
            local lineNorth = display.newLine( cellGroup, x, y, x + cell.width, y )
            lineNorth:setStrokeColor(1,.5,1)
            lineNorth.strokeWidth = 5
            physics.addBody( lineNorth, 'static', { desity=3, friction=0.5, bounce=0.3 })
        end

        if cell.walls['EAST'] then
            local lineEast = display.newLine( cellGroup, x + cell.width, y, x + cell.width, y + cell.width )
            lineEast:setStrokeColor(1,0,0)
            lineEast.strokeWidth = 5
            physics.addBody( lineEast, 'static', { desity=3, friction=0.5, bounce=0.3 })
        end

        if cell.walls['SOUTH'] then
            local lineSouth = display.newLine( cellGroup, x + cell.width, y + cell.width, x, y + cell.width )
            lineSouth:setStrokeColor(0,1,0)
            lineSouth.strokeWidth = 5
             physics.addBody( lineSouth, 'static', { desity=3, friction=0.5, bounce=0.3 })
        end

        if cell.walls['WEST'] then
            local lineWest = display.newLine( cellGroup, x, y + cell.width, x, y )
            lineWest:setStrokeColor(0,0,1)
            lineWest.strokeWidth = 5
             physics.addBody( lineWest, 'static', { desity=3, friction=0.5, bounce=0.3 })
        end

        if cell.state == CellStates.VISITED then
            display.newRect( cellGroup,
                x + cell.width/2,
                y + cell.width/2, 
                cell.width/6, 
                cell.width/6 
            )
        end

    end

    return cell
end


-- Initialize the maze
--
-- @param width
-- @param height
-- @param startX
-- @param startY
function M.init( width, height, startX, startY )

    mazeWidth = width
    mazeHeight = height
    mazeArray = { n = mazeWidth * mazeHeight }
    visitedCount = 0
    visitedStack = algoritms.stack()

    -- init mazeArray
    for y = 1, mazeHeight  do
        for x = 1, mazeWidth  do
            table.insert( mazeArray, Cell(x, y, displayWidth / mazeWidth) )
        end
    end


    currentCell = mazeArray[ mazeWidth*mazeHeight-1 ]
    visitedStack.push(currentCell)
    currentCell.state = CellStates.VISITED
    visitedCount = visitedCount + 1

end

-- returns -1 if its not inside the grid
local function getCellIndex( x, y ) 

    print('getcellIndex: ('..x..','..y..')  width:'..mazeWidth.."  height:"..mazeHeight)

    if x <= 0 or x > mazeWidth or y <= 0 or y > mazeHeight then
        return -1
    end

    return x + ( y - 1 ) * mazeWidth
end

local function checkNeighbors(cell)
        
    local neighbors = {}

    local northIndex = getCellIndex(cell.x    , cell.y - 1) 
    local eastIndex  = getCellIndex(cell.x + 1, cell.y    ) 
    local southIndex = getCellIndex(cell.x    , cell.y + 1) 
    local westIndex  = getCellIndex(cell.x - 1, cell.y    ) 

    print('cell: ' .. getCellIndex(cell.x, cell.y))
    print('n: ' .. northIndex)
    print('e: ' .. eastIndex)
    print('s: ' .. southIndex)
    print('w: ' .. westIndex)

    if northIndex ~= -1 and mazeArray[ northIndex ].state == CellStates.EMPTY then
        table.insert( neighbors, mazeArray[ northIndex ] )

        print('north: ('..mazeArray[ northIndex ].x..','..mazeArray[ northIndex ].y..')')
    end

    if eastIndex ~= -1 and mazeArray[ eastIndex ].state == CellStates.EMPTY then
        table.insert( neighbors, mazeArray[ eastIndex ] )

        print('east:  ('..mazeArray[ eastIndex ].x..','..mazeArray[ eastIndex ].y..')')
    end

    if southIndex ~= -1 and mazeArray[ southIndex ].state == CellStates.EMPTY then
        table.insert( neighbors, mazeArray[ southIndex ] )

        print('south: ('..mazeArray[ southIndex ].x..','..mazeArray[ southIndex ].y..')')
    end

    if westIndex ~= -1 and mazeArray[ westIndex ].state == CellStates.EMPTY then
        table.insert( neighbors, mazeArray[ westIndex ] )
        
        print('west:  ('..mazeArray[ westIndex ].x..','..mazeArray[ westIndex ].y..')')
    end

    return neighbors
end 


local function removeWalls(curCell, nxtCell)
        
    local x = curCell.x - nxtCell.x
    print('\nx: ' .. x)

    local y = curCell.y - nxtCell.y
    print('y: ' .. y)


    -- Remove eastern wall
    if x == 1 then
        print("Remove: eastern wall")
        
        curCell.removeWall('WEST')
        nxtCell.removeWall('EAST')

    end

    -- Remove western wall
    if x == -1 then
        print("Remove: western wall")

        curCell.removeWall('EAST')
        nxtCell.removeWall('WEST')

    end

    -- Remove northern wall
    if y == 1 then
        print("Remove: northern wall")
        curCell.removeWall('NORTH')
        nxtCell.removeWall('SOUTH')
    end

    -- Remove southern wall
    if y == -1 then
        print("Remove: southern wall")
        curCell.removeWall('SOUTH')
        nxtCell.removeWall('NORTH')
    end

end

function M.generate()
    print("Start generate")


    print(visitedCount ..' / '..#mazeArray .. ' visited')

    

    while (visitedCount < #mazeArray) do 
    
        local neighbors = checkNeighbors(currentCell)

        if #neighbors > 0 then
    
            -- choose random
            local nextIndex = math.random(1, #neighbors)
    
            print('cur: ('..currentCell.x..','..currentCell.y..')')
            print('nxt: ('..neighbors[nextIndex].x..','..neighbors[nextIndex].y..')')
    
            removeWalls(currentCell, neighbors[nextIndex])
    
            currentCell = neighbors[nextIndex]
            currentCell.state = CellStates.VISITED
    
            visitedCount = visitedCount + 1
    
            visitedStack.push(currentCell)
    
        else
            currentCell = visitedStack.pop()
        end
    end

end

function M.printToScreen() 


    local cellW = displayWidth / mazeWidth -1 

    for i = 1, #mazeArray do

        mazeArray[ i ].draw()

    end

    

end

 
return M

