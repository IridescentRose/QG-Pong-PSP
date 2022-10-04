clear_col = Color.create(32, 32, 32, 255)
green_v = Color.create(0, 32, 0, 255)
purple_v = Color.create(32, 0, 32, 255)
Graphics.set_clear_color(clear_col)

white = Color.create(255, 255, 255, 255)
green = Color.create(0, 128, 0, 255)
purple = Color.create(128, 0, 128, 255)
yellow = Color.create(255, 255, 0, 255)

paddleL = 136
paddleR = 136

ballX = 240
ballY = 136

ballVX = (math.random(0, 1) - 0.5) * 300
ballVY = math.random(-10, 10) * 30

paddleTransformL = Transform.create()
paddleTransformR = Transform.create()
ball = Transform.create()
ballCheck = Transform.create()

paddleTransformL:set_scale(8, 64)
paddleTransformR:set_scale(8, 64)
ball:set_scale(8, 8)
ballCheck:set_scale(8, 8)

math.randomseed(os.time())

lLives = 5
rLives = 5

function reset_partial()
    ballX = 240
    ballY = 136
    
    ballVX = (math.random(0, 1) - 0.5) * 300
    ballVY = math.random(-10, 10) * 30

    paddleL = 136
    paddleR = 136

    paddleTransformL:set_position(24, paddleL)
    paddleTransformR:set_position(456, paddleR)
end

function reset_full()
    reset_partial()
    lLives = 5
    rLives = 5

    Graphics.set_clear_color(clear_col)
end

function update(dt)
if lLives > 0 and rLives > 0 then
    -- Move left Paddle
    if Input.button_held(PSP_UP) then
        paddleL = paddleL + dt * 272.0
    end
    if Input.button_held(PSP_DOWN) then
        paddleL = paddleL - dt * 272.0
    end

    if paddleL > 240 then
        paddleL = 240
    end
    if paddleL < 32 then
        paddleL = 32
    end

    -- Move right Paddle
    if Input.button_held(PSP_CROSS) then
        paddleR = paddleR - dt * 272.0
    end
    if Input.button_held(PSP_TRIANGLE) then
        paddleR = paddleR + dt * 272.0
    end

    if paddleR > 240 then
        paddleR = 240
    end
    if paddleR < 32 then
        paddleR = 32
    end

    paddleTransformL:set_position(24, paddleL)
    paddleTransformR:set_position(456, paddleR)

    potX = ballX + ballVX * dt
    potY = ballY + ballVY * dt
    ballCheck:set_position(potX, potY)

    if potY < 4 or potY > 268 then
        ballVY = - ballVY
    end
    if potX < -100 then
        lLives = lLives - 1
        reset_partial()
    end

    if potX > 580 then
        rLives = rLives - 1
        reset_partial()
    end

    if ballCheck:intersects(paddleTransformL) then
        ballVX = 200
        ballVY = ballVY - (paddleL - potY) * 10
    end
    if ballCheck:intersects(paddleTransformR) then
        ballVX = -200
        ballVY = ballVY - (paddleR - potY) * 10
    end

    ballX = ballX + ballVX * dt
    ballY = ballY + ballVY * dt

    ball:set_position(ballX, ballY)
else 
    if lLives == 0 then
        Graphics.set_clear_color(purple_v)
    else
        Graphics.set_clear_color(green_v)
    end 

    if Input.button_pressed(PSP_START) then
        reset_full()
    end
end
end


function draw()
    -- Draw Lives
    for i = 1, lLives, 1 do
        Primitive.draw_triangle(48 + 32 * i, 266, 12, 12, green, 0)
    end

    -- Draw Lives
    for i = 1, rLives, 1 do
        Primitive.draw_triangle(480 - 48 - 32 * i, 266, 12, 12, purple, 0)
    end

    -- Draw Paddle L
    Primitive.draw_rectangle(paddleTransformL, green)

    -- Draw Paddle R
    Primitive.draw_rectangle(paddleTransformR, purple)

    -- Draw centre line
    for i = 0, 17, 1 do
        Primitive.draw_rectangle(240, 0 + i * 16, 8, 8, white, 0)
    end

    -- Draw Ball
    Primitive.draw_circle(ball, yellow)
end

timer = Timer.create()
while(QuickGame.running()) do
    Input.update()

    update(timer:delta())

    Graphics.start_frame()
    Graphics.clear()
    
    draw()
    
    Graphics.end_frame(true)
end
