local composer = require( 'composer' )
local physics = require( 'physics' )
require ( 'src.maze.Maze' )

local scene = composer.newScene()

print( '[+] Game: START' )


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

local marble
local startArea
local goalArea
local wallWidth = 2
local maze

local levels = {
    {
        rows = 5, 
        cols = 3
    },
    {
        rows = 9, 
        cols = 5
    },
    {
        rows = 13, 
        cols = 7
    },
    {
        rows = 17, 
        cols = 9
    },
    {
        rows = 22, 
        cols = 11
    },
    {
        rows = 26, 
        cols = 13
    },
}
local currentLevel = 1
local cellWidth = displayWidth / levels[currentLevel].cols - wallWidth*2 
local xOffset = ( displayWidth  - cellWidth * levels[currentLevel].cols ) / 2
local yOffset = ( displayHeight - cellWidth * levels[currentLevel].rows ) / 2


local debugText = display.newText( {
    text='Debug',
    x=centerX,
    y=centerY
} )

local function drawSurroundingWalls()
    -- North
    display.newRect( groupSurroundingWalls, centerX, 0 - wallWidth/2, displayWidth, wallWidth )   
    -- East
    display.newRect( groupSurroundingWalls, displayWidth + wallWidth/2, centerY, wallWidth, displayHeight) 
    -- South
    display.newRect( groupSurroundingWalls, centerX, displayHeight + wallWidth/2, displayWidth, wallWidth ) 
    -- West
    display.newRect( groupSurroundingWalls, 0 - wallWidth/2, centerY, wallWidth, displayHeight )

    for i=1, groupSurroundingWalls.numChildren do
        groupSurroundingWalls[i].name = "wall"
    end
end

local function drawWalls()

    cellWidth = displayWidth / levels[currentLevel].cols - wallWidth*2 
    xOffset = ( displayWidth  - cellWidth * levels[currentLevel].cols ) / 2
    yOffset = ( displayHeight - cellWidth * levels[currentLevel].rows ) / 2

    for i = 1, #maze.mazeArray do

        local cell = maze.mazeArray[ i ]

        print("Draw (" .. cell.x .. "," .. cell.y .. ")")

        local x = cell.x * cellWidth - cellWidth + xOffset
        local y = cell.y * cellWidth - cellWidth + yOffset

        print(x .. "," .. y)

        if cell.wallNorth then
            print("NORTH")
            local wallNorth = display.newLine(groupMazeWalls, x, y, x + cellWidth, y)
            wallNorth.strokeWidth = wallWidth
        end

        if cell.wallEast then
            print("EAST")
            local wallEast = display.newLine(groupMazeWalls, x + cellWidth, y, x + cellWidth, y + cellWidth)
            wallEast.strokeWidth = wallWidth
        end

        if cell.wallSouth then
            print("SOUTH")
            local wallSouth = display.newLine(groupMazeWalls, x + cellWidth, y + cellWidth, x, y + cellWidth)
            wallSouth.strokeWidth = wallWidth
        end

        if cell.wallWest then
            print("WEST")
            local wallWest = display.newLine(groupMazeWalls, x, y + cellWidth, x, y)
            wallWest.strokeWidth = wallWidth
        end
    end

    

end

local function addPhysicsBodies()

    local physicsWalls  = { density = 1, friction = 1, bounce = 0.2 }
    local physicsMarble = { density = 1, friction = 1, bounce = 0.2, radius = marble.path.radius }

    -- Surrounding walls
    for i = 1, groupSurroundingWalls.numChildren do
        physics.addBody( groupSurroundingWalls[i], 'static', physicsWalls )
    end

    -- Maze walls
    for i = 1, groupMazeWalls.numChildren do
        physics.addBody( groupMazeWalls[i], 'static', physicsWalls )
    end

    physics.addBody( marble, 'dynamic', physicsMarble )

end


local function marbleInStartArea()
    
    local hits = physics.queryRegion( 0, displayHeight - yOffset + 15, displayWidth, displayHeight )
 
    if ( hits ) then
        
        -- Remove detected walls
        for i,v in ipairs( hits ) do
            if v.name == 'marble' then
                debugText.text = 'START'
                return true
            end
        end        
    end

    debugText.text = ''
    return false
end


local function marbleInGoalArea()
    
    local hits = physics.queryRegion( 0, 0, displayWidth, yOffset - 15 )
 
    if ( hits ) then
        
        -- Remove detected walls
        for i,v in ipairs( hits ) do
            if v.name == 'marble' then
                debugText.text = 'END'
                return true
            end
        end        
    end

    --debugText.text = ''
    return false
end

local function nextLevel()

     --hit area
    startArea.y = displayHeight - yOffset/2
    startArea.height = yOffset
    goalArea.y = yOffset / 2
    goalArea.height = yOffset

    -- new maze
    print("maze size: "..#maze.mazeArray)
    print("maze group size: "..groupMazeWalls.numChildren)

    while groupMazeWalls.numChildren > 0 do
        local wall = groupMazeWalls[1]
        if wall then
            wall:removeSelf()
        end
    end

    print("maze group size: "..groupMazeWalls.numChildren)

    if currentLevel == #levels then
        currentLevel = 1
    else
        currentLevel = currentLevel + 1
    end

    local level = levels[currentLevel]
    maze = Maze:new( level.rows, level.cols )
    maze:generate()

    drawWalls()
    addPhysicsBodies()

   

    -- reset marble
    marble.x = centerX
    marble.y = displayHeight - yOffset / 2

end

local function onAccelerate( event )

    local multiplyer = 0.3
    local newGravityX = event.xGravity *  multiplyer
    local newGravityY = event.yGravity * -multiplyer

    marble:applyLinearImpulse(newGravityX, newGravityY, marble.x, marble.y)

    marbleInStartArea()

    if marbleInGoalArea() then
        nextLevel()
    end
end

local function onPressShowPauseOverlay( event )

    nextLevel()

    --[[
    -- Stop marble movement
    physics.pause()

    composer.showOverlay( 'scene.pause', {
        effect = "fade",
        time = 250,
        isModal = true
    } )
    ]]
    return true
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

    composer.removeScene( 'scene.menu' )

    local sceneGroup = self.view
    

    groupBackground = display.newGroup()
    groupForeground = display.newGroup()
    groupSurroundingWalls = display.newGroup()
    groupMazeWalls = display.newGroup()
    groupUI = display.newGroup()

    sceneGroup:insert(groupBackground)
    sceneGroup:insert(groupForeground)
    groupForeground:insert(groupSurroundingWalls)
    groupForeground:insert(groupMazeWalls)
    sceneGroup:insert(groupUI)

    background = display.newRect( groupBackground, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( 0, 0, 0 )
    touchOverlay = display.newRect( groupUI, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    touchOverlay.alpha = 0.0
    touchOverlay.isHitTestable = true
    touchOverlay:addEventListener( 'tap', onPressShowPauseOverlay )
    
    startArea =display.newRect( groupForeground, centerX, displayHeight - yOffset / 2 + wallWidth / 2, displayWidth, yOffset )
    startArea:setFillColor(1,0,0)

    goalArea =display.newRect( groupForeground, centerX, yOffset / 2 - wallWidth / 2, displayWidth, yOffset )
    goalArea:setFillColor(0,0,1)

    marble = display.newCircle( groupForeground, centerX, displayHeight - yOffset / 2, 10)
    marble:setFillColor( 0.5, 0.5, 1 )
    marble.name = 'marble'

    local level = levels[currentLevel]
    maze = Maze:new( level.rows, level.cols )
    maze:generate()

    drawSurroundingWalls()
    drawWalls()

    system.setAccelerometerInterval( 60 )

end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then

        print( '[+] Game: SHOW WILL' )

        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then

        print( '[+] Game: SHOW DID' )

        -- Code here runs when the scene is entirely on screen
 
        physics.start()
        physics.setDrawMode( 'hybrid' )
        --physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
        physics.setGravity( 0, 0 ) 

        addPhysicsBodies()
        Runtime:addEventListener ('accelerometer', onAccelerate)

        

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