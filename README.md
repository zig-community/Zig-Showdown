# Zig-Showdown
A community effort to create a small multiplayer 3D shooter game in pure zig

## Development

### Communication

The main communication happens via the [Zig Showtime](https://discord.gg/p4bUwnf92n) discord. Please join if you want to participate!

### Asset Building

Assets are spread over 3 different folders:
- `assets`: Contains the final assets that will be shipped with the game. This folder is completly auto-generated and the folder is not included in the repository.
- `assets-in`: Intermediate asset files in commonly editable formats like png, obj. These files get compiled in the `zig build assets` step into a file into `assets`.
- `assets-src`: Source formats for the files that are from the original editor. Files here are for example blender or gimp project files.

When invoking `zig build assets`, the build system will search for files in `assets-in` and will translate them into the game-custom format which are stored in `assets`.

Assets that don't need to be converted will just be copied flat into the `assets` folder.

#### Translation Table

This table lists all implemented (or planned) asset file associations:

| Input File | Target File Extension | Resource Type |
|------------|-----------------------|---------------|
| `*.png`    | `.tex`                | `Texture`     |
| `*.tga`    | `.tex`                | `Texture`     |
| `*.bmp`    | `.tex`                | `Texture`     |
| `*.obj`    | `.mdl`                | `Model`       |
| `*.wav`    | `.snd`                | `Sound` (https://github.com/zig-community/Zig-Showdown/issues/9)  |
| `*.ogg`    | `.mus`                | `Music` (https://github.com/zig-community/Zig-Showdown/issues/11) |

### Contribution

### Checkout

Clone the repo and all submodules:
```sh
git clone https://github.com/zig-community/Zig-Showdown --recursive
```

### Committing

Feel free to create a PR to this repo, but please make sure you've run `zig fmt` on your files to keep a consistent state.

### Build

```sh
# Use this to build the project
zig build assets install

# Use this to run the game in a debug session
zig build assets run
```

Recommended to be built with the latest master, but Zig 0.7.0 should be fine.

The following build targets are available:

- `install`: Build the software, but without assets
- `assets`: Compile all assets into the required format. This is a pretty lengthy step, so use only when required: This is only necessary once or when assets are changed. Source code changes usually do not require this.
- `tools`: This only compiles the tools to preprocess assets, but does not update the assets.
- `run`: Starts the game client.
- `run-server`: Starts a dedicated server.
- `test`: Runs tests on both server and client software

The following build options are available:

| Option               | Allowed Values | Default Value      | Effect                     |
|----------------------|----------------|--------------------|----------------------------|
| `default_port`       | `u16`          | 3315               | Sets the default game port |
| `initial_state`      | `create_server`, `create_sp_game`, `credits`, `gameplay`, `join_game`, `main_menu`, `options`, `pause_menu`, `splash`  | `splash` | Sets the initial state of the game, changing where the game starts. This allows improved debugging for stuff like `gameplay` or `options` where waiting for the normal game flow to finish is too long. |
| `enable-fps-counter` | `bool`         | `true` when Debug  | When enabled, displays a text that shows frame time in ms and frame rate in fps. |
| `embed-resources`    | `bool`         | `false`            | When enabled, the `assets` folder is embedded into the final executable, creating a single-file game. |
| `renderer`           | `software`, `opengl` | `software` | Sets the given value as the rendering backend for the game. This allows to exchange the used graphics APIs. |
| `jack`               | `bool`         | `false`            | Enables the JACK audio backend |
| `pulseaudio`         | `bool`         | Enabled on Linux   | Enables the PulseAudio audio backend |
| `alsa`               | `bool`         | Enabled on Linux   | Enables the ALSA audio backend |
| `coreaudio`          | `bool`         | Enabled on MacOS   | Enables the CoreAudio audio backend |
| `wasapi`             | `bool`         | Enabled on Windows | Enables the WASAPI audio backend |
| `debug-tools`        | `bool`         | `false`            | Tools are usually built in `ReleaseSafe` mode for performance, but when working on the tools, it's better to compile them in `Debug` mode. Setting this flag does this. |

### OpenGL Loader

You need [zig-opengl](https://github.com/MasterQ32/zig-opengl) to regenerate the binding:

```sh
# assuming we are in the project repository:
SHOWDOWN_ROOT=$(pwd)

# Prepare the opengl generator
cd /path/to/zig-opengl
make generator.exe

# Create our OpenGL 3.3 + GL_ARB_direct_state_access
mono generator.exe OpenGL-Registry/xml/gl.xml $(SHOWDOWN_ROOT)/deps/opengl/gl_3v3_with_exts.zig GL_VERSION_3_3 GL_ARB_direct_state_access GL_KHR_debug
```