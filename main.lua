-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( 'composer' )
local physics = require( 'physics' )

physics.start()
--physics.setScale( 60 ) -- a value that seems good for small objects (based on playtesting)
physics.setGravity( 0, 0 ) -- overhead view, therefore no gravity vector


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
physics.addBody( bubble, 'dynamic', { density=1.0, friction=0.3, bounce=0.2, radius=bubble.radius } )

local wall1 = display.newRect( centerX, centerY + 200, 500, 10)	-- bottom
physics.addBody( wall1, 'static', { desity=3.0, bounce=0.2 })

local wall2 = display.newRect( centerX, centerY - 200, 500, 10) -- top
physics.addBody( wall2, 'static', { desity=3, friction=0.5, bounce=0.3 })

local wall3 = display.newRect( centerX - 150, centerY, 10, 500) --left
physics.addBody( wall3, 'static', { desity=3, friction=0.5, bounce=0.3 })

local wall4 = display.newRect( centerX + 150, centerY, 10, 500) --right
physics.addBody( wall4, 'static', { desity=3, friction=0.5, bounce=0.3 })


-- Called for Accelerator events
--
-- Update the display with new values
-- If shake detected, make sound and display message for a few seconds
--
local text1 = display.newText({
	x=centerX,
	y=50,
	text=''
})
local text2 = display.newText({
	x=centerX,
	y=75,
	text=''
})

--local vec = display.newLine(centerX, centerY, centerX + 50, centerY + 50)

local function onAccelerate( event )

	text1.text = 'xGravity: ' .. event.xGravity
	text2.text = 'yGravity: ' .. event.yGravity

	local multiplyer = 2
	local newGravityX = event.xGravity * multiplyer
	local newGravityY = event.yGravity * -multiplyer

	-- update vector
	--vec = display.newLine(centerX, centerY, centerX + centerX * event.xGravity, centerY + centerY * event.yGravity * -1)

	----vec.x1 = centerX + centerX * event.xGravity
	--vec.y1 = centerY + centerY * event.yGravity 

	-- Move the bubble based on the accelerator values
	--bubble.x = bubble.x + (bubble.x * event.xGravity)
	--bubble.y = bubble.y + (bubble.x * event.yGravity * -1)

	--bubble:applyLinearImpulse(event.xGravity, event.yGravity * -1, bubble.x, bubble.y)
	--bubble:applyForce(newGravityX, newGravityY, bubble.x, bubble.y)
	bubble:applyLinearImpulse(newGravityX, newGravityY, bubble.x, bubble.y)
end 


-- Runtime listeners
Runtime:addEventListener ('accelerometer', onAccelerate);