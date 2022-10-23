local composer = require( "composer" )
local widget = require( 'widget' )

local scene = composer.newScene()

print( '[+] Game: START' )


local centerX = display.contentCenterX
local centerY = display.contentCenterY

local rec
local btnBackToMenu


local function onPressBackToMenu( event )
 
    if ( 'ended' == event.phase ) then
        print( "BackToMenu was pressed and released" )

       composer.gotoScene( 'scene.menu', { time = 1000, effect = 'flip' } )
    end
end

-- create()
function scene:create( event )

    print( '[+] Game: CREATE' )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
    rec =display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    rec:setFillColor( 1, 0, 0 )

    btnStartGame = widget.newButton( {
        id = 'backToMenu',
        label = 'Back To Menu',
        x = centerX,
        y = centerY,
        onEvent = onPressBackToMenu
    } )
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

        composer.removeScene( 'scene.Game' )

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