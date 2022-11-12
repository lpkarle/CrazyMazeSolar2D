local composer = require( 'composer' )
local global = require( 'src.globalData' )

local scene = composer.newScene()

print( '[+] PAUSE: START' )

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local displayWidth  = display.contentWidth
local displayHeight = display.contentHeight

local groupUI
 
local background
local btnResumeGame
local btnResumeGame

local btnSoundOn
local btnSoundOff

 
local function onPressHidePauseOverlay( event )

    composer.hideOverlay( 'scene.pause', 400) 

    return true
end


local function onPressSoundOn( event )

    if event.target.isVisible then
        global.soundOn = false
        
        event.target.isVisible = false
        btnSoundOff.isVisible = true
    end

    return true
end


local function onPressSoundOff( event )

    if event.target.isVisible then
        global.soundOn = true

        event.target.isVisible = false
        btnSoundOn.isVisible = true
    end

    return true
end

-- create()
function scene:create( event )
    
    print( '[+] PAUSE: CREATE' )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
    groupUI = display.newGroup()
    sceneGroup:insert(groupUI)

    background = display.newRect( groupUI, 0, 0, displayWidth, displayHeight )
    background:setFillColor( unpack(global.colorBackground) )

    btnResumeGame = display.newImage( groupUI, 'src/assets/icons/play.png', centerX - 50, centerY)
    btnResumeGame:scale(0.5, 0.5)
    btnResumeGame:addEventListener( 'tap', onPressHidePauseOverlay )

    btnSoundOn = display.newImage( groupUI, 'src/assets/icons/sound-on.png', displayWidth-75, displayHeight-75 )
    btnSoundOn:scale(0.5, 0.5)
    btnSoundOn.anchorX = 0
    btnSoundOn.anchorY = 0
    btnSoundOn.enabled = global.soundOn
    btnSoundOn:addEventListener( 'tap', onPressSoundOn )

    btnSoundOff = display.newImage( groupUI, 'src/assets/icons/sound-off.png', displayWidth-75, displayHeight-75 )
    btnSoundOff:scale(0.5, 0.5)
    btnSoundOff.anchorX = 0
    btnSoundOff.anchorY = 0
    btnSoundOff.enabled = true
    btnSoundOff.isVisible = not global.soundOn
    btnSoundOff:addEventListener( 'tap', onPressSoundOff )

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