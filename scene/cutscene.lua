local composer = require("composer")

local scene = composer.newScene()

print('[+] Cutscene: START')


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)

    print('[+] Cutscene: CREATE')

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

end

-- show()
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then

        print('[+] Cutscene: SHOW WILL')

        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif (phase == "did") then

        print('[+] Cutscene: SHOW DID')

        composer.gotoScene( 'scene.game', { effect = 'fade', time = 1000 } )
    end
end

-- hide()
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then

        print('[+] Cutscene: HIDE WILL')

        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif (phase == "did") then

        print('[+] Cutscene: HIDE DID')

        composer.removeScene( 'scene.cutscene' )

    end
end

-- destroy()
function scene:destroy(event)

    print('[+] Cutscene: DESTROY')

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
