package xyz.crossplayproject;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import org.bukkit.Bukkit;
import org.bukkit.Chunk;
import org.bukkit.ChunkSnapshot;
import org.bukkit.Material;
import org.bukkit.block.Biome;
import org.bukkit.block.data.BlockData;
import spark.Service;

import java.util.EnumSet;
import java.util.Set;

public class BlockHandler {

    private final Gson gson = new Gson();
    private final Set<Material> biomeSensitiveBlocks = EnumSet.of(
            Material.GRASS_BLOCK, Material.SHORT_GRASS, Material.TALL_GRASS,
            Material.FERN, Material.LARGE_FERN
    );

    public void setupRoutes(Service spark) {
        spark.get("/blocks", (request, response) -> {
            try {
                String chunkXParam = request.queryParams("chunkX");
                String chunkZParam = request.queryParams("chunkZ");

                if (chunkXParam == null || chunkZParam == null) {
                    response.status(400);
                    response.type("application/json");
                    return "Chunk parameters not found";
                }

                String[] chunkXParts = chunkXParam.split(",");
                String[] chunkZParts = chunkZParam.split(",");

                int[] chunkXValues = new int[2];
                int[] chunkZValues = new int[2];

                if (chunkXParts.length == 1) {
                    int singleX = Integer.parseInt(chunkXParts[0]);
                    chunkXValues[0] = singleX;
                    chunkXValues[1] = singleX;
                } else if (chunkXParts.length == 2) {
                    int minX = Integer.parseInt(chunkXParts[0]);
                    int maxX = Integer.parseInt(chunkXParts[1]);
                    chunkXValues[0] = Math.min(minX, maxX);
                    chunkXValues[1] = Math.max(minX, maxX);
                } else {
                    response.status(400);
                    response.type("application/json");
                    return "Invalid chunkX parameter format";
                }

                if (chunkZParts.length == 1) {
                    int singleZ = Integer.parseInt(chunkZParts[0]);
                    chunkZValues[0] = singleZ;
                    chunkZValues[1] = singleZ;
                } else if (chunkZParts.length == 2) {
                    int minZ = Integer.parseInt(chunkZParts[0]);
                    int maxZ = Integer.parseInt(chunkZParts[1]);
                    chunkZValues[0] = Math.min(minZ, maxZ);
                    chunkZValues[1] = Math.max(minZ, maxZ);
                } else {
                    response.status(400);
                    response.type("application/json");
                    return "Invalid chunkZ parameter format";
                }

                JsonArray blockArray = new JsonArray();

                for (int chunkX = chunkXValues[0]; chunkX <= chunkXValues[1]; chunkX++) {
                    for (int chunkZ = chunkZValues[0]; chunkZ <= chunkZValues[1]; chunkZ++) {
                        Chunk chunk = Bukkit.getWorlds().get(0).getChunkAt(chunkX, chunkZ);
                        ChunkSnapshot chunkSnapshot = chunk.getChunkSnapshot(false, true, false);

                        for (int x = 0; x < 16; x++) {
                            for (int z = 0; z < 16; z++) {
                                for (int y = -1; y <= 319; y++) {
                                    Material material = chunkSnapshot.getBlockType(x, y, z);
                                    if (material.isAir()) {
                                        continue;
                                    }
                                    JsonObject blockInfo = new JsonObject();
                                    blockInfo.addProperty("type", material.toString());
                                    blockInfo.addProperty("x", x + chunk.getX() * 16);
                                    blockInfo.addProperty("y", y);
                                    blockInfo.addProperty("z", z + chunk.getZ() * 16);

                                    BlockData blockData = chunkSnapshot.getBlockData(x, y, z);
                                    blockInfo.addProperty("state", blockData.getAsString());

                                    if (biomeSensitiveBlocks.contains(material)) {
                                        Biome biome = chunkSnapshot.getBiome(x, y, z);
                                        blockInfo.addProperty("biome", biome.toString());
                                    }

                                    blockArray.add(blockInfo);
                                }
                            }
                        }
                    }
                }

                response.type("application/json");
                return gson.toJson(blockArray);
            } catch (NumberFormatException e) {
                response.status(400);
                response.type("application/json");
                return "Chunk parameter is not an integer";
            }
        });
    }
}
