glance
===

Glance is a library for LÖVE that automatically caches drawing operations to a canvas.  Performing
the same sequence of rendering operations multiple times in a row will instead draw the saved
canvas, greatly reducing the amount of required draw calls.  This can improve rendering performance.

Usage
---

```lua
local glance = require 'glance'

function love.draw()
  glance.render(function()
    -- draw things!
  end)
end
```

See [`main.lua`](main.lua) for a more concrete example.

Documentation
---

- `layer = glance.layer(width, height)` - Creates a new layer with the specified `width` and
  `height`.  If the dimensions are not specified, the dimensions of the window are used.
- `layer:render(fn, ...)` - Renders to the layer using a function, only updating the canvas if
  necessary.  The canvas is then drawn to the screen, with any remaining arguments passed to
  `love.graphics.draw`.
- `glance.render(fn, ...)` - Renders to a default layer without having to explicitly create one.

Limitations
---

Glance does its best to keep track of the initial graphics state and any state changes that occur in
the render function, but there are still some limitations.  The following may lead to unexpected
results:

- Switching the active canvas (`love.graphics.setCanvas`).
- Sending values to shaders (`Shader:send`).
- Performing operations on the matrix stack (`love.graphics.translate`, `love.graphics.rotate`,
  `love.graphics.scale`).
- Drawing `Video`s, `ParticleSystem`s, or `Mesh`es.

License
---

MIT, see [`LICENSE`](LICENSE) for details.
