local global = require( 'src.globalData' )
local M = {}

function M.new( parent, x, y )

    local marbleRadius  = 8
    local marblePhysics = { density = 1, friction = 1, bounce = 0.2, radius = marbleRadius }

    local marble = display.newCircle(parent, x, y, marbleRadius)
    marble.anchorX = 0.5
    marble.anchorY = 0.5
    marble:setFillColor( unpack(global.colorMarble) )
    marble.name = 'marble'

    marble.resetPosition = function(x, y)

        marble:setLinearVelocity( 0, 0 )

        marble.x = x
        marble.y = y

    end

    physics.addBody( marble, 'dynamic', marblePhysics )

    local function onAccelerate( event )

        local multiplyer = 0.1
        local newGravityX = event.xGravity *  multiplyer
        local newGravityY = event.yGravity * -multiplyer

    
        marble:applyLinearImpulse( newGravityX, newGravityY, marble.x, marble.y )
    end

    Runtime:addEventListener ( 'accelerometer', onAccelerate )

    return marble
end

return M
