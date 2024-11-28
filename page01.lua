local composer = require( "composer" )
local audio = require("audio")
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local MARGIN = 30

-- -----------------------------------------------------------------------------------
-- Funções de Controle de Áudio
-- -----------------------------------------------------------------------------------

local soundTrack

local function soundVisibilitySwitch(btnSoundOn, btnSoundOff)
    btnSoundOff.isVisible = not btnSoundOff.isVisible
    btnSoundOn.isVisible = not btnSoundOn.isVisible
end

local function setSound(sceneGroup, soundPath, btnSoundOn, btnSoundOff)
    soundTrack = audio.loadStream(soundPath)

    local function soundEnd(event)
        if event.completed then
            soundVisibilitySwitch(btnSoundOn, btnSoundOff)
        end
    end

    local soundOptions = {
        channel = 1,
        loops = 0,
        fadein = 50,
        onComplete = soundEnd
    }

    local function soundEvent()
        soundVisibilitySwitch(btnSoundOn, btnSoundOff)
        if btnSoundOff.isVisible then
            audio.stop(1)
            audio.rewind(soundTrack)
        else
            audio.play(soundTrack, soundOptions)
        end
    end

    sceneGroup:insert(btnSoundOn)
    sceneGroup:insert(btnSoundOff)

    btnSoundOn:addEventListener("tap", soundEvent)
    btnSoundOff:addEventListener("tap", soundEvent)

    audio.setVolume(0.5, { channel = 1 })

    timer.performWithDelay(1000, function()
        audio.play(soundTrack, soundOptions)
        audio.fade({ channel = 1, time = 500, volume = 1 })
    end)
end


local function createAudioButton(sceneGroup)
    local btnSoundOn = display.newImage(sceneGroup, "assets/sound_on.png", display.contentWidth - MARGIN - 20, display.contentHeight - MARGIN - 88)
    local btnSoundOff = display.newImage(sceneGroup, "assets/sound_off.png", display.contentWidth - MARGIN - 20, display.contentHeight - MARGIN - 88)
    btnSoundOff.isVisible = false

    setSound(sceneGroup, "assets/audio/conteudo_1.mp3", btnSoundOn, btnSoundOff)
end

function scene:create(event)
    local sceneGroup = self.view

    local bg = display.newImage(sceneGroup, "assets/paginas_bg.png", 385, 510)

    local text = display.newImage(sceneGroup, "assets/text_pag_1.png", 385, 250)
    local image_body = display.newImage(sceneGroup, "assets/body.png", 385, 600)

    local isBodyInfoVisible = false

    image_body:addEventListener("tap", function(event)
        if isBodyInfoVisible then
            display.remove(sceneGroup.bodyInfo)
            sceneGroup.bodyInfo = display.newImage(sceneGroup, "assets/body.png", 385, 600)
        else
            display.remove(sceneGroup.bodyInfo)
            sceneGroup.bodyInfo = display.newImage(sceneGroup, "assets/body_info.png", 385, 700)
            isBodyInfoVisible = true
        end
    end)

    createAudioButton(sceneGroup)

    local btnPrev = display.newImage(sceneGroup, "assets/prev.png")
    btnPrev.x = MARGIN + 22
    btnPrev.y = display.contentHeight - MARGIN - 32
    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene("capa")
    end)

    local page = display.newImage(sceneGroup, "assets/pag_1.png")
    page.x = display.contentCenterX
    page.y = display.contentHeight - MARGIN - 32

    local btnNext = display.newImage(sceneGroup, "assets/next.png")
    btnNext.x = display.contentWidth - MARGIN - 20
    btnNext.y = display.contentHeight - MARGIN - 32
    btnNext:addEventListener("tap", function(event)
        composer.gotoScene("page02")
    end)
end
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        audio.stop(1)  
    end
end
 
 
-- destroy()
function scene:destroy(event)
    if soundTrack then
        audio.stop(1)  
        audio.dispose(soundTrack)  
        soundTrack = nil
    end
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