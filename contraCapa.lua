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
    
    local bg = display.newImage(sceneGroup,"assets/Referencias_bg.png",385,510);

    local btnPrev = display.newImage(
        sceneGroup,
        "assets/prev_cc.png");

    btnPrev.x = MARGIN + 22
    btnPrev.y = display.contentHeight - MARGIN - 32

    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene( "page05" )
    end)

    local page = display.newImage(
        sceneGroup,
        "assets/home.png");

    page.x = display.contentCenterX
    page.y = display.contentHeight - MARGIN - 32

    page:addEventListener("tap", function(event)
        composer.gotoScene( "capa" )
    end)

    local btnSound = display.newImage(
        sceneGroup,
        "assets/sound_off_blue.png");

    btnSound.x = display.contentWidth - MARGIN - 20
    btnSound.y = display.contentHeight - MARGIN - 88

    -- btnSound:addEventListener("tap"
    -- end)

    local btnNext = display.newImage(
        sceneGroup,
        "assets/next_cc.png");

    btnNext.x = display.contentWidth - MARGIN - 22
    btnNext.y = display.contentHeight - MARGIN - 32

    btnNext:addEventListener("tap", function(event)
        composer.gotoScene( "contraCapa02", {
            time = 3000
        } )
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