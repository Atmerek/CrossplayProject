# The Crossplay Project Source
This repository contains the sources of both the Minecraft and Roblox sides of the crossplay.

![logo](https://crossplayproject.xyz/assets/img/logo.png)
# Minecraft Side

## Overview
The Minecraft side features the CrossplayPackage plugin; a package containing 3 of our smaller plugins.

The plugin hosts a Spark webserver on port `4567` (configurable).
## Plugin Compilation from Source

To compile the plugin from source, follow these steps:

1.**Install IntelliJ IDEA**: If you haven't already, download and install [IntelliJ IDEA](https://www.jetbrains.com/idea/).

2.**Download the CrossplayPackage Directory**: Obtain the source code directory for CrossplayPackage.

3.**Open as IntelliJ Project**:
   - Launch IntelliJ IDEA.
   - Open the CrossplayPackage directory as an IntelliJ project.

4.**Build the Plugin**:
   - Go to **Build** > **Build Artifacts** in the IntelliJ menu.
   - Select the action **Build**.

5.**Locate the Compiled JAR**:
   - After the build process completes, the compiled `.jar` file will be located in the `out/artifacts` folder within your IntelliJ project directory.

## Endpoints

### /blocks 

- **Description**: Retrieves all blocks in a specified chunk.
- **Method**: GET
- **Arguments**: chunkX (int), chunkZ (int)
- **Response**: JSON array of blocks in the chunk from height -1 to 319.

#### Example request:
```sh
curl http://<server-ip>:4567/blocks?chunkX=0&chunkZ=0
```
#### Example Response:
```json
[
    {"type":"OAK_LOG","x":7,"y":0,"z":2,"state":"minecraft:oak_log[axis\u003dy]"},
    {"type":"GRASS_BLOCK","x":7,"y":-1,"z":3,"state":"minecraft:grass_block[snowy\u003dfalse]","biome":"PLAINS"}
]
```

### /players 

- **Description**: Retrieves information about players currently on the server.
- **Method**: GET
- **Response**: JSON array of player information.

#### Example request:
```sh
curl http://<server-ip>:4567/players
```
#### Example Response:
```json
[
    {"uuid":"<UUID>","mainItem":"AIR","offItem":"AIR","x":8,"y":0,"z":1,"yaw":79,"pitch":18,"crouch":false}
]
```

### /mobs

- **Description**: Retrieves information about mobs currently present in the server.
- **Method**: GET
- **Response**: JSON array of mob information.

#### Example Request:
```sh
curl http://<server-ip>:4567/mobs
```
#### Example Response:
```json
[
    {"uuid":"<UUID>","x":6.5,"y":0.0,"z":1.5,"yaw":-90.0,"pitch":0.0,"mobType":"WANDERING_TRADER"}
]
```

### /world

- **Description**: Retrieves information about the overworld.
- **Method**: GET
- **Response**: JSON object containing overworld data such as time and weather conditions.

#### Example Request:
```sh
curl http://<server-ip>:4567/world
```
#### Example Response:
```json
{"time":22336,"thundering":false,"raining":false}
```

### /post

- **Description**: Performs various actions on the server. Supports BUILD, BREAK, TOGGLE, and EDIT actions.
- **Method**: POST
- **Actions**:
    - BUILD: Requires x, y, z, material, direction, and action.
    - BREAK: Requires x, y, z, and action.
    - TOGGLE: Requires x, y, z, and action.
    - EDIT: Requires x, y, z, line, text, and action.

#### Example Request:
```sh
curl -X POST http://<server-ip>:4567/post -d 'action=BUILD&x=0&y=0&z=0&material=STONE&direction=NORTH'
```
#### Example Data:
- For BUILD:
    ```json
    {
        "x": 0,
        "y": 0,
        "z": 0,
        "material": "STONE",
        "direction": "NORTH",
        "action": "BUILD"
    }
    ```

- For BREAK:
    ```json
    {
        "x": 0,
        "y": 0,
        "z": 0,
        "action": "BREAK"
    }
    ```

- For TOGGLE:
    ```json
    {
        "x": 0,
        "y": 0,
        "z": 0,
        "action": "TOGGLE"
    }
    ```

- For EDIT:
    ```json
    {
        "x": 0,
        "y": 0,
        "z": 0,
        "line": 2, (ranging fom 0 to 3)
        "text": "Hello, World",
        "action": "EDIT"
    }
    ```
# Roblox Side

### Overview
The Roblox side provides an example framework to help you start creating your own code. It includes several scripts and models to manage block data and interactions within Roblox.

### Files Included in the Repo

#### ServerScriptService
- **BlockHandler.lua**  
  Contains the system for fetching chunk data and cloning models into the workspace.

- **BlockBreakHandler.lua**  
  Manages POST requests for block breaking on the server side.

- **BlockPlaceHandler.lua**  
  Currently a placeholder.

- **TimeHandler.lua**  
  Contains a simple script to convert Minecraft time values and apply them.

#### ReplicatedStorage
- **BlockStateManager.lua**  
  An additional module for applying rotation to models.

- **CurrentBlocks.lua**  
  An additional module for synchronizing blocks across scripts.

- **models.rbxm**  
  Contains a folder with a few block models.

#### StarterPlayer
- **StarterPlayerScripts**:
  - **BreakBlockScript.lua**  
    Contains the local side of the block breaking system.
  - **PlaceBlockScript.lua**  
    Currently a placeholder.

#### StarterGui
- **ModifyMode.rbxm**  
  Contains a GUI button for the BreakBlockScript.lua.

## Support

For support, reach us at [our Discord](https://dc.crossplayproject.xyz).
