package xyz.crossplayproject;

import org.bukkit.*;
import org.bukkit.entity.Entity;
import org.bukkit.entity.LivingEntity;
import org.bukkit.entity.TNTPrimed;
import com.google.gson.Gson;
import spark.Service;

import java.util.ArrayList;
import java.util.List;

public class EntityHandler {

    public void setupRoutes(Service spark) {
        spark.get("/favicon.ico", (req, res) -> "");

        spark.get("/players", (req, res) -> {
            res.type("application/json");

            List<PlayerPosition> playerPositions = getPlayerPositions();
            Gson gson = new Gson();
            return gson.toJson(playerPositions);
        });

        spark.get("/mobs", (req, res) -> {
            res.type("application/json");

            List<MobPosition> mobDataList = getMobData();
            Gson gson = new Gson();
            return gson.toJson(mobDataList);
        });

        spark.get("/world", (req, res) -> {
            res.type("application/json");

            WorldState worldState = getWorldState();
            Gson gson = new Gson();
            return gson.toJson(worldState);
        });
    }

    private List<PlayerPosition> getPlayerPositions() {
        List<PlayerPosition> positions = new ArrayList<>();
        for (org.bukkit.entity.Player player : Bukkit.getOnlinePlayers()) {
            positions.add(new PlayerPosition(
                    player.getUniqueId().toString(),
                    player.getInventory().getItemInMainHand().getType(),
                    player.getInventory().getItemInOffHand().getType(),
                    player.getLocation().getX(),
                    player.getLocation().getY(),
                    player.getLocation().getZ(),
                    player.getLocation().getYaw(),
                    player.getLocation().getPitch(),
                    player.isSneaking()
            ));
        }
        return positions;
    }

    private List<MobPosition> getMobData() {
        List<MobPosition> mobPositions = new ArrayList<>();
        for (World world : Bukkit.getServer().getWorlds()) {
            for (Chunk chunk : world.getLoadedChunks()) {
                for (Entity entity : chunk.getEntities()) {
                    if (entity instanceof LivingEntity && !(entity instanceof org.bukkit.entity.Player)) {
                        LivingEntity livingEntity = (LivingEntity) entity;
                        String mobType = livingEntity.getType().name();
                        mobPositions.add(new MobPosition(
                                livingEntity.getUniqueId().toString(),
                                livingEntity.getLocation().getX(),
                                livingEntity.getLocation().getY(),
                                livingEntity.getLocation().getZ(),
                                livingEntity.getLocation().getYaw(),
                                livingEntity.getLocation().getPitch(),
                                mobType
                        ));
                    } else if (entity instanceof TNTPrimed) {
                        TNTPrimed primedTNT = (TNTPrimed) entity;
                        Location tntLocation = primedTNT.getLocation();
                        mobPositions.add(new MobPosition(
                                primedTNT.getUniqueId().toString(),
                                tntLocation.getX(),
                                tntLocation.getY(),
                                tntLocation.getZ(),
                                0,
                                0,
                                "PRIMED_TNT"
                        ));
                    }
                }
            }
        }
        return mobPositions;
    }

    private WorldState getWorldState() {
        World world = Bukkit.getServer().getWorlds().get(0);

        long time = world.getTime();
        boolean thundering = world.isThundering();
        boolean raining = world.hasStorm();

        return new WorldState(time, thundering, raining);
    }

    private static class PlayerPosition {
        private String uuid;
        private Material mainItem;
        private Material offItem;
        private double x;
        private double y;
        private double z;
        private float yaw;
        private float pitch;
        private boolean crouch;

        public PlayerPosition(String uuid, Material mainItem, Material offItem, double x, double y, double z, float yaw, float pitch, boolean crouch) {
            this.uuid = uuid;
            this.mainItem = mainItem;
            this.offItem = offItem;
            this.x = x;
            this.y = y;
            this.z = z;
            this.yaw = yaw;
            this.pitch = pitch;
            this.crouch = crouch;
        }
    }

    private static class MobPosition {
        private String uuid;
        private double x;
        private double y;
        private double z;
        private float yaw;
        private float pitch;
        private String mobType;

        public MobPosition(String uuid, double x, double y, double z, float yaw, float pitch, String mobType) {
            this.uuid = uuid;
            this.x = x;
            this.y = y;
            this.z = z;
            this.yaw = yaw;
            this.pitch = pitch;
            this.mobType = mobType;
        }
    }

    private static class WorldState {
        private long time;
        private boolean thundering;
        private boolean raining;

        public WorldState(long time, boolean thundering, boolean raining) {
            this.time = time;
            this.thundering = thundering;
            this.raining = raining;
        }
    }
}