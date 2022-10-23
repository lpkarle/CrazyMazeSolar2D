local composer = require( 'composer' )
local widget = require( 'widget' )
 
local scene = composer.newScene()

print( '[+] Menu: START' )

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local rec
local btnStartGame


local function onPressStartGame( event )
 
    if ( 'ended' == event.phase ) then
        print( "StartGame was pressed and released" )

       composer.gotoScene( 'scene.game', { time = 500, effect = 'slideUp' }  )
       composer.removeScene( 'scene.Menu' )
    end
end

-- create()
function scene:create( event )
    
    print( '[+] Menu: CREATE' )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
    rec = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )


end
 
 
-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then

        print( '[+] Menu: SHOW WILL' )

        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then

        print( '[+] Menu: SHOW DID' )

        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
        print( '[+] Menu: HIDE WILL' )

        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        
        print( '[+] Menu: HIDE DID' )

        

        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
    
    print( '[+] Menu: DESTROY' )

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