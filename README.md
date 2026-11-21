# katsa-engine-examples

The example scenes of [Katsa](https://github.com/falterize/katsa-engine), with the scene selection
menu. It is a Katsa *project*: `conf.lua` names the start scene (`game/scenes/menu`), the scene
folder (`game/scenes`) and the window settings; `game/` holds the scenes, shared characters and the
scene catalog; `assets/` holds their models, textures, audio and tilesets.

Use the branch with the same name as your engine version (`v108.10` goes with engine `v108.10`).

## Run

Check both repositories out side by side and run from the engine folder:

```text
luajit tools/dev/katsa.lua ../katsa-engine-examples
```

The menu lists every scene; search by name or tag. A single scene also runs on its own
(`luajit tools/dev/katsa.lua ../katsa-engine-examples/game/scenes/lights`), but scenes that use plain
`assets/...` paths need the whole project. The archive of this folder (a `.zip`) works as a project
too. See the engine's [Projects and scenes](https://github.com/falterize/katsa-engine/blob/v108.10/docs/book/projects.md).

## Credits

- The Teletubby character model (`assets/models/characters/player.glb`) was made by
  [@falterize](https://github.com/falterize) and is licensed under
  [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/) (CC BY).
- `xbot.glb` is converted from Mixamo's X Bot and stays under Mixamo/Adobe's terms.
