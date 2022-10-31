local composer = require( "composer" )

local scene = composer.newScene()

print( '[+] Game: START' )


local centerX = display.contentCenterX
local centerY = display.contentCenterY

local background
local touchOverlay


local function onPressShowPauseOverlay( event )
    
    composer.showOverlay( 'scene.pause', {
        effect = "fade",
        time = 250,
        isModal = true
    } )

    return true
end


function scene:resumeGame()
    print("Resume")
    return true
end

-- create()
function scene:create( event )

    print( '[+] Game: CREATE' )

    composer.removeScene( 'scene.menu' )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
    background = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( 0, 0, 0 )

    touchOverlay = display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    touchOverlay.alpha = 0.0
    touchOverlay.isHitTestable = true
    touchOverlay:addEventListener( 'tap', onPressShowPauseOverlay )

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