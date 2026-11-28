local ipairs = require('source.engine.math.array').ipairs

local Interface = {}

function Interface.create(self)
    for _, panel in ipairs(self.panels) do
        local ui = panel.ui
        local frame =
            ui:container({ size = { 1, 0, 1, 0 }, backgroundColor = { 0.08, 0.15, 0.23 } }, panel)
        ui:create('UICorner', { radius = { 0, 20 } }, frame)
        ui:create('Ramp', {
            rotation = 45,
            points = {
                { time = 0, value = { 0.08, 0.22, 0.35, 1 } },
                {
                    time = 1,
                    value = { 0.2, 0.1, 0.3, 1 },
                },
            },
        }, frame)
        ui:create(
            'UIStroke',
            { target = 'Border', thickness = { 0, 3 }, color = { 0.4, 0.8, 1 } },
            frame
        )
        ui:text({
            position = { 0.5, 0, 0.25, 0 },
            size = { 0.9, 0, 0.28, 0 },
            anchorPoint = { 0.5, 0.5 },
            text = panel.name,
            textScaled = true,
            maxTextSize = 40,
        }, frame)
        local b = ui:button({
            position = { 0.5, 0, 0.68, 0 },
            size = { 0.85, 0, 0.28, 0 },
            anchorPoint = { 0.5, 0.5 },
            text = 'Press / touch',
            textScaled = true,
            maxTextSize = 30,
            backgroundColor = { 0.2, 0.45, 0.6 },
        }, frame)
        b:connect('press', function()
            self.clicks = self.clicks + 1
        end)
        ui:create('UICorner', { radius = { 0, 14 } }, b)
        ui:create('UIStroke', { target = 'Text', thickness = { 0, 1 }, color = { 0, 0, 0 } }, b)
    end
    self.overlay.ui:text({
        size = { 1, 0, 1, 0 },
        text = 'onTop = true',
        backgroundColor = { 0.5, 0.16, 0.1 },
        backgroundTransparency = 0.2,
        textScaled = true,
    }, self.overlay)
    local board = self.attachmentBoard
    self.attachmentTitle = board.ui:text({
        position = { 0, 8, 0, 4 },
        size = { 1, -16, 0, 36 },
        text = 'Attachment3D / Support offset',
        textScaled = true,
        maxTextSize = 24,
        backgroundColor = { 0.04, 0.11, 0.16 },
    }, board)
    self.attachmentButton = board.ui:button({
        position = { 0, 8, 0, 44 },
        size = { 1, -16, 0, 60 },
        text = 'Clicks: 0',
        textScaled = true,
        maxTextSize = 22,
        backgroundColor = { 0.1, 0.32, 0.4 },
    }, board)
    self.attachmentButton:connect('press', function()
        self.attachmentClicks = self.attachmentClicks + 1
        self.attachmentButton.text = 'Clicks: ' .. self.attachmentClicks
    end)
    do
        local node = board.ui:button({
            position = { 0, 8, 0, 110 },
            size = { 1, -16, 0, 60 },
            text = 'Switch offset',
            textScaled = true,
            maxTextSize = 20,
            backgroundColor = { 0.13, 0.2, 0.32 },
        }, board)
        node:connect('press', function()
            self.offsetMode = self.offsetMode == 'Support' and 'World3D' or 'Support'
            board.offset = self.offsetMode == 'Support' and { 0, 18, 0 } or { 0, 0, 0 }
            board.offsetWorldSpace = self.offsetMode == 'World3D' and { 0, 18, 0 } or { 0, 0, 0 }
            self.attachmentTitle.text = 'Attachment3D / ' .. self.offsetMode .. ' offset'
        end)
    end
    -- VideoFrame on a SurfaceUI (the TV), a BillboardUI (floating) and the screen (corner). One
    -- clip, one sound: the TV plays it with sound, the others are muted.
    local clip = 'scene://video/demo.mp4'
    self.videos = {}
    local function addVideo(parent, settings)
        settings.source, settings.looped, settings.playing = clip, true, true
        local video = parent.ui:video(settings, parent)
        self.videos[#self.videos + 1] = video
        return video
    end
    local screen = self.videoScreen.ui:container(
        { size = { 1, 0, 1, 0 }, backgroundColor = { 0, 0, 0 } },
        self.videoScreen
    )
    self.tvVideo = addVideo(screen, { name = 'TvVideo', size = { 1, 0, 1, 0 }, volume = 0.6 })
    local floating = self.videoBillboard.ui:container(
        { size = { 1, 0, 1, 0 }, backgroundColor = { 0.04, 0.11, 0.16 }, clip = true },
        self.videoBillboard
    )
    self.videoBillboard.ui:create('UICorner', { radius = { 0, 18 } }, floating)
    addVideo(floating, {
        name = 'BillboardVideo',
        position = { 0, 8, 0, 8 },
        size = { 1, -16, 1, -16 },
        volume = 0,
    })
    local ui = self.scene.root:find('World3D/World2D')
    local controls = ui:container({
        _viewportAuthored = true,
        name = 'SurfaceControls',
        visible = false,
        position = { 0, 12, 0, 112 },
        size = { 0, 260, 0, 246 },
    }, ui.content)
    require('source.engine.ui.widgets.collapsible').create(self.scene, controls, 'Surface controls')
    do
        local node = ui:button({
            position = { 0, 4, 0, 4 },
            size = { 1, -8, 0, 44 },
            text = 'Decal3D size: 75% / 40%',
            textScaled = true,
            maxTextSize = 18,
            backgroundColor = { 0.1, 0.25, 0.35 },
        }, controls)
        node:connect('press', function()
            local factor = self.litter.size[1] == 0.75 and 0.4 or 0.75
            self.litter.size = { factor, 0, factor, 0 }
        end)
    end
    do
        local node = ui:button({
            position = { 0, 4, 0, 54 },
            size = { 1, -8, 0, 42 },
            text = 'Panel extent: support / fixed',
            textScaled = true,
            maxTextSize = 16,
            backgroundColor = { 0.1, 0.25, 0.35 },
        }, controls)
        node:connect('press', function()
            self.extentFixed = not self.extentFixed
            board.extentsOffset = self.extentFixed and { 0, 0, 0 } or { 0, 1, 0 }
            board.extentsOffsetWorldSpace = self.extentFixed and { 0, 1, 0 } or { 0, 0, 0 }
        end)
    end
    -- A third VideoFrame on the screen itself, in the corner.
    do
        local corner = ui:video({
            name = 'ScreenVideo',
            _viewportAuthored = true,
            position = { 1, -12, 1, -90 },
            anchorPoint = { 1, 1 },
            size = { 0, 192, 0, 108 },
            source = clip,
            looped = true,
            playing = true,
            volume = 0,
            fitMode = 'Fit',
            backgroundColor = { 0, 0, 0 },
        }, ui.content)
        ui:create('UICorner', { radius = { 0, 12 } }, corner)
        corner.clip = true
        self.videos[#self.videos + 1] = corner
    end
    do
        local node = ui:button({
            position = { 0, 4, 0, 148 },
            size = { 1, -8, 0, 42 },
            text = 'Video: play / pause',
            textScaled = true,
            maxTextSize = 16,
            backgroundColor = { 0.1, 0.25, 0.35 },
        }, controls)
        node:connect('press', function()
            local playing = not self.videos[1].playing
            for _, video in ipairs(self.videos) do
                video.playing = playing
            end
        end)
    end
    do
        local node = ui:button({
            position = { 0, 4, 0, 196 },
            size = { 1, -8, 0, 42 },
            text = 'Video: sound / seek 0',
            textScaled = true,
            maxTextSize = 16,
            backgroundColor = { 0.1, 0.25, 0.35 },
        }, controls)
        node:connect('press', function()
            self.tvVideo.volume = self.tvVideo.volume > 0 and 0 or 0.6
            for _, video in ipairs(self.videos) do
                video.time = 0
            end
        end)
    end
    do
        local node = ui:button({
            position = { 0, 4, 0, 100 },
            size = { 1, -8, 0, 42 },
            text = 'Panel tilt: on / off',
            textScaled = true,
            maxTextSize = 16,
            backgroundColor = { 0.1, 0.25, 0.35 },
        }, controls)
        node:connect('press', function()
            board.rotation = board.rotation[1] == 0 and { 12, 20, 8 } or { 0, 0, 0 }
        end)
    end
    self.status = self.scene.root:find('World3D/World2D'):text({
        position = { 0.5, 0, 1, -35 },
        size = { 1, -24, 0, 48 },
        anchorPoint = { 0.5, 0.5 },
        text = 'Walk around the six local faces. Touch a panel.',
        fontSize = 20,
    }, self.scene.root:find('World3D/World2D').content)
end

return Interface
