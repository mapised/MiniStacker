--[[
Mini stacker game states:
0: Menu
1: Game
2: Results
]]

coneFacts = {
    "Cone Stacker was made by Gavin",
    "Cones are orange.",
    "If you reach the score of 1,000 a secret will happen.",
    "There are 27 cones in the software room.",
    "Mini Stacker is available on Steam!",
    "WPILIB is written in Java and C++",
    "The cone was drawn in piskel.",
    "Cone Stacker is written in C++!",
    "Mini Stacker is 2D",
    "Traffic cones are used to direct traffic.",
    "Mini Stacker was made by Aiden",
    "The sound effects are from cone stacker!",
    "Mini Stacker is written in Lua!",
    "Joaquin is Gavin's favorite rookie",
    "Noah is the best rookie coder",
    "Cones are cool.",
    "Mini Stacker has 21,921 total lines of code.",
    "Traffic cones weren't invented until the 1940s.",
    "Your personal best does not save.",
    "Java sucks ): - Wes",
    "Coding is fun (:",
    "Java is great (:",
    "HTML and CSS is used to make websites",
    "Coding is very mentally draining",
    "Conemunism is amazing!",
    "Java is a slang word for coffee. It is not a coding language.",
    "The initial name for Java is Oak",
    "Minecraft was written in Java.",
    "Cones reset for every 25 stack because i'm lazy to make it scroll.",
    "Mini Stacker has 20 endings.",
    "Arrays in Lua start a 1",
    "Mini Stacker can be played with spacebar, mouse, w key, and up arrow.",
    "Press F to go fullscreen mode.",
    "There are around 40 cone facts in the game.",
    "Press I or O to zoom in or out.",
    "Mini Stacker has won several awards for it's great game design and breathtaking visuals."
}

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    personalBest = 0
    currentScore = 0
    gameState = 0
    scaleFactor = 1

    loadAssets()
    getDimensions()

    musicLoop:setLooping(true)
    musicLoop:setVolume(0.1)
    coneDrop:setVolume(1)
    coneFall:setVolume(1)

    love.window.setTitle("Mini Stacker")
    love.window.setIcon(love.image.newImageData("sprites/icon.png"))
    love.window.setMode(800, 600, {resizable = true, fullscreen = false})
    love.graphics.setFont(regular)
    love.audio.play(musicLoop)
end 

function loadAssets()
    -- fonts
    regular = love.graphics.newFont("fonts/Acme 9 Regular.ttf")
    -- sprites
    coneSprite = love.graphics.newImage("sprites/cone.png")
    icon = love.graphics.newImage("sprites/icon.png")
    -- sounds
    musicLoop = love.audio.newSource("sounds/musicLoop.mp3", "stream")
    coneDrop = love.audio.newSource("sounds/coneDrop.ogg", "static")
    coneFall = love.audio.newSource("sounds/coneFall.ogg", "static")
    win = love.audio.newSource("sounds/win.ogg", "static")
end

function startGame()
    factTimer = 5

    currentFact = getConeFact()
    currentScore = 0
    currentCone = 1

    placingX = 0
    placingOffset = 0
    placingDirection = -1
    placingSpeed = 0.2
    gameState = 1
end

function endGame()
    if currentScore > personalBest then
        personalBest = currentScore
    end
    gameState = 3
end

function getConeFact()
    return coneFacts[love.math.random(1, #coneFacts)]
end

function getConeHeight(i)
    return (screenHeight - (coneHeight) - ((i-1) * (coneHeight * 0.2)))
end

function triangle(t)
    return 2 * math.abs(2 * (t % 1) - 1) - 1
end

function getDimensions()
    textSize1 = (1.25 * scaleFactor)
    textSize2 = (3 * scaleFactor)
    textSize3 = (1.5 * scaleFactor)
    textSize4 = (0.8 * scaleFactor)
    --
    coneSize = (2.5 * scaleFactor)
    iconSize = (4 * scaleFactor)
    placingHeight = (38 * coneSize)

    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    iconWidth = (icon:getWidth() * iconSize)
    iconHeight = (icon:getHeight() * iconSize)
    coneWidth = (coneSprite:getWidth() * coneSize)
    coneHeight = (coneSprite:getHeight() * coneSize)
    coneCenter = (screenWidth / 2) + (coneWidth / 2)
end

function love.update(deltaTime)
    if gameState == 1 then
        -- Refresh the cone fact every five seconds.
        factTimer = factTimer-deltaTime
        if factTimer <= 0 then
            currentFact = getConeFact()
            factTimer = 5
        end
        --
        placingOffset = (placingOffset + ((deltaTime * (placingSpeed * 8)) * placingDirection))
        if placingDirection == -1 then
            if placingOffset < -1 then
                placingDirection = 1
            end
        else
            if placingOffset > 1 then
                placingDirection = -1
            end
        end
    end
end

function drawMenu()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("(W, Up, Click, Space): Drop Cone, (I, O): Zoom, (F): Fullscreen", 0, 0, 0, textSize4, textSize4)
    love.graphics.print("CREDITS: Aiden (Creator), Gavin (Cone Stacker), Joaquin, Noah, Wesley, Stephen (Playtesting)", 0, (regular:getHeight()*textSize4), 0, textSize4, textSize4)

    love.graphics.printf("Mini Stacker!", 0, screenHeight / 2 - (regular:getHeight()*scaleFactor*6), screenWidth/textSize2, "center", 0, textSize2, textSize2)
    love.graphics.printf("Inspired by Cone Stacker, Created in Love2D", 0, screenHeight / 2 + (regular:getHeight()*scaleFactor*3), screenWidth/textSize3, "center", 0, textSize3, textSize3)
    love.graphics.printf("PRESS SPACE TO PLAY", 0, screenHeight / 2 + (regular:getHeight()*scaleFactor*6), screenWidth/textSize1, "center", 0, textSize1, textSize1)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(icon, (screenWidth/2) - (iconWidth/2), (screenHeight/2) - (iconHeight/2), 0, iconSize, iconSize)
end

function drawResults()
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Game Over!", 0, screenHeight / 2 - (regular:getHeight()*scaleFactor*3), screenWidth/textSize2, "center", 0, textSize2, textSize2)
    love.graphics.printf("Your personal best: " .. personalBest, 0, screenHeight / 2 + (regular:getHeight()*scaleFactor*3), screenWidth/textSize3, "center", 0, textSize3, textSize3)
    love.graphics.printf("PRESS SPACE TO GO BACK TO MENU", 0, screenHeight / 2 + (regular:getHeight()*scaleFactor*6), screenWidth/textSize1, "center", 0, textSize1, textSize1)
end

function drawGame()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(currentScore, 10, 10, 0, textSize2, textSize2)
    love.graphics.print("Fun Software Fact: " .. currentFact, 10, 10 + (regular:getHeight() * scaleFactor * textSize2), 0, textSize1, textSize1)
    -- Draw all the cones
    love.graphics.setColor(1, 1, 1)
    for i = 1, currentCone do
        love.graphics.draw(coneSprite, coneCenter, getConeHeight(i), math.pi/2, coneSize, coneSize)
    end
    -- Placing cone
    do        
        local placingY = getConeHeight(currentCone) - placingHeight
        -- Make it move back and forth for extra difficulty.
        placingX = coneCenter + (placingOffset * (coneWidth))
        love.graphics.draw(coneSprite, placingX, placingY, math.pi/2, coneSize, coneSize)
    end
end

function love.draw()
    love.graphics.setBackgroundColor(0.82, 0.82, 0.82)

    if gameState == 0 then -- Main Menu
        drawMenu()
    elseif gameState == 1 then -- Game
        drawGame()
    else -- Results
        drawResults()
    end
end

function dropCone()
    if math.abs(placingX - coneCenter) < (coneWidth * 0.5) then
        -- Placed a cone!
        love.audio.stop(coneDrop)
        love.audio.play(coneDrop)
        currentScore = currentScore + 1

        placingOffset = 0
        if placingSpeed < 1 then
            placingSpeed = placingSpeed + 0.025
        else
            placingSpeed = placingSpeed + 0.01
        end
        
        if currentCone >= 25 then -- reached the limit of visible cones
            love.audio.play(win)
            currentCone = 0      
        end
        currentCone = currentCone + 1
    else
        -- You failed to place the cone. Game Over.
        love.audio.play(coneFall)
        endGame()
    end
end

function love.mousepressed()
    if gameState == 1 then
        dropCone()
    end
end

function love.keypressed(keyPressed)
    -- other keys you can press to drop the cone.
    if keyPressed == "i" then
        if scaleFactor < 3 then
            scaleFactor = scaleFactor + 0.25
        end
        getDimensions()
    end

    if keyPressed == "o" then
        if scaleFactor > 0.25 then
            scaleFactor = scaleFactor - 0.25
        end
        getDimensions()
    end

    if keyPressed == "f" then
        if love.window.getFullscreen() == true then
            love.window.setFullscreen(false)
        else
            love.window.setFullscreen(true)
        end
    end   
        
    if keyPressed == "up" or keyPressed == "w" or keyPressed == "space" then
        if gameState == 1 then
            dropCone()
        else
            if gameState == 0 then
                startGame()
            elseif gameState == 3 then
                gameState = 0
            end
        end
    end
end

function love.resize()
    -- so that the window proportions don't break.
    getDimensions()
end