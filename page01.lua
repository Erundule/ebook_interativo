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
    local bg = display.newImage(sceneGroup,"assets/paginas_bg.png",385,510)

    local text = display.newImage(sceneGroup,"assets/text_pag_1.png",385,250)
    local image_body = display.newImage(sceneGroup,"assets/body.png",385,600)
    
    -- Adiciona um flag para alternar entre os estados da imagem
    local isBodyInfoVisible = false  -- Define que a imagem de "body_info" não está visível inicialmente
    
    image_body:addEventListener("tap", function(event)
        if isBodyInfoVisible then
            -- Se a imagem de "body_info" estiver visível, retorna para a imagem original
            display.remove(sceneGroup.bodyInfo)
            sceneGroup.bodyInfo = display.newImage(sceneGroup, "assets/body.png", 385, 600)
            isBodyInfoVisible = false  -- Altera o estado da flag
        else
            -- Caso contrário, mostra a imagem "body_info"
            display.remove(sceneGroup.bodyInfo)
            sceneGroup.bodyInfo = display.newImage(sceneGroup, "assets/body_info.png", 385, 700)
            isBodyInfoVisible = true  -- Altera o estado da flag
        end
    end)
    
    -- Botão de navegação para voltar à cena anterior
    local btnPrev = display.newImage(sceneGroup, "assets/prev.png")
    btnPrev.x = MARGIN + 22
    btnPrev.y = display.contentHeight - MARGIN - 32
    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene("capa")
    end)

    -- Página
    local page = display.newImage(sceneGroup, "assets/pag_1.png")
    page.x = display.contentCenterX
    page.y = display.contentHeight - MARGIN - 32

    -- Botões de som e próximo
    local btnSound = display.newImage(sceneGroup, "assets/sound_off.png")
    btnSound.x = display.contentWidth - MARGIN - 20
    btnSound.y = display.contentHeight - MARGIN - 88

    local btnNext = display.newImage(sceneGroup, "assets/next.png")
    btnNext.x = display.contentWidth - MARGIN - 20
    btnNext.y = display.contentHeight - MARGIN - 32
    btnNext:addEventListener("tap", function(event)
        composer.gotoScene("page02", {
            time = 3000
        })
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