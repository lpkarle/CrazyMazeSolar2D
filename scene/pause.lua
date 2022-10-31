local composer = require( 'composer' )
 
local scene = composer.newScene()

print( '[+] PAUSE: START' )

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local displayWidth  = display.contentWidth
local displayHeight = display.contentHeight

local groupUI
 
local background
local btnResumeGame

 
local function onPressHidePauseOverlay( event )

    composer.hideOverlay( 'scene.pause', 400) 

    return true
end

-- create()
function scene:create( event )
    
    print( '[+] PAUSE: CREATE' )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
    groupUI = display.newGroup()
    sceneGroup:insert(groupUI)

    background = display.newRect( groupUI, centerX, centerY, displayWidth, displayHeight )

    btnResumeGame = display.newRect(groupUI, centerX, centerY, 200, 50)
    btnResumeGame:setFillColor(0,1,0)
    btnResumeGame:addEventListener( 'tap', onPressHidePauseOverlay)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
        print( '[+] PAUSE: SHOW WILL' )

        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        
        print( '[+] PAUSE: SHOW DID' )

        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent
 
    if ( phase == "will" ) then
        
        print( '[+] PAUSE: HIDE WILL' )

        parent:resumeGame()

        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        
        print( '[+] PAUSE: HIDE DID' )

        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
    
    print( '[+] PAUSE: DESTROY' )

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