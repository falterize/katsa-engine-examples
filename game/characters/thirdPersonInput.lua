-- Third-person character input shared by the character scenes: move, look, jump, crouch, sprint,
-- mouse capture and the menu toggle. A scene sets `input.keyHandler(key)` for its own keys.
local Base = require('source.engine.input.input')

local Input = setmetatable({}, { __index = Base })
Input.__index = Input

local function isTouchDevice()
    local os = katsa.system.getOS()
    return os == 'Android' or os == 'iOS'
end

function Input.new(scene, player, orbit)
    local self = setmetatable(Base.new(scene, scene.controls), Input)
    self.player, self.orbit, self.captureWanted = player, orbit, true
    self.touchDevice = isTouchDevice()
    -- Touch: held Jump, toggled Run and Crouch (the on-screen buttons built by `draw`).
    self.touchHeld = { jump = false, sprint = false, crouch = false }
    self.menuKey = scene.settings.presentation.menuKey or 'tab'
    self.actions:bind('Move', { left = 'a', right = 'd', forward = 'w', back = 's' })
    self.actions:on('Move', function(_, movement, dt)
        if scene.freeDebugCamera then
            scene.camera:move(
                movement[1],
                movement[3],
                movement[2],
                dt,
                scene.controls.speed,
                scene.controls.verticalSpeed
            )
        else
            player:setMove(movement[1], movement[3])
        end
    end)
    self.actions:on('Look', function(_, look)
        if scene.freeDebugCamera then
            scene.camera:look(look[1], look[2], scene.controls.sensitivity)
        elseif self:playing() then
            orbit:look(look[1], look[2])
        end
    end)
    self.actions:on('Jump', function() end) -- The source FSM polls held Space.
    return self
end

function Input:playing()
    local scene = self.scene
    return scene.manager.focused ~= false
        and self.captureWanted
        and not scene:consume('capturesInput')
        and not scene.showStats
        and not scene.freeDebugCamera
end

function Input:update(dt)
    local playing = self:playing()
    if self.captureMouse ~= false and katsa.mouse.getRelativeMode() ~= playing then
        katsa.mouse.setRelativeMode(playing)
    end
    Base.update(self, dt)
    local input, keys = self.player.input, self.actions.keys
    local held = self.touchHeld
    input.jump = playing and (keys.space == true or held.jump)
    input.sprint = playing and (keys.lshift == true or held.sprint)
    input.crouch = playing and (keys.lctrl == true or keys.c == true or held.crouch)
    input.shiftlock = playing and keys.q == true
    if not playing then
        self.player:setMove(0, 0)
    end
end

function Input:press(id, x, y)
    if id == 'mouse' and katsa.mouse.getRelativeMode() and self:playing() then
        return
    end
    Base.press(self, id, x, y)
end

function Input:move(id, x, y, dx, dy)
    if id == 'mouse' and katsa.mouse.getRelativeMode() and self:playing() then
        self.actions:look(dx, dy)
        return
    end
    Base.move(self, id, x, y, dx, dy)
end

function Input:toggleMenu()
    self.captureWanted = not self.captureWanted
    self:reset()
    self.player:setMove(0, 0)
    local input = self.player.input
    input.jump, input.sprint, input.crouch, input.shiftlock = false, false, false, false
    self.scene:emit('immersion', self.captureWanted)
    if self.menuButton then
        self.menuButton.text = self.captureWanted and 'Engine menu' or 'Resume game'
    end
    if self.captureMouse ~= false then
        katsa.mouse.setRelativeMode(self:playing())
    end
end

function Input:keypressed(key)
    if key == self.menuKey then
        self:toggleMenu()
        return
    end
    -- A scene hooks its own keys here; returning true keeps the key from the engine.
    if self.keyHandler and self.keyHandler(key) then
        return
    end
    Base.keypressed(self, key)
end

function Input:wheelmoved(_, y)
    if not self:playing() then
        return false
    end
    self.orbit:zoom(y)
    return true
end

local function touchButton(ui, text, position, size, color)
    local node = ui:button({
        position = position,
        size = size,
        anchorPoint = { 1, 0 },
        text = text,
        fontSize = 18,
        backgroundColor = color,
    }, ui.content)
    ui:create('UICorner', { radius = { 0, 10 } }, node)
    return node
end

-- A phone has no keyboard: Jump (held), Run and Crouch (toggles) sit at the bottom right.
function Input:buildTouchButtons()
    local ui = self.scene.root:find('World3D/World2D')
    local off, on = { 0.12, 0.3, 0.45 }, { 0.2, 0.55, 0.3 }
    local held = self.touchHeld
    local function hold(node, key)
        node:connect('press', function() held[key] = true end)
        node:connect('release', function() held[key] = false end)
        node:connect('cancel', function() held[key] = false end)
    end
    local function toggle(node, key, label)
        node:connect('press', function()
            held[key] = not held[key]
            node.text = label .. (held[key] and ': ON' or ': OFF')
            node.backgroundColor = held[key] and on or off
        end)
    end
    local jump = touchButton(ui, 'Jump', { 1, -16, 1, -150 }, { 0, 120, 0, 64 }, off)
    hold(jump, 'jump')
    local run = touchButton(ui, 'Run: OFF', { 1, -16, 1, -222 }, { 0, 120, 0, 56 }, off)
    toggle(run, 'sprint', 'Run')
    local crouch = touchButton(ui, 'Crouch: OFF', { 1, -176, 1, -150 }, { 0, 150, 0, 64 }, off)
    toggle(crouch, 'crouch', 'Crouch')
    self.touchButtons = { jump, run, crouch }
end

-- The desktop game has no overlay; on phones the engine joystick and the touch buttons appear.
function Input:draw()
    if not self.touchDevice then
        return
    end
    Base.draw(self)
    if not self.touchButtons then
        self:buildTouchButtons()
    end
end

return Input
