local composer = require("composer")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Constants
-- -----------------------------------------------------------------------------------
local MARGIN = 30

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Background
    local bg = display.newImage(sceneGroup, "assets/paginas_bg.png", 385, 510)

    local text = display.newImage(sceneGroup, "assets/text_pag_2.png", 385, 490)

    -- Adiciona a imagem da glândula
    local glandula = display.newImage(sceneGroup, "assets/glandula.png", 585, 690)

    -- Área de limite baseada na glândula
    local limiteArea = {
        xMin = glandula.x - glandula.width * 0.5 + 180,
        xMax = glandula.x + glandula.width * 0.5 - 180,
        yMin = glandula.y - glandula.height * 0.5 + 125,
        yMax = glandula.y + glandula.height * 0.5 - 125,
    }

    -- Posições relativas à glândula (offsets)
    local offsets = {
        { x = -23, y = -20 },
        { x = -20, y = 30 },
        { x = -22, y = -10 },
        { x = -19, y = 25 },
        { x = -21, y = 10 },
    }

    -- Cria os fluidos com base nos offsets
    local fluidos = {}
    for i, offset in ipairs(offsets) do
        local fluido = display.newCircle(sceneGroup, glandula.x + offset.x, glandula.y + offset.y, 10)
        fluido:setFillColor(0.2, 0.6, 1) -- Cor do fluido
        fluido.name = "fluido_" .. i
        table.insert(fluidos, fluido)
    end

    -- Função para verificar se o fluido está dentro dos limites
    local function manterDentroDosLimites(obj)
        if obj.x < limiteArea.xMin then obj.x = limiteArea.xMin end
        if obj.x > limiteArea.xMax then obj.x = limiteArea.xMax end
        if obj.y > limiteArea.yMax then obj.y = limiteArea.yMax end
    end

    -- Função para verificar se o fluido está fora dos limites
    local function isOutsideLimits(obj)
        return obj.x < limiteArea.xMin or obj.x > limiteArea.xMax or obj.y < limiteArea.yMin or obj.y > limiteArea.yMax
    end

    -- Função para manipular o arrasto dos fluidos
    local function onDrag(event)
        local target = event.target

        if event.phase == "began" then
            -- Início do toque
            display.currentStage:setFocus(target) -- Foca no objeto
            target.isFocus = true
            target.startX, target.startY = target.x, target.y -- Armazena a posição inicial
        elseif event.phase == "moved" and target.isFocus then
            -- Movimenta o fluido com o dedo
            target.x, target.y = event.x, event.y
            manterDentroDosLimites(target) -- Mantém o fluido dentro dos limites durante o movimento
        elseif event.phase == "ended" or event.phase == "cancelled" then
            -- Finaliza o arrasto
            display.currentStage:setFocus(nil)
            target.isFocus = false

            -- Verifica se o fluido saiu dos limites ao ser solto
            if isOutsideLimits(target) then
                -- Remove o fluido e imprime mensagem no console
                display.remove(target)
                print(target.name .. " foi expelido!")
            end
        end
        return true
    end

    -- Adiciona o evento "touch" a cada fluido
    for _, fluido in ipairs(fluidos) do
        fluido:addEventListener("touch", onDrag)
    end

    -- Botão Anterior
    local btnPrev = display.newImage(sceneGroup, "assets/prev.png")
    btnPrev.x = MARGIN + 22
    btnPrev.y = display.contentHeight - MARGIN - 32
    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene("page01")
    end)

    -- Paginação
    local page = display.newImage(sceneGroup, "assets/pag_2.png")
    page.x = display.contentCenterX
    page.y = display.contentHeight - MARGIN - 32

    -- Botão de Som
    local btnSound = display.newImage(sceneGroup, "assets/sound_off.png")
    btnSound.x = display.contentWidth - MARGIN - 20
    btnSound.y = display.contentHeight - MARGIN - 88

    -- Botão Próximo
    local btnNext = display.newImage(sceneGroup, "assets/next.png")
    btnNext.x = display.contentWidth - MARGIN - 20
    btnNext.y = display.contentHeight - MARGIN - 32
    btnNext:addEventListener("tap", function(event)
        composer.gotoScene("page03")
    end)
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
    elseif (phase == "did") then
        -- Code here runs when the scene is entirely on screen
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Code here runs when the scene is on screen (but is about to go off screen)
    elseif (phase == "did") then
        -- Code here runs immediately after the scene goes entirely off screen
    end
end

-- destroy()
function scene:destroy(event)
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
