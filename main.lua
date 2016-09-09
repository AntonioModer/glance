local glance = require 'glance'

function love.draw()
  love.graphics.setColor(180, 0, 255)
  love.graphics.setLineWidth(3)

  glance.render(function()
    for y = 0, love.graphics.getHeight(), 20 do
      for x = 0, love.graphics.getWidth(), 20 do
        local mx, my = love.mouse.getPosition()
        local dx, dy = mx - x, my - y
        local distance = (dx ^ 2 + dy ^ 2) ^ .5
        local x = x + dx * math.min(100 / distance, 1)
        local y = y + dy * math.min(100 / distance, 1)
        love.graphics.circle('line', x, y, 10)
      end
    end
  end)

  love.graphics.setColor(255, 255, 255)
  love.graphics.print('draw calls: ' .. love.graphics.getStats().drawcalls)
end
