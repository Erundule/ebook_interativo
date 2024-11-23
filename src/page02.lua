local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless

-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local MARGIN = 30
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local bg = display.newImage(sceneGroup,"assets/paginas_bg.png",385,510);

    local text = display.newImage(sceneGroup,"assets/text_pag_2.png",385,490);
    
    -- Adiciona a imagem da glândula
    local glandula = display.newImage(sceneGroup, "assets/glandula.png",585,690 )

    -- Área de expulsão (opcional)
    local expulsaoArea = display.newCircle(sceneGroup, display.contentCenterX, display.contentCenterY, 150)
    expulsaoArea:setFillColor(0.5, 0.5, 0.5, 0.3) -- Transparente para visualização
    expulsaoArea.isVisible = false -- Use visível apenas para debugging

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

    -- Função para manipular o arrasto dos fluidos
    local function onDrag(event)
        local target = event.target

        if event.phase == "began" then
            -- Início do toque
            display.currentStage:setFocus(target) -- Foca no objeto
            target.isFocus = true
        elseif event.phase == "moved" and target.isFocus then
            -- Movimenta o fluido com o dedo
            target.x, target.y = event.x, event.y
        elseif event.phase == "ended" or event.phase == "cancelled" then
            -- Finaliza o arrasto
            display.currentStage:setFocus(nil)
            target.isFocus = false

            -- Verifica se o fluido foi expelido (fora da área da glândula)
            local dist = math.sqrt((target.x - glandula.x)^2 + (target.y - glandula.y)^2)
            if dist > expulsaoArea.path.radius then
                -- Remove o fluido ou aplica outro efeito
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


    local btnPrev = display.newImage(
        sceneGroup,
        "assets/prev.png");

    btnPrev.x = MARGIN + 22
    btnPrev.y = display.contentHeight - MARGIN - 32

    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene( "page01" )
    end)

    local page = display.newImage(
        sceneGroup,
        "assets/pag_2.png");

    page.x = display.contentCenterX
    page.y = display.contentHeight - MARGIN - 32

    local btnSound = display.newImage(
        sceneGroup,
        "assets/sound_off.png");

    btnSound.x = display.contentWidth - MARGIN - 20
    btnSound.y = display.contentHeight - MARGIN - 88

    -- btnNext:addEventListener("tap"
    -- end)

    local btnNext = display.newImage(
        sceneGroup,
        "assets/next.png");

    btnNext.x = display.contentWidth - MARGIN - 20
    btnNext.y = display.contentHeight - MARGIN - 32

    btnNext:addEventListener("tap", function(event)
        composer.gotoScene( "page03" )
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
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene