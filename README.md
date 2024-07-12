# The Crossplay Project Source
This repository contains the source code for both the Minecraft and Roblox sides of the Crossplay Project.

![logo](https://crossplayproject.xyz/assets/img/logo.png)
# Minecraft Side

## Overview
The Minecraft side features the CrossplayPackage plugin; a package containing 5 of our smaller plugins.

The plugin hosts a Spark webserver on port `4567` (configurable).

## Plugin Compilation from Source

To compile the plugin from source, follow these steps:

1. **Install IntelliJ IDEA**: If you haven't already, download and install [IntelliJ IDEA](https://www.jetbrains.com/idea/).

2. **Download the CrossplayPackage Directory**: Obtain the source code directory for CrossplayPackage.

3. **Open as IntelliJ Project**:
   - Launch IntelliJ IDEA.
   - Open the CrossplayPackage directory as an IntelliJ project.

4. **Build the Plugin**:
   - Go to **Build** > **Build Artifacts** in the IntelliJ menu.
   - Select the action **Build**.

5. **Locate the Compiled JAR**:
   - After the build process completes, the compiled `.jar` file will be located in the `out/artifacts` folder within your IntelliJ project directory.

## Endpoints

### /blocks 

- **Description**: Retrieves all blocks in specified chunk(s).
- **Method**: GET
- **Arguments**: chunkX and chunkZ OR cord1 and cord2.
- **Response**: JSON array of blocks in the chunk from height -1 to 319.

#### Example request for a single chunk:
```sh
curl http://<server-ip>:4567/blocks?chunkX=0&chunkZ=0
```

#### Example request for multiple chunks (3x3 grid with center at 0,0):
```sh
curl http://<server-ip>:4567/blocks?chunkX=-1,1&chunkZ=-1,1
```

#### Example request for an exact area:
```sh
curl http://<server-ip>:4567/blocks?cord1=15,0,15&cord2=-15,25,-15
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
{"time":6000,"thundering":false,"raining":false}
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
        "line": 2, (ranging from 0 to 3)
        "text": "Hello, World",
        "action": "EDIT"
    }
    ```

### /chat

- **Description**: Accepts and provides chat messages from and to Roblox.
- **Method**: GET, POST
#### Example response:
```json
[{"sender":"The_Atmerek","message":"Hi"},{"sender":"The_Atmerek","message":"Hello"}]
```

#### Example payload:
```json
{
    "player": "wwwdr666",
    "color": "#FFFFFF",
    "message": "Hewoo~"
}
```

### /npc

- **Description**: Accepts data to spawn an NPC in-game.
- **Method**: POST

#### Example payload:
```json
{
    "x": 0,
    "y": 0,
    "z": 0,
    "yaw": 90,
    "pitch": 45,
    "disconnect": true (optional)
}
```

# Roblox Side

### Overview
The Roblox side provides a framework to help you start creating your own code. It includes several scripts and models to manage block data and interactions within Roblox.

### Roblox files and scripts:

#### Workspace
- **Blocks**  
  A folder to store block models.
- **Players**  
  A folder to store player models.

#### ServerScriptService
- **BlockHandler.lua**  
  Contains the system for fetching chunk data and cloning models into the workspace.

- **BlockBreakHandler.lua**  
  Manages POST requests for block breaking on the server side.

- **BlockPlaceHandler.lua**  
  Manages POST requests for block placing on the server side.

- **PlayerHandler.lua**  
  Manages the Minecraft players in Roblox.

- **NPCHandler.lua**  
  Manages the Roblox players in Minecraft.

- **TimeHandler.lua**  
  Contains a script to convert Minecraft time values and apply them.

- **ChatHandler.lua**  
  Manages in and out messages.

- **ImageAuth.lua**  
  An authentication script for the remote_img library.

#### ReplicatedStorage
- **models.rbxm**  
  Contains a folder with a few block models.

- **IP.rbxm**  
  Contains a text value with the server IP.

- **BlockStateManager.lua**  
  An additional module for applying rotation to models.

- **CurrentBlocks.lua**  
  An additional module for synchronizing blocks across scripts.

- **Chat.rbxm**  
  A RemoteEvent for the chat messages.

- **loadPlayerSkin.rbxm**  
  A RemoteEvent for applying player skins.

- **remote_img.rbxm**  
  A module library for managing EditableImage.

- **Player.rbxm**  
  A model of the Minecraft player.

#### StarterPlayer
- **StarterPlayerScripts**:
  - **BreakBlockScript.lua**  
    Contains the local side of the block breaking system.
  - **PlaceBlockScript.lua**  
    Contains the local side of the block placing system.
  - **Chat.lua**  
    Contains the local side of the chat system.
  - **SkinLoader.lua**  
    Contains the local side of the skin system.

#### StarterGui
- **ModifyMode.rbxm**  
  Contains two GUI buttons for the action scripts.

# Our API

We provide an API to resolve Minecraft player's usernames and skins by their UUIDs. The API supports both Java and Bedrock (floodgate) UUIDs.

## Get Username by UUID

**Endpoint**: `/api/uuid/:uuid`

- **Method**: GET
- **Description**: Retrieves the username associated with the provided UUID.
- **Parameters**:
  - `uuid` (string): The UUID of the Minecraft player. Supports both Java and Bedrock UUIDs.

**Example Request**:
```sh
curl https://crossplayproject.xyz/api/uuid/92270a4f-f954-4087-a932-e8d0e5deb2bd
```

**Example Response**:
```json
{
    "username":"The_Atmerek"
}
```

## Get Skin by UUID

**Endpoint**: `/api/uuid/:uuid/skin`

- **Method**: GET
- **Description**: Retrieves the skin associated with the provided UUID.
- **Parameters**:
  - `uuid` (string): The UUID of the Minecraft player. Supports both Java and Bedrock UUIDs.

**Example Request**:
```sh
curl https://crossplayproject.xyz/api/uuid/92270a4f-f954-4087-a932-e8d0e5deb2bd/skin
```

**Response**: Returns the skin image in PNG format.

# Demo

We provide a demo server for you to test the plugin without needing to set up a server yourself.

- **Demo Server IP**: `demo.crossplayproject.xyz`
- **API Base URL**: `https://crossplayproject.xyz/demo/`

To use the endpoints, append the endpoint name to the base URL. For example, to access the `/players` endpoint, use `https://crossplayproject.xyz/demo/players`.

# Support

For support, reach us at [our Discord](https://dc.crossplayproject.xyz).
