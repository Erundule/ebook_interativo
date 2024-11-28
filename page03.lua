local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

local MARGIN = 30

system.activate("multitouch")

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

local function createAudioButton(scrollView)
    local btnSoundOn = display.newImage("assets/sound_on.png", display.contentCenterX + 320, display.contentCenterY + 1420)
    local btnSoundOff = display.newImage("assets/sound_off.png", display.contentCenterX + 320, display.contentCenterY + 1420)
    btnSoundOff.isVisible = false

    setSound(scrollView, "assets/audio/conteudo_3.mp3", btnSoundOn, btnSoundOff)
end

function scene:create(event)
    local sceneGroup = self.view

    local scrollView = widget.newScrollView({
        width = display.contentWidth,
        height = display.contentHeight,
        horizontalScrollDisabled = true,
        scrollWidth = display.contentWidth,
        scrollHeight = 2048,
        hideBackground = true,
        listener = function() return true end
    })

    sceneGroup:insert(scrollView)

    local bg = display.newImage("assets/pag_scroll.png", display.contentCenterX, display.contentCenterY + 510)
    scrollView:insert(bg)

    local text = display.newImage("assets/text_pag_3.png", display.contentCenterX, display.contentCenterY + MARGIN)
    scrollView:insert(text)

    local contentPart2 = display.newImage("assets/muscle_page3.png", display.contentCenterX, display.contentCenterY + 700)
    scrollView:insert(contentPart2)

    local options = { width = 250, height = 290, numFrames = 2 }
    local sheet = graphics.newImageSheet("assets/heart_sprite_sheet.png", options)
    local sequences = { { name = "heart_beat", start = 1, count = 2, time = 800, loopCount = 0 } }
    local sprite = display.newSprite(sheet, sequences)
    sprite.x = display.contentCenterX - 190
    sprite.y = display.contentCenterY + 300
    sprite:play()
    scrollView:insert(sprite)

    local muscleContracted = display.newImage("assets/muscle_contracted.png")
    muscleContracted.x = display.contentCenterX
    muscleContracted.y = display.contentCenterY + 1120
    scrollView:insert(muscleContracted)

    local muscleRelaxed = display.newImage("assets/muscle_relaxed.png")
    muscleRelaxed.x = display.contentCenterX
    muscleRelaxed.y = display.contentCenterY + 1120
    muscleRelaxed.isVisible = false
    scrollView:insert(muscleRelaxed)

    local interactionArea = display.newRect(display.contentCenterX, display.contentCenterY + 1120, muscleContracted.width + 50, muscleContracted.height + 50)
    interactionArea:setFillColor(0, 0, 1, 0.2)  
    interactionArea.alpha = 0  
    interactionArea.isHitTestable = true  
    scrollView:insert(interactionArea)

    local pinchStartDistance = 0
    local pinchInProgress = false
    local currentState = "contracted"

    local function toggleMuscleState()
        if currentState == "contracted" then
            muscleContracted.isVisible = false
            muscleRelaxed.isVisible = true
            currentState = "relaxed"
        else
            muscleContracted.isVisible = true
            muscleRelaxed.isVisible = false
            currentState = "contracted"
        end
    end

    local function calculateDistance(x1, y1, x2, y2)
        local dx = x2 - x1
        local dy = y2 - y1
        return math.sqrt(dx * dx + dy * dy)
    end
    
    local finger1, finger2
    local initialDistance
    local isZooming = false

    local function onMuscleTouch(event)
        if event.phase == "began" and event.target == interactionArea then
            if not finger1 then
                finger1 = event
            elseif not finger2 then
                finger2 = event
                isZooming = true
                initialDistance = calculateDistance(finger1.x, finger1.y, finger2.x, finger2.y)
            end
        elseif event.phase == "moved" and isZooming then
            if finger1 and finger2 and event.id == finger1.id then
                finger1 = event
            elseif finger1 and finger2 and event.id == finger2.id then
                finger2 = event
            end

            if finger1 and finger2 then
                local currentDistance = calculateDistance(finger1.x, finger1.y, finger2.x, finger2.y)
                if currentDistance > initialDistance * 1.5 then
                    toggleMuscleState() 
                    initialDistance = currentDistance
                elseif currentDistance < initialDistance * 0.5 then
                    toggleMuscleState() 
                    initialDistance = currentDistance
                end
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            isZooming = false
        end
        return true
    end

    interactionArea:addEventListener("touch", onMuscleTouch)
    
    createAudioButton(scrollView)

    local btnPrev = display.newImage("assets/prev.png")
    btnPrev.x = MARGIN + 35
    btnPrev.y = display.contentCenterY + 1470
    btnPrev:addEventListener("tap", function()
        composer.gotoScene("page02")
    end)
    scrollView:insert(btnPrev)

    local page = display.newImage("assets/pag_3.png")
    page.x = display.contentCenterX
    page.y = display.contentCenterY + 1470
    scrollView:insert(page)

    local btnNext = display.newImage("assets/next.png")
    btnNext.x = display.contentCenterX + 320
    btnNext.y = display.contentCenterY + 1470
    btnNext:addEventListener("tap", function()
        composer.gotoScene("page04")
    end)
    scrollView:insert(btnNext)
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
function scene:destroy( event )
    local sceneGroup = self.view
    audio.dispose(soundTrack)
    soundTrack = nil
end
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
return scene
