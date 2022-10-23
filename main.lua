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
end


-- Set up the accelerometer to provide measurements 60 times per second.
-- Note that this matches the frame rate set in the "config.lua" file.
system.setAccelerometerInterval( 60 )



-- display center points
centerX = display.contentCenterX
centerY = display.contentCenterY


-- Create a bubble
local bubble = display.newCircle(centerX, centerY, 20)
bubble:setFillColor( 0.5, 0.5, 1 )


-- Called for Accelerator events
--
-- Update the display with new values
-- If shake detected, make sound and display message for a few seconds
--
local function onAccelerate( event )

	-- Move the bubble based on the accelerator values
	bubble.x = centerX + (centerX * event.xGravity)
	bubble.y = centerY + (centerY * event.yGravity * -1)
end


-- Runtime listeners
Runtime:addEventListener ('accelerometer', onAccelerate);
