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
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.stream.IntStream;

public class BlockHandler {

    private final Gson gson = new Gson();
    private final Set<Material> biomeSensitiveBlocks = EnumSet.of(
            Material.GRASS_BLOCK, Material.SHORT_GRASS, Material.TALL_GRASS,
            Material.FERN, Material.LARGE_FERN
    );

    public void setupRoutes(Service spark) {
        spark.get("/blocks", (request, response) -> {
            try {
                String cord1Param = request.queryParams("cord1");
                String cord2Param = request.queryParams("cord2");

                if (cord1Param != null && cord2Param != null) {
                    String[] cord1Parts = cord1Param.split(",");
                    String[] cord2Parts = cord2Param.split(",");

                    if (cord1Parts.length != 3 || cord2Parts.length != 3) {
                        response.status(400);
                        response.type("application/json");
                        return "Invalid coordinate format";
                    }

                    int x1 = Integer.parseInt(cord1Parts[0]);
                    int y1 = Integer.parseInt(cord1Parts[1]);
                    int z1 = Integer.parseInt(cord1Parts[2]);
                    int x2 = Integer.parseInt(cord2Parts[0]);
                    int y2 = Integer.parseInt(cord2Parts[1]);
                    int z2 = Integer.parseInt(cord2Parts[2]);

                    int minX = Math.min(x1, x2);
                    int maxX = Math.max(x1, x2);
                    int minY = Math.min(y1, y2);
                    int maxY = Math.max(y1, y2);
                    int minZ = Math.min(z1, z2);
                    int maxZ = Math.max(z1, z2);

                    JsonArray blockArray = new JsonArray();

                    CompletableFuture<Void> future = CompletableFuture.runAsync(() -> IntStream.rangeClosed(minX, maxX).parallel().forEach(x -> IntStream.rangeClosed(minZ, maxZ).parallel().forEach(z -> {
                        Chunk chunk = Bukkit.getWorlds().getFirst().getChunkAt(x >> 4, z >> 4);
                        ChunkSnapshot chunkSnapshot = chunk.getChunkSnapshot(false, true, false);

                        for (int y = minY; y <= maxY; y++) {
                            Material material = chunkSnapshot.getBlockType(x & 15, y, z & 15);
                            if (material.isAir()) {
                                continue;
                            }
                            JsonObject blockInfo = new JsonObject();
                            blockInfo.addProperty("t", material.toString());
                            blockInfo.addProperty("x", x);
                            blockInfo.addProperty("y", y);
                            blockInfo.addProperty("z", z);

                            BlockData blockData = chunkSnapshot.getBlockData(x & 15, y, z & 15);
                            String state = getFormattedState(blockData);
                            if (state != null) {
                                blockInfo.addProperty("s", state);
                            }

                            if (biomeSensitiveBlocks.contains(material)) {
                                Biome biome = chunkSnapshot.getBiome(x & 15, y, z & 15);
                                blockInfo.addProperty("b", biome.toString());
                            }

                            synchronized (blockArray) {
                                blockArray.add(blockInfo);
                            }
                        }
                    })));

                    future.get();

                    response.type("application/json");
                    return gson.toJson(blockArray);
                } else {
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

                    CompletableFuture<Void> future = CompletableFuture.runAsync(() -> IntStream.rangeClosed(chunkXValues[0], chunkXValues[1]).parallel().forEach(chunkX -> IntStream.rangeClosed(chunkZValues[0], chunkZValues[1]).parallel().forEach(chunkZ -> {
                        Chunk chunk = Bukkit.getWorlds().getFirst().getChunkAt(chunkX, chunkZ);
                        ChunkSnapshot chunkSnapshot = chunk.getChunkSnapshot(false, true, false);

                        for (int x = 0; x < 16; x++) {
                            for (int z = 0; z < 16; z++) {
                                for (int y = -1; y <= 319; y++) {
                                    Material material = chunkSnapshot.getBlockType(x, y, z);
                                    if (material.isAir()) {
                                        continue;
                                    }
                                    JsonObject blockInfo = new JsonObject();
                                    blockInfo.addProperty("t", material.toString());
                                    blockInfo.addProperty("x", x + chunk.getX() * 16);
                                    blockInfo.addProperty("y", y);
                                    blockInfo.addProperty("z", z + chunk.getZ() * 16);

                                    BlockData blockData = chunkSnapshot.getBlockData(x, y, z);
                                    String state = getFormattedState(blockData);
                                    if (state != null) {
                                        blockInfo.addProperty("s", state);
                                    }

                                    if (biomeSensitiveBlocks.contains(material)) {
                                        Biome biome = chunkSnapshot.getBiome(x, y, z);
                                        blockInfo.addProperty("b", biome.toString());
                                    }

                                    synchronized (blockArray) {
                                        blockArray.add(blockInfo);
                                    }
                                }
                            }
                        }
                    })));

                    future.get();

                    response.type("application/json");
                    return gson.toJson(blockArray);
                }
            } catch (NumberFormatException | InterruptedException | ExecutionException e) {
                response.status(400);
                response.type("application/json");
                return "Invalid coordinate or chunk parameter";
            }
        });
    }

    private String getFormattedState(BlockData blockData) {
        String fullState = blockData.getAsString();
        int startIndex = fullState.indexOf('[');
        if (startIndex != -1) {
            return fullState.substring(startIndex + 1, fullState.length() - 1);
        }
        return null;
    }
}
