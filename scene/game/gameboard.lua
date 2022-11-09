local M = {}

function M.new( parentSurroundingWall, parentMazeWall )

    local marbleRadius  = 8
    local marblePhysics = { density = 1, friction = 1, bounce = 0.2, radius = marbleRadius }

    local marble = display.newCircle(parent, x, y, marbleRadius)
    marble.anchorX = 0.5
    marble.anchorY = 0.5
    marble:setFillColor( 0.5, 0.5, 1 )
    marble.name = 'marble'

    

    physics.addBody( marble, 'dynamic', marblePhysics )

    local function onAccelerate( event )

        local multiplyer = 0.3
        local newGravityX = event.xGravity *  multiplyer
        local newGravityY = event.yGravity * -multiplyer
    
        marble:applyLinearImpulse(newGravityX, newGravityY, marble.x, marble.y)
    end
 
    Runtime:addEventListener ('accelerometer', onAccelerate)

    return marble
end

return M
