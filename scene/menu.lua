local composer = require( 'composer' )
local widget = require( 'widget' )
 
local scene = composer.newScene()

print( '[+] Menu: START' )

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local displayWidth  = display.contentWidth
local displayHeight = display.contentHeight

local groupUI
 
local background
local btnStartGame
local btnToggleSound

local function onPressStartGame( event )

    composer.gotoScene( 'scene.game', { effect = 'fromRight', time = 500 } )
    return true
    
end

local function onPressToggleVolume( event )

    if event.target.enabled then
        event.target:setFillColor( 0, 0, 0 )
        event.target.enabled = false
    else
        event.target:setFillColor( 1, 0, 0 )
        event.target.enabled = true
    end

    return true
end

-- create()
function scene:create( event )
    
    print( '[+] Menu: CREATE' )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
    groupUI = display.newGroup()
    sceneGroup:insert(groupUI)

    background = display.newRect( groupUI, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( 1, 1, 1 )

    local title = display.newText({
        parent = groupUI,
        text = 'Crazy Maze',
        x = centerX,
        y = 200,
        fontSize = 50,
        align = 'center'
    })
    title:setFillColor(0, 0, 0)

    btnStartGame = display.newRect( groupUI, centerX, centerY, 200, 50 )
    btnStartGame:setFillColor(0,0,1)

    btnToggleSound = display.newRect( groupUI, displayWidth - 75, displayHeight - 75, 50, 50 )
    btnToggleSound.enabled = true
    btnToggleSound:setFillColor( 1, 0, 0 )

    btnStartGame:addEventListener( 'tap', onPressStartGame )
    btnToggleSound:addEventListener( 'tap', onPressToggleVolume )

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