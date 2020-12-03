# Vision for Zig SHOWDOWN

**Note: This document right now is the vision of [xq](https://github.com/MasterQ32/), please PR or discuss changes!**

The goal is to create a game similar to [OpenArena](http://www.openarena.ws/page.php?2), which is a game similar to oldschool shooters like Quake.

The game should feature the following:
- Multiplayer Gameplay
  - Free for all
- Multiple maps
  - requires map selection screen
- dedicated and in-game hosted servers
- Singleplayer "training mode"

On the road to the final game, all components should be written and Zig and create a nice starting point and set of libraries for other programmers to create game in Zig.

Multiple rendering backends are there to exercise the windowing library and pave a way for Zig to support Vulkan, OpenGl, Metal, DX12 and other rendering technologies.

The rendering of the game is not meant to be AAA quality, but should have some basic features depending on each backend:
- OpenGL, Vulkan: At least provide a single global shadow map for the sun, and a mirroring surface for water levels
- Software: Be as efficient as possible, but do not sacrifice basic features like texture mapping

The game logic itself does not implement shaders, but passes "materials" or "effects" to the rendering backend which then decides if the effect will be rendered or not.
The list of possible effects is predefined and cannot be expanded by levels or models, this makes implementing multiple rendering backends easier and allows different rendering techniques as well (think Raytracing, Raymarching).

The multi-platform support shows that excellent and painless Zig cross-compilation features, every target platform should be compilable from any other platform. 

We should at least provide 2 different levels:
- classic "indoor"
  - doors
  - elevators
  - glass walls
- classic "outdoor"
  - foliage
  - skybox
  - terrain/heightmap level

The game has a classic health model (100 health, weapons do different, but predictable damage, when health drops to or below 0, player dies).

The game should feature various weapons and items to collect:
- Different health kits (10, 25, 50, 100)
- Super-Charge Mode ("quad damage")
- Railgun (heavy damage, no spread, long reload time)
- Melee Weapon (heavy damage, short range)
- Shotgun (medium damage, short range, heavy spread)
- Machine Gun (light damage, medium range, high fire rate)
- Jetpack (allows temporary flight)
- Rocket Launcher (huge damage, slow projectiles, slow fire, low ammo)
- Grenade Launcher (heavy damage, bouncing projectiles, quick fire, low ammo)

Also a instagib mode should be provided for fun and easy balancing.