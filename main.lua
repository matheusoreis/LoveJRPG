--
-- Author: Matheus R. Oliveira
-- Github: matheusoreis
--

local Resource = require('src.managers.resource')
--- @type Resource
local resource = Resource()

local Input = require('src.managers.input')
--- @type Input
local input = Input()

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")
end

local player = { x = 100, y = 100, speed = 120 }

function love.update(dt)
  for _, joystick in ipairs(love.joystick.getJoysticks()) do
    input:updateGamepadAxes(joystick)
  end

  if input:isDown("Left") then
    player.x = player.x - player.speed * dt
  elseif input:isDown("Right") then
    player.x = player.x + player.speed * dt
  elseif input:isDown("Up") then
    player.y = player.y - player.speed * dt
  elseif input:isDown("Down") then
    player.y = player.y + player.speed * dt
  end

  input:update()
end

function love.draw()
  love.graphics.rectangle("fill", player.x, player.y, 32, 32)
end

function love.keypressed(key)
  input:keyPressed(key)
end

function love.keyreleased(key)
  input:keyReleased(key)
end

function love.gamepadpressed(_, button)
  input:gamepadPressed(button)
end

function love.gamepadreleased(_, button)
  input:gamepadReleased(button)
end
