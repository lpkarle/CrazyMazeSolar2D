------------------------------------------------------------------------
-- Randmoized depth-first search 
-- Pseudocode: https://en.wikipedia.org/wiki/Maze_generation_algorithm (visited: 2022-10-24)
------------------------------------------------------------------------

local algoritms = require( 'src.algorithms' )
require('src.maze.Cell')

local displayWidth = display.contentWidth
local displayHeight = display.contentHeight


local cellGroup = display.newGroup()


local M = {}
 
local mazeWidth
local mazeHeight
local mazeArray
local visitedCount
local visitedStack

local currentCell

local cellWidth


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
            table.insert( mazeArray, Cell:new(x, y, displayWidth/mazeWidth, cellGroup) )
        end
    end


    for i = 1, #mazeArray do
        print(i..". ("..mazeArray[i].x..","..mazeArray[i].y..") ")

    end


    currentCell = mazeArray[ mazeWidth*mazeHeight-1 ]
    visitedStack.push(currentCell)
    currentCell.visited = true
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

    if northIndex ~= -1 and not mazeArray[ northIndex ].visited then
        table.insert( neighbors, mazeArray[ northIndex ] )

        print('north: ('..mazeArray[ northIndex ].x..','..mazeArray[ northIndex ].y..')')
    end

    if eastIndex ~= -1 and not mazeArray[ eastIndex ].visited then
        table.insert( neighbors, mazeArray[ eastIndex ] )

        print('east:  ('..mazeArray[ eastIndex ].x..','..mazeArray[ eastIndex ].y..')')
    end

    if southIndex ~= -1 and not mazeArray[ southIndex ].visited then
        table.insert( neighbors, mazeArray[ southIndex ] )

        print('south: ('..mazeArray[ southIndex ].x..','..mazeArray[ southIndex ].y..')')
    end

    if westIndex ~= -1 and not mazeArray[ westIndex ].visited then
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
        
        curCell.wallWest = false
        nxtCell.wallEast = false

    end

    -- Remove western wall
    if x == -1 then
        print("Remove: western wall")

        curCell.wallEast = false
        nxtCell.wallWest = false

    end

    -- Remove northern wall
    if y == 1 then
        print("Remove: northern wall")
        curCell.wallNorth = false
        nxtCell.wallSouth = false
    end

    -- Remove southern wall
    if y == -1 then
        print("Remove: southern wall")
        curCell.wallSouth = false
        nxtCell.wallNorth = false
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
            currentCell.visited = true
    
            visitedCount = visitedCount + 1
    
            visitedStack.push(currentCell)
    
        else
            currentCell = visitedStack.pop()
        end
    end

end

function M.printToScreen() 


    for i = 1, #mazeArray do

        mazeArray[ i ]:draw()

    end

    

end

 
return M

