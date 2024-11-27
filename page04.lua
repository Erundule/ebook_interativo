local composer = require("composer")
local widget = require("widget")
local physics = require("physics")

local scene = composer.newScene()

physics.start()
physics.setGravity(0, 0)  -- Definindo a gravidade para 0, caso você queira controlar a física

system.activate("multitouch")

local MARGIN = 30

-- Tabela para armazenar todas as conexões
local connections = {}

-- Função para criar o círculo arrastável com física
local function createDraggableCircle(x, y)
    local circle = display.newCircle(x, y, 20)
    circle:setFillColor(1, 1, 1, 0.5) -- Cor semi-transparente
    physics.addBody(circle, "dynamic", {radius = 20, bounce = 0.2}) -- Adiciona corpo físico
    circle.alpha = 0.5
    return circle
end

-- Função para criar as conexões visíveis como bolinhas
local function createImpulsePath(fromX, fromY, toX, toY, numBalls)
    local pathBalls = {}
    local deltaX = (toX - fromX) / numBalls
    local deltaY = (toY - fromY) / numBalls

    -- Criar e animar as bolinhas ao longo do caminho
    for i = 1, numBalls do
        local ball = display.newCircle(fromX + deltaX * i, fromY + deltaY * i, 5)  -- Bolinha de 5px de raio
        ball:setFillColor(1, 0, 0)  -- Cor vermelha para as bolinhas
        physics.addBody(ball, "dynamic", {radius = 5, bounce = 0.5}) -- Adiciona física para as bolinhas
        transition.to(ball, {
            x = toX,
            y = toY,
            time = 1000,
            onComplete = function()
                ball:removeSelf()  -- Remove a bolinha após a animação
            end
        })
        table.insert(pathBalls, ball)
    end

    return pathBalls
end

local function createConnection(scrollView, startX, startY, endX, endY)
    local connection = display.newLine(startX, startY, endX, endY)
    connection:setStrokeColor(0, 1, 0) -- Cor verde para as conexões
    connection.strokeWidth = 5 -- Largura da linha
    scrollView:insert(connection) -- Adicionar a conexão ao scrollView
    return connection
end

-- Criar conexões (ajustado para usar scrollView)
local function createNeuralConnections(scrollView)
    -- Conexão do braço do bebê até a rede neural
    local armToNet = createConnection(
        scrollView,
        display.contentCenterX - 200, display.contentCenterY + 880, -- Ponto inicial (braço)
        display.contentCenterX - 50, display.contentCenterY + 840 -- Ponto final (rede neural)
    )
    -- Conexão de um neuronio até outro neuronio
    local netToneuron = createConnection(
        scrollView,
        display.contentCenterX - 50, display.contentCenterY + 840, -- Rede neural
        display.contentCenterX + 100, display.contentCenterY + 910 -- neuron
    )

    -- Conexão de um neuronio até outro neuronio
    local neurontoneuron = createConnection(
        scrollView,
        display.contentCenterX + 100, display.contentCenterY + 910, -- Rede neural
        display.contentCenterX - 120, display.contentCenterY + 1020 -- neuron
    )

    -- Conexão da rede neural até o bebê feliz
    local neuronToHappy = createConnection(
        scrollView,
        display.contentCenterX - 120, display.contentCenterY + 1020, -- neuron
        display.contentCenterX - 195, display.contentCenterY + 1197 -- Bebê feliz
    )
    -- Conexão da rede neural até o bebê chorando
    local neuronToCry = createConnection(
        scrollView,
        display.contentCenterX + 100, display.contentCenterY + 910, -- neuron
        display.contentCenterX + 240, display.contentCenterY + 1030 -- bebe chorando
    )

    -- Armazenar as conexões para usar depois nas animações
    return {
        armToNet,
        netToneuron,
        neurontoneuron,
        neuronToHappy,
        neuronToCry
    }
end

-- Função para animar o impulso ao longo das conexões
local function animateImpulse(connections)
    for _, connection in ipairs(connections) do
        local fromX, fromY = connection.x1, connection.y1
        local toX, toY = connection.x2, connection.y2

        -- Criar uma bolinha que vai percorrer a linha
        local ball = display.newCircle(fromX, fromY, 5)  -- Tamanho da bolinha
        ball:setFillColor(1, 0, 0)  -- Cor vermelha para a bolinha
        physics.addBody(ball, "dynamic", {radius = 5, bounce = 0.5})  -- Adiciona física à bolinha

        -- Anima a bolinha ao longo da conexão (linha)
        transition.to(ball, {
            x = toX,
            y = toY,
            time = 1000,  -- Tempo da animação
            onComplete = function()
                ball:removeSelf()  -- Remove a bolinha após a animação
            end
        })
    end
end

-- Função de interação com o toque no braço do bebê (ativa a animação para o bebê feliz)
local function onTap(event)
    local phase = event.phase
    local babyArm = event.target

    if phase == "began" then
        print("Tap detectado no braço do bebê")

        -- Animação de teste no braço do bebê
        transition.to(babyArm, {rotation = 15, time = 200, onComplete = function()
            transition.to(babyArm, {rotation = 0, time = 200})
        end}) 

        -- Chamar animateImpulse para o bebê feliz
        if armToNet and netToneuron and neurontoneuron and neuronToHappy then
            animateImpulse({armToNet, netToneuron, neurontoneuron, neuronToHappy})  -- Para o bebê feliz
        end
    end

    return true
end

-- Função de interação com o movimento de arraste (ativa a animação para o bebê triste)
local function onDrag(event)
    local phase = event.phase
    local dragCircle = event.target

    if phase == "began" then
        -- Iniciar o arrasto
        dragCircle.isDragging = true
        -- Desativar a física durante o arrasto
        dragCircle.bodyType = "kinematic"  -- Desativa a física (não afeta gravidade)
        dragCircle:setLinearVelocity(0, 0)  -- Zera qualquer velocidade existente
        print("Arrasto iniciado")
    elseif phase == "moved" then
        if dragCircle.isDragging then
            -- Atualiza a posição do círculo conforme o movimento do toque
            dragCircle.x = event.x
            dragCircle.y = event.y
        end
    elseif phase == "ended" or phase == "cancelled" then
        dragCircle.isDragging = false
        -- Após o movimento, reativar a física
        dragCircle.bodyType = "dynamic"  -- Restaura o comportamento físico (gravidade, colisões)
        dragCircle:setLinearVelocity(0, 0)  -- Zera qualquer velocidade, no caso da física ser ativada novamente
        print("Arrasto finalizado")
    end

    return true
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
        horizontalScrollDisabled = true, -- Somente rolagem vertical
        scrollWidth = display.contentWidth,
        scrollHeight = 2000, -- Altura total do conteúdo para rolagem
        hideBackground = true, -- Remove o fundo padrão
        listener = function() return true end -- Permitir propagação de eventos
    })

    sceneGroup:insert(scrollView)

    -- Criar elementos visuais
    local bg = display.newImage("assets/pag_scroll.png", display.contentCenterX, display.contentCenterY + 510)
    scrollView:insert(bg)

    local text = display.newImage("assets/text_pag_4.png", display.contentCenterX, display.contentCenterY + MARGIN)
    scrollView:insert(text)
    
    local contentPart2 = display.newImage("assets/text_part2_page4.png", display.contentCenterX, display.contentCenterY + 700)
    scrollView:insert(contentPart2)

    local neural_net = display.newImage("assets/rede_neural.png", display.contentCenterX, display.contentCenterY + 1120)
    scrollView:insert(neural_net)

    local baby_arm = display.newImage("assets/baby_arm.png", display.contentCenterX - 200, display.contentCenterY + 880)
    scrollView:insert(baby_arm)

    local happy_baby = display.newImage("assets/happy_baby.png", display.contentCenterX - 200, display.contentCenterY + 1300)
    scrollView:insert(happy_baby)

    local cry_baby = display.newImage("assets/cry_baby.png", display.contentCenterX + 280, display.contentCenterY + 1080)
    scrollView:insert(cry_baby)


     -- Criar o círculo para ser arrastado
    local dragCircle = createDraggableCircle(baby_arm.x, baby_arm.y)
    scrollView:insert(dragCircle)
    baby_arm.dragCircle = dragCircle

    -- Adicionar o listener de arrasto ao dragCircle
    dragCircle:addEventListener("touch", onDrag)

    -- Adicionar o listener de tap ao braço do bebê
    baby_arm:addEventListener("touch", onTap)
    -- Criar os botões de navegação
    local btnPrev = display.newImage("assets/prev.png")
    btnPrev.x = MARGIN + 22
    btnPrev.y = display.contentCenterY + 1470
    btnPrev:addEventListener("tap", function()
        composer.gotoScene("page03")
    end)
    scrollView:insert(btnPrev)

    local page = display.newImage("assets/pag_4.png")
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
        composer.gotoScene("page05")
    end)
    scrollView:insert(btnNext)

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
