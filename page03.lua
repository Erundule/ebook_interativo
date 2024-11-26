local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

local MARGIN = 30

system.activate("multitouch")

function scene:create(event)
    local sceneGroup = self.view

    -- Criar uma área de rolagem
    local scrollView = widget.newScrollView({
        width = display.contentWidth,
        height = display.contentHeight,
        horizontalScrollDisabled = true, -- Somente rolagem vertical
        scrollWidth = display.contentWidth,
        scrollHeight = 2048, -- Altura total do conteúdo para rolagem
        hideBackground = true, -- Remove o fundo padrão
        listener = function() return true end -- Permitir propagação de eventos
    })

    sceneGroup:insert(scrollView)

    -- Adicionar conteúdo na scrollView
    local bg = display.newImage("assets/pag_scroll.png", display.contentCenterX, display.contentCenterY + 510)
    scrollView:insert(bg)

    local text = display.newImage("assets/text_pag_3.png", display.contentCenterX, display.contentCenterY + MARGIN)
    scrollView:insert(text)

    local contentPart2 = display.newImage("assets/muscle_page3.png", display.contentCenterX, display.contentCenterY + 700)
    scrollView:insert(contentPart2)

    -- Sprite do coração
    local options = { width = 250, height = 290, numFrames = 2 }
    local sheet = graphics.newImageSheet("assets/heart_sprite_sheet.png", options)
    local sequences = { { name = "heart_beat", start = 1, count = 2, time = 800, loopCount = 0 } }
    local sprite = display.newSprite(sheet, sequences)
    sprite.x = display.contentCenterX - 190
    sprite.y = display.contentCenterY + 300
    sprite:play()
    scrollView:insert(sprite)

    -- Músculos (contraído e relaxado)
    local muscleContracted = display.newImage("assets/muscle_contracted.png")
    muscleContracted.x = display.contentCenterX
    muscleContracted.y = display.contentCenterY + 1120
    scrollView:insert(muscleContracted)

    local muscleRelaxed = display.newImage("assets/muscle_relaxed.png")
    muscleRelaxed.x = display.contentCenterX
    muscleRelaxed.y = display.contentCenterY + 1120
    muscleRelaxed.isVisible = false
    scrollView:insert(muscleRelaxed)

    -- Adicionando uma área visível para interação
    local interactionArea = display.newRect(display.contentCenterX, display.contentCenterY + 1120, muscleContracted.width + 50, muscleContracted.height + 50)
    interactionArea:setFillColor(0, 0, 1, 0.2)  -- Cor semitransparente (opcional para depuração)
    interactionArea.alpha = 0  -- Torna a área invisível
    interactionArea.isHitTestable = true  -- Garante que a área ainda possa detectar toques
    scrollView:insert(interactionArea)

    -- Variáveis para detectar gesto de pinça
    local pinchStartDistance = 0
    local pinchInProgress = false
    local currentState = "contracted" -- Estado inicial

    -- Função para alternar o estado do músculo
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
    
    -- Lógica de multitouch
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
                -- Não altere o tamanho da imagem aqui, apenas troque os músculos
                if currentDistance > initialDistance * 1.5 then
                    toggleMuscleState() -- Alternar o estado para relaxado
                    initialDistance = currentDistance
                elseif currentDistance < initialDistance * 0.5 then
                    toggleMuscleState() -- Alternar o estado para contraído
                    initialDistance = currentDistance
                end
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            isZooming= false
        end
        return true
    end

    -- Função de toque para os músculos
    -- local function onMuscleTouch(event)
    --     if event.phase == "began" and event.target == interactionArea then
    --         local dx = event.x - event.xStart
    --         local dy = event.y - event.yStart
    --         pinchStartDistance = math.sqrt(dx * dx + dy * dy)
    --         pinchInProgress = true

    --     elseif event.phase == "moved" and pinchInProgress then
    --         local dx = event.x - event.xStart
    --         local dy = event.y - event.yStart
    --         local currentDistance = math.sqrt(dx * dx + dy * dy)

    --         -- Detectar gesto de pinça (aumentar ou diminuir)
    --         if currentDistance > pinchStartDistance * 1.5 then
    --             toggleMuscleState() -- Alternar o estado
    --             pinchInProgress = false -- Reiniciar o gesto
    --         elseif currentDistance < pinchStartDistance * 0.5 then
    --             toggleMuscleState() -- Alternar o estado
    --             pinchInProgress = false -- Reiniciar o gesto
    --         end
    --     elseif event.phase == "ended" or event.phase == "cancelled" then
    --         pinchInProgress = false
    --         pinchStartDistance = 0
    --     end

    --     return true
    -- end

    -- Adicionar listener global para multitouch
    interactionArea:addEventListener("touch", onMuscleTouch)

    -- Botões de navegação
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

    local btnSound = display.newImage(sceneGroup, "assets/sound_off.png")
    btnSound.x = display.contentCenterX + 320
    btnSound.y = display.contentCenterY + 1420
    scrollView:insert(btnSound)

    local btnNext = display.newImage("assets/next.png")
    btnNext.x = display.contentCenterX + 320
    btnNext.y = display.contentCenterY + 1470
    btnNext:addEventListener("tap", function()
        composer.gotoScene("page04")
    end)
    scrollView:insert(btnNext)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
