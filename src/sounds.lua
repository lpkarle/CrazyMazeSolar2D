local M = {}

local soundDir = 'src/assets/sounds/'

local bgMusicMenuSrc = soundDir .. 'beautiful-random-minor-arp-119378.mp3'
local bgMusicChannel = { channel = 1, loops = -1, fadein = 3000, fadeout = 3000 }

function M.sfxBackgroundMenu()

    local sfx = {}
    local x = audio.loadStream( bgMusicMenuSrc, bgMusicChannel )

    sfx.start = function()
        audio.play( x )
    end

    sfx.stop = function()
        audio.stop( bgMusicChannel.channel )
    end

    sfx.fadeOut = function()
        audio.fadeOut( bgMusicChannel.channel, bgMusicChannel.fadeout )
    end

    return sfx
end

return M
