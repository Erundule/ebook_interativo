local composer = require("composer")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Constants
-- -----------------------------------------------------------------------------------
local MARGIN = 30
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

    setSound(sceneGroup, "assets/audio/conteudo_2.mp3", btnSoundOn, btnSoundOff)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view

    local bg = display.newImage(sceneGroup, "assets/paginas_bg.png", 385, 510)

    local text = display.newImage(sceneGroup, "assets/text_pag_2.png", 385, 490)

    local glandula = display.newImage(sceneGroup, "assets/glandula.png", 585, 690)

    local limiteArea = {
        xMin = glandula.x - glandula.width * 0.5 + 180,
        xMax = glandula.x + glandula.width * 0.5 - 180,
        yMin = glandula.y - glandula.height * 0.5 + 125,
        yMax = glandula.y + glandula.height * 0.5 - 125,
    }

    local offsets = {
        { x = -23, y = -20 },
        { x = -20, y = 30 },
        { x = -22, y = -10 },
        { x = -19, y = 25 },
        { x = -21, y = 10 },
    }

    local fluidos = {}
    for i, offset in ipairs(offsets) do
        local fluido = display.newCircle(sceneGroup, glandula.x + offset.x, glandula.y + offset.y, 10)
        fluido:setFillColor(0.2, 0.6, 1) 
        fluido.name = "fluido_" .. i
        table.insert(fluidos, fluido)
    end

    local function manterDentroDosLimites(obj)
        if obj.x < limiteArea.xMin then obj.x = limiteArea.xMin end
        if obj.x > limiteArea.xMax then obj.x = limiteArea.xMax end
        if obj.y > limiteArea.yMax then obj.y = limiteArea.yMax end
    end

    local function isOutsideLimits(obj)
        return obj.x < limiteArea.xMin or obj.x > limiteArea.xMax or obj.y < limiteArea.yMin or obj.y > limiteArea.yMax
    end

    local function onDrag(event)
        local target = event.target

        if event.phase == "began" then
            display.currentStage:setFocus(target)
            target.isFocus = true
            target.startX, target.startY = target.x, target.y 
        elseif event.phase == "moved" and target.isFocus then
            target.x, target.y = event.x, event.y
            manterDentroDosLimites(target) 
        elseif event.phase == "ended" or event.phase == "cancelled" then

            display.currentStage:setFocus(nil)
            target.isFocus = false

            if isOutsideLimits(target) then
                display.remove(target)
                print(target.name .. " foi expelido!")
            end
        end
        return true
    end

    createAudioButton(sceneGroup)

    for _, fluido in ipairs(fluidos) do
        fluido:addEventListener("touch", onDrag)
    end

    local btnPrev = display.newImage(sceneGroup, "assets/prev.png")
    btnPrev.x = MARGIN + 22
    btnPrev.y = display.contentHeight - MARGIN - 32
    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene("paginas.page01")
    end)

    local page = display.newImage(sceneGroup, "assets/pag_2.png")
    page.x = display.contentCenterX
    page.y = display.contentHeight - MARGIN - 32

    local btnNext = display.newImage(sceneGroup, "assets/next.png")
    btnNext.x = display.contentWidth - MARGIN - 20
    btnNext.y = display.contentHeight - MARGIN - 32
    btnNext:addEventListener("tap", function(event)
        composer.gotoScene("paginas.page03")
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
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
