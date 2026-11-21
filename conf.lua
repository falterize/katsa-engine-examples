-- Katsa project: run it with `luajit tools/dev/katsa.lua <path to this folder or archive>` from the
-- engine folder. The engine mounts this project over its own files, so `game/` modules and
-- `assets/` (shared://) resolve here, next to the engine's shaders, fonts and fallback textures.
local Version = require('source.engine.core.version')

return {
    version = '1.0.8b', -- engine version this project was made for; a difference warns at startup
    title = 'Katsa Engine ' .. Version.release,
    identity = 'katsa-engine', -- save folder name: Katsa/<identity>; keep it stable and unique
    console = true,
    externalStorage = true,
    startScene = 'game/scenes/menu', -- the scene selection menu
    scenes = 'game/scenes', -- every scene folder inside is a scene of this project
    -- sharedAssets = { 'extra/assets', '/absolute/folder' }, -- more shared:// folders
}
