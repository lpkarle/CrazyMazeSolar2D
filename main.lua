-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( 'composer' )

display.setStatusBar( display.HiddenStatusBar )

-- Removes bottom bar on Android 
if ( system.getInfo( 'androidApiLevel' ) and system.getInfo( 'androidApiLevel' ) < 19 ) then
	native.setProperty( 'androidSystemUiVisibility', 'lowProfile' )
else
	native.setProperty( 'androidSystemUiVisibility', 'immersiveSticky' ) 
end

-- Check if accelerator is supported on this platform
if not system.hasEventSource( 'accelerometer' ) then
	msg = display.newText( 'Accelerometer not supported on this device', display.contentCenterX, 55, native.systemFontBold, 13 )
	msg:setFillColor( 1,1,0 )
else
    system.setAccelerometerInterval( 60 )
end

-- Start Menu
composer.gotoScene( 'scene.menu', { effect = 'fade', time = 500 } )