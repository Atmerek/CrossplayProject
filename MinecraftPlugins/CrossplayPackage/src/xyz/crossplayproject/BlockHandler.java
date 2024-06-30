package xyz.crossplayproject;

import org.bukkit.Bukkit;
import org.bukkit.Chunk;
import org.bukkit.ChunkSnapshot;
import org.bukkit.Material;
import org.bukkit.block.Biome;
import org.bukkit.block.data.BlockData;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
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
                    return "Chunk parameter not found";
                }

                int chunkX = Integer.parseInt(chunkXParam);
                int chunkZ = Integer.parseInt(chunkZParam);

                Chunk chunk = Bukkit.getWorlds().get(0).getChunkAt(chunkX, chunkZ);
                JsonArray blockArray = new JsonArray();

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