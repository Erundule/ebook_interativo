local composer = require("composer")
local widget = require("widget")
local physics = require("physics")

local scene = composer.newScene()

physics.start()
physics.setGravity(0, 0)  -- Definindo a gravidade para 0

system.activate("multitouch")

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

    setSound(scrollView, "assets/audio/conteudo_4.mp3", btnSoundOn, btnSoundOff)
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
function scene:create(event)
    local sceneGroup = self.view

    -- Criar uma área de rolagem
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

    -- Criar elementos visuais
    local bg = display.newImage("assets/pag_scroll.png", display.contentCenterX, display.contentCenterY + 510)
    scrollView:insert(bg)

    local text = display.newImage("assets/text_pag_4.png", display.contentCenterX, display.contentCenterY + MARGIN)
    scrollView:insert(text)
    
    local contentPart2 = display.newImage("assets/text_part2_page4.png", display.contentCenterX, display.contentCenterY + 600)
    scrollView:insert(contentPart2)

    local neural_net = display.newImage("assets/rede_neural.png", display.contentCenterX, display.contentCenterY + 1120)
    scrollView:insert(neural_net)

    local baby_arm = display.newImage("assets/baby_arm.png", display.contentCenterX - 200, display.contentCenterY + 880)
    scrollView:insert(baby_arm)

    local happy_baby = display.newImage("assets/happy_baby.png", display.contentCenterX - 200, display.contentCenterY + 1300)
    scrollView:insert(happy_baby)

    local cry_baby = display.newImage("assets/cry_baby.png", display.contentCenterX + 280, display.contentCenterY + 1080)
    scrollView:insert(cry_baby)

    dragBall = display.newCircle(display.contentCenterX - 200, display.contentCenterY + 880, 15)
    dragBall:setFillColor(1, 1, 1, 0.5)  
    physics.addBody(dragBall, "dynamic", {radius = 15, bounce = 0.5})
    scrollView:insert(dragBall)

    local function createConnection(scrollView, fromX, fromY, toX, toY)
        local connection = display.newLine(fromX, fromY, toX, toY)
        connection:setStrokeColor(0, 0, 0)  
        connection.strokeWidth = 2 
        scrollView:insert(connection)
        return connection
    end
    
    local function animateImpulseAlongPath(path, numBalls)
        for i = 1, #path - 1 do
            local fromX, fromY = path[i][1], path[i][2]
            local toX, toY = path[i+1][1], path[i+1][2]
    
            local deltaX = (toX - fromX) / numBalls
            local deltaY = (toY - fromY) / numBalls
    
            print("Criando o caminho de (" .. fromX .. ", " .. fromY .. ") até (" .. toX .. ", " .. toY .. ")")
    
            for j = 1, numBalls do
                local ballX = fromX + deltaX * j
                local ballY = fromY + deltaY * j
    
                print("Criando bolinha na posição: (" .. ballX .. ", " .. ballY .. ")")
    
                local ball = display.newCircle(ballX, ballY, 5)
                ball:setFillColor(0, 1, 1)  
                physics.addBody(ball, "dynamic", {radius = 5, bounce = 0.5})  
    
                scrollView:insert(ball)
    
                transition.to(ball, {
                    x = toX,  -- Posição final da bolinha
                    y = toY,  -- Posição final da bolinha
                    time = 1000, 
                    onComplete = function()
                        ball:removeSelf()  
                    end
                })
            end
        end
    end
    
    local function onTap(event)
        local phase = event.phase
        local babyArm = event.target

        if phase == "began" then
            print("Toque detectado no braço do bebê")
            
            -- Caminho para o bebê chorando
            local pathToCry = {
                {display.contentCenterX - 200, display.contentCenterY + 880},  -- Posição inicial (braço)
                {display.contentCenterX - 50, display.contentCenterY + 840},  -- Rede neural
                {display.contentCenterX + 100, display.contentCenterY + 910}, -- Neurônio
                {display.contentCenterX + 240, display.contentCenterY + 1030}  -- Bebê chorando
            }
            animateImpulseAlongPath(pathToCry, 10)    -- Para o bebê chorando
        end

        return true
    end

    local function onBallDrag(event)
        local phase = event.phase
        local ball = event.target

        if phase == "began" then
            print("Arrasto iniciado com a bolinha")

            display.getCurrentStage():setFocus(ball)
            ball.isFocus = true
            ball.x0 = event.x - ball.x
            ball.y0 = event.y - ball.y
        elseif phase == "moved" then
            if ball.isFocus then
                ball.x = event.x - ball.x0
                ball.y = event.y - ball.y0
            end
        elseif phase == "ended" or phase == "cancelled" then
            if ball.isFocus then
                display.getCurrentStage():setFocus(nil)
                ball.isFocus = false

                -- Caminho para o bebê feliz
                local pathToHappy = {
                    {display.contentCenterX - 200, display.contentCenterY + 880},  -- Posição inicial (braço)
                    {display.contentCenterX - 50, display.contentCenterY + 840},  -- Rede neural
                    {display.contentCenterX + 100, display.contentCenterY + 910}, -- Neurônio
                    {display.contentCenterX - 120, display.contentCenterY + 1020}, -- Neurônio
                    {display.contentCenterX - 195, display.contentCenterY + 1197}  -- Bebê feliz
                }
                animateImpulseAlongPath(pathToHappy, 10)  -- Para o bebê feliz
            end
        end

        return true
    end

    baby_arm:addEventListener("touch", onTap)

    dragBall:addEventListener("touch", onBallDrag)

    createAudioButton(scrollView)

    local btnPrev = display.newImage("assets/prev.png")
    btnPrev.x = MARGIN + 35
    btnPrev.y = display.contentCenterY + 1470
    btnPrev:addEventListener("tap", function()
        composer.gotoScene("page03")
    end)
    scrollView:insert(btnPrev)

    local page = display.newImage(
        "assets/pag_4.png");

    page.x = display.contentCenterX
    page.y = display.contentCenterY + 1470
    scrollView:insert(page)


    local btnNext = display.newImage("assets/next.png")
    btnNext.x = display.contentCenterX + 320
    btnNext.y = display.contentCenterY + 1470
    btnNext:addEventListener("tap", function()
        composer.gotoScene("page05")
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

