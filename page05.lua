local composer = require( "composer" )
local widget = require("widget")
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
    
    -- Criar uma área de rolagem
    local scrollView = widget.newScrollView({
        width = display.contentWidth,
        height = display.contentHeight,
        horizontalScrollDisabled = true, -- Somente rolagem vertical
        scrollWidth = display.contentWidth,
        scrollHeight = 2000, -- Altura total do conteúdo para rolagem
        hideBackground = true, -- Remove o fundo padrão
        listener = function() return true end -- Permitir propagação de eventos
    })

    sceneGroup:insert(scrollView)

    local bg = display.newImage("assets/pag_scroll.png", display.contentCenterX, display.contentCenterY + 365);
    scrollView:insert(bg)

    local text = display.newImage("assets/text_pag_5.png", display.contentCenterX, display.contentCenterY + MARGIN);
    scrollView:insert(text)
    
    local contentPart2 = display.newImage("assets/text_part2_page5.png", display.contentCenterX, display.contentCenterY + 600)
    scrollView:insert(contentPart2)

    local image = display.newImage("assets/sistema_circulatorio.png", display.contentCenterX, display.contentCenterY + 1000)
    scrollView:insert(image)

    local btnPrev = display.newImage(
        "assets/prev.png");


    btnPrev.x = MARGIN + 35
    btnPrev.y = display.contentCenterY + 1320

    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene( "page04" )
    end)
    scrollView:insert(btnPrev)

    local page = display.newImage(
        "assets/pag_5.png");

    page.x = display.contentCenterX
    page.y = display.contentCenterY + 1300
    scrollView:insert(page)

    local btnSound = display.newImage(
        "assets/sound_off.png");

    btnSound.x = display.contentCenterX + 320
    btnSound.y = display.contentCenterY + 1270

    -- btnSound:addEventListener("tap"
    -- end)
    scrollView:insert(btnSound)

    local btnNext = display.newImage(
        scrollView,
        "assets/next.png");

    btnNext.x = display.contentCenterX + 320
    btnNext.y = display.contentCenterY + 1320

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
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene