local composer = require( 'composer' )
local physics = require( 'physics' )
local mazeGenerator = require ( 'src.mazeGenerator' )

local scene = composer.newScene()

print( '[+] Game: START' )


local centerX = display.contentCenterX
local centerY = display.contentCenterY
local displayWidth  = display.contentWidth
local displayHeight = display.contentHeight

local groupBackground
local groupForeground
local groupWalls
local groupUI

local background
local touchOverlay

local marble
local wallWidth = 10



local function addSurroundingWalls()

    -- North
    local wallNorth = display.newRect( groupWalls, centerX, 0 - wallWidth/2, displayWidth, wallWidth )   
    -- East
    local wallEast  = display.newRect( groupWalls, displayWidth + wallWidth/2, centerY, wallWidth, displayHeight) 
    -- South
    local wallSouth = display.newRect( groupWalls, centerX, displayHeight + wallWidth/2, displayWidth, wallWidth ) 
    -- West
    local wallWest  = display.newRect( groupWalls, 0 - wallWidth/2, centerY, wallWidth, displayHeight )

end

local function addPhysicsBodies()

    local physicsWalls  = { density = 1, friction = 0.5, bounce = 0.2, radius = marble.radius }
    local physicsMarble = { density = 1, friction = 0.5, bounce = 0.2 }

    for i = 1, groupWalls.numChildren do
        physics.addBody( groupWalls[i], 'static', physicsWalls )
    end

    physics.addBody( marble, 'dynamic', physicsMarble )

end

local function onAccelerate( event )

    local multiplyer = 0.1
    local newGravityX = event.xGravity *  multiplyer
    local newGravityY = event.yGravity * -multiplyer

    marble:applyLinearImpulse(newGravityX, newGravityY, marble.x, marble.y)
end

local function onPressShowPauseOverlay( event )
    
    composer.showOverlay( 'scene.pause', {
        effect = "fade",
        time = 250,
        isModal = true
    } )

    return true
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
function scene:resumeGame()
    print("Resume")
    return true
end

-- create()
function scene:create( event )

    print( '[+] Game: CREATE' )

    composer.removeScene( 'scene.menu' )

    local sceneGroup = self.view
    

    groupBackground = display.newGroup()
    groupForeground = display.newGroup()
    groupWalls = display.newGroup()
    groupUI = display.newGroup()

    sceneGroup:insert(groupBackground)
    sceneGroup:insert(groupForeground)
    --groupForeground:insert(groupWalls)
    sceneGroup:insert(groupUI)

    background = display.newRect( groupBackground, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( 0, 0, 0 )
    touchOverlay = display.newRect( groupUI, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    touchOverlay.alpha = 0.0
    touchOverlay.isHitTestable = true
    touchOverlay:addEventListener( 'tap', onPressShowPauseOverlay )

    marble = display.newCircle( groupForeground, centerX+41, centerY+20, 15)
    marble:setFillColor( 0.5, 0.5, 1 )
   
    addSurroundingWalls()

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
        physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
        physics.setGravity( 0, 0 ) 

        addPhysicsBodies()

       Runtime:addEventListener ('accelerometer', onAccelerate);

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