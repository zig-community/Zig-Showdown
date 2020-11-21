# Zig-Showdown
A community effort to create a small multiplayer 3D shooter game in pure zig

## Development

### Communication

The main communication happens via the [Zig Showtime](https://zig.show/) discord.

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

| Option               | Allowed Values | Default Value     | Effect                     |
|----------------------|----------------|-------------------|----------------------------|
| `default_port`       | `u16`          | 3315              | Sets the default game port |
| `initial_state`      | `create_server`,`create_sp_game`,`credits`,`gameplay`,`join_game`,`main_menu`,`options`,`pause_menu`,`splash` | `splash` | Sets the initial state of the game, changing where the game starts. This allows improved debugging for stuff like `gameplay` or `options` where waiting for the normal game flow to finish is too long. |
| `enable-fps-counter` | `bool`         | `true` when Debug | When `true` displays a text that shows frame time in ms and frame rate in fps. |