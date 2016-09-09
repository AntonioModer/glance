local glance = {}

local graphics = love.graphics

local graphicsFunctions = {
  'arc',
  'circle',
  'clear',
  'discard',
  'draw',
  'ellipse',
  'line',
  'points',
  'polygon',
  'print',
  'printf',
  'rectangle',
  'stencil',
  'setBlendMode',
  'setColor',
  'setColorMask',
  'setFont',
  'setLineJoin',
  'setLineStyle',
  'setLineWidth',
  'setPointSize',
  'setScissor',
  'setStencilTest'
}

local function getGraphicsState()
  local r, g, b, a = graphics.getColor()
  local rm, gm, bm, am = graphics.getColorMask()
  local blend = graphics.getBlendMode()
  local canvas = graphics.getCanvas()
  local font = graphics.getFont()
  local lineJoin = graphics.getLineJoin()
  local lineStyle = graphics.getLineStyle()
  local lineWidth = graphics.getLineWidth()
  local x, y, w, h = graphics.getScissor()
  local shader = graphics.getShader()
  local stencilMode, stencilValue = graphics.getStencilTest()
  return {
    r, g, b, a,
    rm, gm, bm, am,
    blend,
    canvas or 'none',
    font,
    lineJoin,
    lineStyle,
    lineWidth,
    x or -1, y or -1, w or -1, h or -1,
    shader or 'none',
    stencilMode, stencilValue
  }
end

local function eq(t1, t2)
  if #t1 ~= #t2 then return false end

  for i = 1, #t1 do
    if t1[i] ~= t2[i] then return false end
  end

  return true
end

function glance.layer(w, h)
  local layer = {}

  layer.canvas = graphics.newCanvas(w, h)
  layer.render = glance.render

  layer.graphics = setmetatable({}, { __index = graphics })
  for _, fn in ipairs(graphicsFunctions) do
    layer.graphics[fn] = function(...)
      local key = { fn, ... }

      if not layer.dirty then
        if not layer.old[#layer.new + 1] then
          layer.dirty = true
        else
          local target = layer.old[#layer.new + 1]
          layer.dirty = not eq(key, layer.old[#layer.new + 1])
        end
      end

      table.insert(layer.new, key)
    end
  end

  return layer
end

function glance.render(layer, fn, ...)
  if type(layer) == 'function' then
    glance.default = glance.default or glance.layer()
    fn = layer
    layer = glance.default
  end

  local r, g, b, a = graphics.getColor()

  layer.old = layer.new or { getGraphicsState() }
  layer.new = { getGraphicsState() }
  layer.dirty = not eq(layer.old[1], layer.new[1])

  love.graphics = layer.graphics
  fn()
  love.graphics = graphics

  if layer.dirty then
    graphics.setCanvas(layer.canvas)
    graphics.clear(0, 0, 0, 0)
    fn()
    graphics.setCanvas()
  end

  graphics.setColor(r, g, b, a)
  graphics.draw(layer.canvas, ...)
end

return glance
