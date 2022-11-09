local composer = require( 'composer' )
local widget = require( 'widget' )
local sfx = require( 'src.sounds' )
local global = require( 'src.globalData')
 
local scene = composer.newScene()

print( '[+] Menu: START' )

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local displayWidth  = display.contentWidth
local displayHeight = display.contentHeight

local groupUI
 
local background
local btnStartGame
local btnSoundOn
local btnSoundOff
local sfxBackground


local function onPressStartGame( event )

    sfxBackground.fadeOut()
    composer.gotoScene( 'scene.game', { effect = 'crossFade', time = 500 } )

    return true
end


local function onPressSoundOn( event )

    if event.target.isVisible then
        sfxBackground.stop()
        global.soundOn = false
        
        event.target.isVisible = false
        btnSoundOff.isVisible = true
    end

    return true
end


local function onPressSoundOff( event )

    if event.target.isVisible then
        sfxBackground.start()
        global.soundOn = true

        event.target.isVisible = false
        btnSoundOn.isVisible = true
    end

    return true
end

-- create()
function scene:create( event )
    
    print( '[+] Menu: CREATE' )

    local sceneGroup = self.view
 
    groupUI = display.newGroup()
    sceneGroup:insert(groupUI)

    background = display.newRect( groupUI, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( unpack(global.colorBackground) )

    local title = display.newImage( groupUI, 'src/assets/images/game-title.png', display.contentCenterX, displayHeight * 0.33)
    title:scale(0.3, 0.3)

    btnStartGame = display.newImage( groupUI, 'src/assets/icons/play.png', display.contentCenterX, displayHeight * 0.66)
    btnStartGame:scale(0.5, 0.5)

    btnSoundOn = display.newImage( groupUI, 'src/assets/icons/sound-on.png', displayWidth-75, displayHeight-75 )
    btnSoundOn:scale(0.5, 0.5)
    btnSoundOn.anchorX = 0
    btnSoundOn.anchorY = 0
    btnSoundOn.enabled = true

    btnSoundOff = display.newImage( groupUI, 'src/assets/icons/sound-off.png', displayWidth-75, displayHeight-75 )
    btnSoundOff:scale(0.5, 0.5)
    btnSoundOff.anchorX = 0
    btnSoundOff.anchorY = 0
    btnSoundOff.enabled = true
    btnSoundOff.isVisible = false

    btnStartGame:addEventListener( 'tap', onPressStartGame )
    btnSoundOn:addEventListener( 'tap', onPressSoundOn )
    btnSoundOff:addEventListener( 'tap', onPressSoundOff )

    sfxBackground = sfx.sfxBackgroundMenu()

end
 
 
-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then

        print( '[+] Menu: SHOW WILL' )
 
    elseif ( phase == "did" ) then

        print( '[+] Menu: SHOW DID' )
        sfxBackground.start()

    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        
        print( '[+] Menu: HIDE WILL' )

    elseif ( phase == "did" ) then
        
        print( '[+] Menu: HIDE DID' )

    end
end
 
 
-- destroy()
function scene:destroy( event )
    
    print( '[+] Menu: DESTROY' )

    local sceneGroup = self.view
 
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