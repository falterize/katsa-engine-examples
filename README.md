# katsa-engine-examples

The example scenes of [Katsa](https://github.com/falterize/katsa-engine), with the scene selection
menu. It is a Katsa *project*: its `conf.lua` (a table, see the engine's `docs/book/conf.md`) names the
start scene (`game/scenes/menu`), the scene folder (`game/scenes`) and the window settings; `game/` holds the scenes, shared characters and the
scene catalog; `assets/` holds their models, textures, audio and tilesets.

Use the branch with the same name as your engine version (`v109` goes with engine `v109`).

## Run

Check both repositories out side by side and run from the engine folder:

```text
luajit tools/dev/katsa.lua ../katsa-engine-examples
```

The menu lists every scene; search by name or tag. A single scene (its own `conf.lua` and `main.lua`) also runs on its own
(`luajit tools/dev/katsa.lua ../katsa-engine-examples/game/scenes/lights`), but scenes that use plain
`assets/...` paths need the whole project. The archive of this folder (a `.zip`) works as a project
too. See the engine's [Projects and scenes](https://github.com/falterize/katsa-engine/blob/v109/docs/book/projects.md).

## Credits

- The Teletubby character model (`assets/models/characters/player.glb`) was made by
  [@falterize](https://github.com/falterize) and is licensed under
  [Creative Commons Attribution 4.0](https://creativecommons.org/licenses/by/4.0/) (CC BY).
- `xbot.glb` is converted from Mixamo's X Bot and stays under Mixamo/Adobe's terms.

## Asset notices

| Asset | License / status |
| --- | --- |
| Generated `colliderMask.png` | CC0 1.0; procedurally generated for collider demonstrations |
| Eight supplied v33 images | Original license unspecified; not relicensed as MIT |
| Supplied Stare Shooter model, textures, images and adapted game/shader content | Original license unspecified; imported user content is not relicensed as MIT |
| Generated WAV, OBJ and GLB assets | CC0 1.0; embedded supplied textures retain their original status |

Scene code is MIT like the engine. The engine's own dependency notices live in its
[licenses guide](https://github.com/falterize/katsa-engine/blob/v109/docs/guides/development/licenses.md).
