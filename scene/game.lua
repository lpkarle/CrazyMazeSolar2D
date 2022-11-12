local composer = require( 'composer' )
local physics = require( 'physics' )
local global = require( 'src.globalData' )
local marble = require( 'scene.game.marble' )
require ( 'src.maze.Maze' )

local scene = composer.newScene()

print( '[+] Game: START' )

display.setDefault( 'anchorX', 0 )
display.setDefault( 'anchorY', 0 )

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local displayWidth  = display.contentWidth
local displayHeight = display.contentHeight

local groupBackground
local groupForeground
local groupSurroundingWalls
local groupMazeWalls
local groupUI

local background
local touchOverlay

local startArea
local goalArea
local wallWidth = 4
local maze

local startColumnAmount = 5
local levelUpStep = 2
local currentCols = startColumnAmount

local mazeTimer
local textTimer
local sec = 0
local min = 0

local function updateTimer( event )
    sec = sec + 1

    if (sec >= 60) then
        min = min + 1 
        sec = 0
    end

    local strSec = sec < 10 and '0'..sec or sec
    local strMin = min < 10 and '0'..min or min

    textTimer.text = strMin .. ':' .. strSec
end
          

local function drawSurroundingWalls()

    -- North
    display.newLine( groupSurroundingWalls, 0, 0, displayWidth, 0 )  

    -- East
    display.newLine( groupSurroundingWalls, displayWidth, 0, displayWidth, displayHeight) 

    -- South
    display.newLine( groupSurroundingWalls, 0, displayHeight, displayWidth, displayHeight) 

    -- West
    display.newLine( groupSurroundingWalls,0, 0, 0, displayHeight) 

    for i = 1, groupSurroundingWalls.numChildren do
        groupSurroundingWalls[i].name = 'wall'
        groupSurroundingWalls[i].isVisible = false
    end
end

local function calcCellWidth()
    return ( displayWidth - wallWidth ) / currentCols
end

local function calcRowAmount()

    local rowAmount = math.floor( displayHeight / calcCellWidth() ) - 1
    local yOffset = ( displayHeight - calcCellWidth() * rowAmount ) / 2
    while ( yOffset < displayHeight * 0.09 ) do
        rowAmount = rowAmount - 1
        yOffset = ( displayHeight - calcCellWidth() * rowAmount ) / 2
    end

    return rowAmount
end

local function calcOffsetX()
    return ( displayWidth  - calcCellWidth() * currentCols ) / 2
end

local function calcOffsetY()
    return ( displayHeight - calcCellWidth() * calcRowAmount() ) / 2
end


local function drawWalls()

    local cellWidth = calcCellWidth()
    local xOffset  = calcOffsetX()
    local yOffset  = calcOffsetY()

    for i = 1, #maze.mazeArray do

        local cell = maze.mazeArray[ i ]

        print("Draw (" .. cell.x .. "," .. cell.y .. ")")

        local x = cell.x * cellWidth - cellWidth + xOffset
        local y = cell.y * cellWidth - cellWidth + yOffset

        local wOffset = wallWidth / 2

        print(x .. "," .. y)

        if cell.wallNorth then
            print("NORTH")
            local wallNorth = display.newRect(groupMazeWalls, x - wOffset, y-wOffset, cellWidth + wallWidth, wallWidth)
            wallNorth:setFillColor( unpack(global.colorWalls) )
        end

        if cell.wallEast then
            print("EAST")
            local wallEast = display.newRect(groupMazeWalls, x + cellWidth - wOffset, y - wOffset, wallWidth, cellWidth + wallWidth)
            wallEast:setFillColor( unpack(global.colorWalls) )
        end

        if cell.wallSouth then
            print("SOUTH")
            local wallSouth = display.newRect(groupMazeWalls, x - wOffset, y + cellWidth - wOffset, cellWidth + wallWidth, wallWidth)
            wallSouth:setFillColor( unpack(global.colorWalls) )
        end

        if cell.wallWest then
            print("WEST")
            local wallWeat = display.newRect(groupMazeWalls, x - wOffset, y - wOffset, wallWidth, cellWidth + wallWidth)
            wallWeat:setFillColor( unpack(global.colorWalls) )
        end
    end
    
end

local function addPhysicsBodies()

    local physicsWalls  = { density = 1, friction = 1, bounce = 0.2 }

    -- Surrounding walls
    for i = 1, groupSurroundingWalls.numChildren do
        physics.addBody( groupSurroundingWalls[i], 'static', physicsWalls )
    end

    -- Maze walls
    for i = 1, groupMazeWalls.numChildren do
        groupMazeWalls[i].name = 'wall'
        physics.addBody( groupMazeWalls[i], 'static', physicsWalls )
    end

end


local function marbleInStartArea()
    
    local hits = physics.queryRegion( 0, displayHeight - calcOffsetY() + 15, displayWidth, displayHeight )
 
    if ( hits ) then
        
        -- Remove detected walls
        for i,v in ipairs( hits ) do
            if v.name == 'marble' then
                return true
            end
        end        
    end

    return false
end


local function marbleInGoalArea()
    
    local hits = physics.queryRegion( 0, 0, displayWidth, calcOffsetY() - 15 )
 
    if ( hits ) then
        
        -- Remove detected walls
        for i,v in ipairs( hits ) do
            if v.name == 'marble' then
                return true
            end
        end        
    end

    return false
end


local function nextLevel()

    -- new maze
    print("maze size: "..#maze.mazeArray)
    print("maze group size: "..groupMazeWalls.numChildren)

    while groupMazeWalls.numChildren > 0 do
        local wall = groupMazeWalls[1]
        if wall then
            wall:removeSelf()
        end
    end

    if currentCols == 15 then
        currentCols = 5
    else
        currentCols = currentCols + levelUpStep
    end

    maze = Maze:new( calcRowAmount(), currentCols )
    maze:generate()

    drawWalls()
    addPhysicsBodies()

    local offsetY = calcOffsetY()

    --hit area
    startArea.y = displayHeight - offsetY + wallWidth / 2
    startArea.height = offsetY
    goalArea.y = 0
    goalArea.height = offsetY - wallWidth / 2

    -- reset marble
    marble.resetPosition(centerX, displayHeight - offsetY / 2)

end


local function setupGame()

    physics.start()
    physics.setDrawMode( 'normal' )
    physics.setGravity( 0, 0 )

    maze = Maze:new( calcRowAmount(), startColumnAmount )
    maze:generate()

    local yOffset = calcOffsetY()
    
    startArea = display.newRect( groupForeground, 0, displayHeight - yOffset + wallWidth / 2, displayWidth, yOffset - wallWidth / 2)
    startArea:setFillColor( unpack(global.colorStartArea) )
    startArea.isVisible = true

    goalArea = display.newRect( groupForeground, 0, 0, displayWidth, yOffset - wallWidth / 2 )
    goalArea:setFillColor( unpack(global.colorGoalArea) )
    goalArea.isVisible = true

    marble = marble.new(groupForeground, centerX, displayHeight - yOffset / 2)

    drawSurroundingWalls()
    drawWalls()

    textTimer = display.newText( global.textOptionsTimer )
    textTimer.x = displayWidth - textTimer.width - 36
    textTimer.y = 10
end

local function onPressShowPauseOverlay( event )

    -- Stop marble movement
    physics.pause()

    composer.showOverlay( 'scene.pause', {
        effect = 'fade',
        time = 250,
        isModal = true
    } )

    return true
end

-- Game Loop
local function enterFrame( event )

    if ( not marbleInStartArea() and mazeTimer == nil) then
        mazeTimer = timer.performWithDelay( 1000, updateTimer, -1 )
    end

    if marbleInGoalArea() then
        timer.cancel(  mazeTimer )
        mazeTimer = nil
        sec = 0
        min = 0
        textTimer.text = '00:00'

        composer.gotoScene( 'scene.cutscene' )
        nextLevel()
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
function scene:resumeGame()
    print("Resume")
    physics.start()

    return true
end

-- create()
function scene:create( event )

    print( '[+] Game: CREATE' )

    local sceneGroup = self.view

    composer.removeScene( 'scene.menu' )

    groupBackground = display.newGroup()
    groupSurroundingWalls = display.newGroup()
    groupMazeWalls = display.newGroup()
    groupForeground = display.newGroup()
    groupUI = display.newGroup()

    sceneGroup:insert(groupBackground)
    groupForeground:insert(groupSurroundingWalls)
    groupForeground:insert(groupMazeWalls)
    sceneGroup:insert(groupForeground)
    sceneGroup:insert(groupUI)

    background = display.newRect( groupBackground, 0, 0, display.contentWidth, display.contentHeight )
    background:setFillColor( unpack(global.colorBackground) )
    touchOverlay = display.newRect( groupUI, 0, 0, display.contentWidth, display.contentHeight )
    touchOverlay.alpha = 0.0
    touchOverlay.isHitTestable = true
    touchOverlay:addEventListener( 'tap', onPressShowPauseOverlay )

    setupGame()
end
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then

        print( '[+] Game: SHOW WILL' )

        Runtime:addEventListener("enterFrame", enterFrame)

        addPhysicsBodies()
 
    elseif ( phase == "did" ) then

        print( '[+] Game: SHOW DID' )

        
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
        print( '[+] Game: HIDE WILL' )

        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        
        print( '[+] Game: HIDE DID' )

        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    print( '[+] Game: DESTROY' )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene