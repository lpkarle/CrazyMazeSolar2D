-----------------------------------------------------------------------------------
-- Global Data Module for defining game constances
-----------------------------------------------------------------------------------

local M = {}

 -----------------------------------------------------------------------------------
    -- Sound
    -----------------------------------------------------------------------------------
    M.soundOn = true

    -----------------------------------------------------------------------------------
    -- Colors
    -----------------------------------------------------------------------------------
    M.colorBackground = { 0.125, 0.137, 0.18 }

    M.colorMarble = { 0.922, 0.055, 0.055 }
    M.colorWalls  = { 0.949, 0.949, 0.949 }
    M.colorGoalArea   = { 0.204, 0.871, 0.192, 0.20 }
    M.colorStartArea  = { 0.192, 0.749, 0.871, 0.20 }

    M.colorAccent     = { 1, 0, 0, 0.5 }
    M.colorText = { 0.949, 0.949, 0.949 }

    -----------------------------------------------------------------------------------
    -- Game
    -----------------------------------------------------------------------------------
    M.wallWidth = 10

    M.textOptionsTimer = {
        text = '00:00',
        font = 'src/assets/fonts/static/Raleway-Light.ttf',
        fontSize = 14,
        align = 'right'
    }
return M