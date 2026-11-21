-- Katsa project: run it with `luajit tools/dev/katsa.lua <path to this folder or archive>` from the
-- engine folder. The engine mounts this project over its own files, so `game/` modules and `assets/`
-- (shared://) resolve here, next to the engine's shaders, fonts and fallback textures.
local Config = require('source.engine.core.windowConfig')
local project = require('game.data.project')

function katsa.conf(settings)
    Config.apply(settings, project)
    settings.startScene = 'game/scenes/menu' -- the scene selection menu
    settings.scenes = 'game/scenes' -- every scene folder inside is a scene of this project
    -- settings.sharedAssets = { 'extra/assets', '/absolute/folder' } -- more shared:// folders
end
