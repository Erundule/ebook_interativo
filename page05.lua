local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()

 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
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

local function createAudioButton(scrollView)
    local btnSoundOn = display.newImage("assets/sound_on.png", display.contentCenterX + 320, display.contentCenterY + 1420)
    local btnSoundOff = display.newImage("assets/sound_off.png", display.contentCenterX + 320, display.contentCenterY + 1420)
    btnSoundOff.isVisible = false

    setSound(scrollView, "assets/audio/conteudo_5.mp3", btnSoundOn, btnSoundOff)
end

 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
    local scrollView = widget.newScrollView({
        width = display.contentWidth,
        height = display.contentHeight,
        horizontalScrollDisabled = true, 
        scrollWidth = display.contentWidth,
        scrollHeight = 2000, 
        hideBackground = true,
        listener = function() return true end 
    })

    sceneGroup:insert(scrollView)

    local bg = display.newImage("assets/pag_scroll.png", display.contentCenterX, display.contentCenterY + 510);
    scrollView:insert(bg)

    local text = display.newImage("assets/text_pag_5.png", display.contentCenterX, display.contentCenterY + MARGIN);
    scrollView:insert(text)
    
    local contentPart2 = display.newImage("assets/text_part2_page5.png", display.contentCenterX, display.contentCenterY + 600)
    scrollView:insert(contentPart2)

    local image = display.newImage("assets/sistema_circulatorio.png", display.contentCenterX, display.contentCenterY + 1000)
    scrollView:insert(image)

    createAudioButton(scrollView)

    local btnPrev = display.newImage(
        "assets/prev.png");
        
    btnPrev.x = MARGIN + 35
    btnPrev.y = display.contentCenterY + 1470

    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene( "page04" )
    end)
    scrollView:insert(btnPrev)

    local page = display.newImage(
        "assets/pag_5.png");

    page.x = display.contentCenterX
    page.y = display.contentCenterY + 1470
    scrollView:insert(page)

   

    local btnNext = display.newImage(
        scrollView,
        "assets/next.png");
    btnNext.x = display.contentCenterX + 320
    btnNext.y = display.contentCenterY + 1470

    btnNext:addEventListener("tap", function(event)
        composer.gotoScene( "contraCapa" )
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
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
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
